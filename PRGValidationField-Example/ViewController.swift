//
//  ViewController.swift
//  PRGValidationField-Example
//
//  Created by John Spiropoulos on 31/01/2017.
//  Copyright © 2017 Programize. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PRGValidationFieldDelegate {
    
    @IBOutlet weak var nameField: PRGValidationField!
    
    @IBOutlet weak var surnameField: PRGValidationField!
    
    @IBOutlet weak var emailField: PRGValidationField!
    
    @IBOutlet weak var passwordField: PRGValidationField!
    
    @IBOutlet weak var confirmPasswordField: PRGValidationField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        passwordField.otherPasswordField = confirmPasswordField
        
        nameField.delegate = self
        surnameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func PRGValidationField(_field: PRGValidationField, didValidateWithResult result: Bool, andErrorMessage errorMessage: String?) {
        
        registerButton.isEnabled = nameField.isValid ?? false && surnameField.isValid ?? false && emailField.isValid ?? false && passwordField.isValid ?? false && confirmPasswordField.isValid ?? false
        
    }
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        print("It works, boo!")
}

}
