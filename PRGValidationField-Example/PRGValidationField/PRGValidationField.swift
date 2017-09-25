//
//  PRGValidationField.swift
//  GRGiOS
//
//  Created by John Spiropoulos on 31/01/2017.
//  Copyright © 2016 Programize. All rights reserved.
//

import UIKit

@objc protocol PRGValidationFieldDelegate: class {
    @objc optional func PRGValidationField(_field: PRGValidationField, didValidateWithResult result: Bool, andErrorMessage errorMessage: String?)
}

enum ValidationMode: Int {
    
    case name = 0,email,password,confirmPassword
    
    func validate(_ text: String, passToConfirm: String?, minimumPasswordLength: Int) -> Bool? {
        if text == "" {
            return nil
        }
        switch self {
        case .name:
            let numberCharacters = CharacterSet.decimalDigits
            return text.replacingOccurrences(of: " ", with: "") != "" && text.rangeOfCharacter(from: numberCharacters) == nil
        case .email:
            return isValidEmail(email: text)
        case .password:
            return text.characters.count >= minimumPasswordLength
        case .confirmPassword:
            return passToConfirm != nil && passToConfirm == text
            }
    }

    func isValidEmail(email: String) -> Bool {
        let regex = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }

}

@IBDesignable
class PRGValidationField: UIView, UITextFieldDelegate {
    
    var view: UIView!
    
    // Outlets
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var valueField: UITextField!
    
    // The view and it's image used to show validation indicators
    private var rightView: UIView!
    private var rightImageView: UIImageView!

    // Minimum length for password field, default value 6
    private var minimumPasswordLength: Int = 6
    
    /* Inspectable variable to set validation mode (See ValidationMode Enum)
     0 = Name , Surname
     1 = Email
     2 = Password
     3 = Confirm PassWord
    */
    @IBInspectable var mode: Int = 0 {
        didSet {
            _mode = mode
            validationMode = ValidationMode(rawValue: mode)!
        }
    }
    
    private var _mode: Int = 0

    // What do you want the user to enter?
   
    @IBInspectable var fieldTitle: String = "Title" {
        didSet {
            titleLabel.text = fieldTitle
        }
    }
    /*
     Title Font: IBInspectables do not cover fonts, If you are using custom fonts
     you can type the name of the font (the same way you would type it programmaticaly)
     followed by a comma (",") and the desired size of the font.
     
     Do not forget to add all custom fonts on Info.plist OR use an awesome library called
     FontBlaster which does that automatically.
     
     If no font is found, the fallback font is the system font.
    */
    
    @IBInspectable var textFont: String = "Helvetica,15" {
        didSet {
            let fontComponents = titleFont.components(separatedBy: ",")
            if fontComponents.count == 2 {
                if let newFont = UIFont(name: fontComponents[0] , size: CGFloat((fontComponents[1] as NSString).doubleValue)) {
                    valueField.font = newFont
                } else {
                    valueField.font = UIFont.systemFont(ofSize: 13)
                }
                
            } else {
                valueField.font = UIFont.systemFont(ofSize: 13)
            }
            
        }
    }

    
    @IBInspectable var titleFont: String = "Helvetica,15" {
        didSet {
            let fontComponents = titleFont.components(separatedBy: ",")
            if fontComponents.count == 2 {
                if let newFont = UIFont(name: fontComponents[0] , size: CGFloat((fontComponents[1] as NSString).doubleValue)) {
                    titleLabel.font = newFont
                } else {
                    titleLabel.font = UIFont.systemFont(ofSize: 15)
                }

            } else {
                titleLabel.font = UIFont.systemFont(ofSize: 15)
            }
            
        }
    }
    
    // Title Color: This is very straightForward.
    @IBInspectable var titleColor: UIColor = .black {
        didSet {
            titleLabel.textColor = titleColor
        }
    }

    // Error Font: Same description as Title Font
    
    @IBInspectable var errorFont: String = "Helvetica,13" {
        didSet {
            let fontComponents = errorFont.components(separatedBy: ",")
            if fontComponents.count == 2 {
                if let newFont = UIFont(name: fontComponents[0] , size: CGFloat((fontComponents[1] as NSString).doubleValue)) {
                    errorLabel.font = newFont
                } else {
                    errorLabel.font = UIFont.systemFont(ofSize: 15)
                }

            } else {
                errorLabel.font = UIFont.systemFont(ofSize: 15)
            }

            
        }
    }
    
    // Error Color: The color of the error message
    
    @IBInspectable var errorColor: UIColor = .red {
        didSet {
            errorLabel.textColor = errorColor
        }
    }

    // Hide / Show Error message
    @IBInspectable var hideError: Bool = true {
        didSet {
            errorLabel.isHidden = hideError
        }
    }
    
    // The error message to appear if validation fails
    @IBInspectable var errorMessage: String = "Error Message"{
        didSet {
            errorLabel.text = errorMessage
            view.layoutIfNeeded()
        }
    }
    
    // The textField Placeholder
    @IBInspectable var placeholder: String = "" {
        didSet {
            valueField.placeholder = placeholder
        }
    }
    
    // Default UI
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            valueField.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            valueField.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.darkGray {
        didSet {
            valueField.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var bgColor: UIColor = UIColor.white {
        didSet {
            valueField.backgroundColor = bgColor
        }
    }
    
    @IBInspectable var textColor: UIColor = UIColor.black {
        didSet {
            valueField.textColor = textColor
        }
    }
    
    // UI Changes when value is valid
    @IBInspectable var validBorderColor: UIColor = UIColor.green
    @IBInspectable var validBgColor: UIColor = UIColor.green
    @IBInspectable var validTextColor: UIColor = UIColor.green
    @IBInspectable var validImage: UIImage? = UIImage(named: "PRGVFValid")
    
    // UI Changes when value is invalid
    @IBInspectable var invalidBorderColor: UIColor = UIColor.red
    @IBInspectable var invalidBgColor: UIColor = UIColor.red
    @IBInspectable var invalidTextColor: UIColor = UIColor.red
    @IBInspectable var invalidImage: UIImage? = UIImage(named: "PRGVFInvalid")

    // Minimum length for password field
    @IBInspectable var passwordMinLength: Int = 6 {
        didSet {
            minimumPasswordLength = passwordMinLength
        }
    }
    
    // getter for textfield's text
    public var text: String? {
        get {
            return valueField.text
        }
    }
    
    /* we set this in order for password and confirmpassword to be able to see
     NOTE: Only set one of two fields. Only password field or confirm password field
    */
    weak var otherPasswordField: PRGValidationField? {
        didSet {
            if otherPasswordField?.otherPasswordField == nil {
            otherPasswordField?.otherPasswordField = self
            }
        }
    }
    
    /*
     isValid:
     Getter: Get wether the field value is valid
     Setter: Set the value, adjust UI and call delegate callbacks
    */
    
    private var _isValid: Bool?
    
    var isValid: Bool? {
        get {
            return _isValid ?? false
        }
        set {
            _isValid = newValue
            switch newValue {
            case true?:
                valueField.textColor = validTextColor
                valueField.layer.borderColor = validBorderColor.cgColor
                valueField.backgroundColor = validBgColor.withAlphaComponent(0.2)
                rightImageView.image = validImage
                errorLabel.isHidden = true
                if delegate != nil {
                  delegate!.PRGValidationField?(_field: self, didValidateWithResult: true, andErrorMessage: nil)
                }
            case false?:
                valueField.textColor = invalidTextColor
                valueField.layer.borderColor = invalidBorderColor.cgColor
                valueField.backgroundColor = invalidBgColor.withAlphaComponent(0.2)
                rightImageView.image = invalidImage
                errorLabel.isHidden = false
                if delegate != nil {
                    delegate!.PRGValidationField?(_field: self, didValidateWithResult: false, andErrorMessage: self.errorMessage)
                }
            case nil:
                valueField.layer.borderColor = borderColor.cgColor
                valueField.backgroundColor = bgColor
                valueField.textColor = textColor
                errorLabel.isHidden = true
                rightImageView.image = nil
                if delegate != nil {
                    delegate!.PRGValidationField?(_field: self, didValidateWithResult: false, andErrorMessage: self.errorMessage)
                }
            }
        }
    }
    
    /*
     ValidationMode:
     Used to setup and validate the field (See ValidationMode Enum)
    */
    
    var validationMode: ValidationMode = .name {
        didSet {
            _mode = validationMode.rawValue
            
            switch validationMode {
            case .password,.confirmPassword:
                valueField.isSecureTextEntry = true
                valueField.keyboardType = .default
            case .email:
                valueField.isSecureTextEntry = false
                valueField.keyboardType = .emailAddress
            default:
                valueField.keyboardType = .default
                valueField.isSecureTextEntry = false
            }
        }
    }
    
    weak var delegate: PRGValidationFieldDelegate?
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        validationMode = ValidationMode(rawValue: _mode)!
        setupTextField()
        
        addSubview(view)
    }
    
    
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PRGValidationField", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func setupTextField() {
        valueField.layer.borderWidth = borderWidth
        valueField.layer.borderColor = borderColor.cgColor
        valueField.backgroundColor = bgColor
        valueField.textColor = textColor
        valueField.layer.cornerRadius = cornerRadius
        valueField.autocapitalizationType = .none
        valueField.autocorrectionType = .no
        valueField.leftViewMode = .always
        valueField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 30))
        valueField.rightViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        rightImageView.contentMode = .scaleAspectFit
        rightView.addSubview(rightImageView)
        valueField.rightView = rightView
        valueField.addTarget(self, action: #selector(textFieldDidEdit(_:)), for: .editingChanged)
        valueField.delegate = self
        valueField.returnKeyType = .done
        
    }
    
    @objc func textFieldDidEdit(_ textField: UITextField) {
        valueField.layer.borderColor = borderColor.cgColor
        valueField.backgroundColor = bgColor
        valueField.textColor = textColor
        rightImageView.image = nil
        if validationMode == .password {
            otherPasswordField?.valueField.text = ""
            otherPasswordField?.isValid = nil
        }
        if validationMode == .confirmPassword {
            if validationMode.validate(textField.text!,
                                       passToConfirm: otherPasswordField?.text,
                                       minimumPasswordLength: minimumPasswordLength) == true {
                _ = textFieldShouldReturn(textField)
            } else {
                isValid = nil
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isValid = validationMode.validate(textField.text!,
                                          passToConfirm: otherPasswordField?.text,
                                          minimumPasswordLength: minimumPasswordLength)
    }
   
}
