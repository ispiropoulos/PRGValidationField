# PRGValidationField

`PRGValidationField` is a flexible and customizable implementation of a self validating Text Field.

It is written in Swift 3.0 and Compatible with iOS 9.0+

![](/PRGValidationField.gif)

## Usage

To start using the component add it to your project manually as per the [Installation](#installation) section.

The UI component can be used via the `PRGValidationField` class. 

To create an instance of the class, drag a UIView from the Interface builder and set it's class to PRGValidationField.
`PRGValidationField` is `@IBDesinable` and customizable via `@IBInspectable` properties, this way almost everything can be done via the interface builder.
![](/Example1.png)

The properties are pretty straightforward and documented in-code but here are the most important things you need to know:

### Appearance
#### fieldTitle:
The title of the Field, for example: "Email Address"
```swift
 @IBInspectable var fieldTitle: String
```
#### titleFont, errorFont, textFont:
The fonts used for the Field's Title, The Error Message and The Field itself.

As `@IBInspectable`'s do not cover fonts, If you are using custom fonts you can type the name of the font (the same way you would type it programmaticaly) followed by a comma (",") and the desired size of the font. Do not forget to add all custom fonts on Info.plist OR use an awesome library called FontBlaster which does that automatically.

If the font you supplied is not found, the fallback font is the system font.
```swift
@IBInspectable var textFont: String
@IBInspectable var titleFont: String
@IBInspectable var errorFont: String 
```

#### titleColor, errorColor:
The color of the Field's Title and Error Message.
```swift
@IBInspectable var titleColor: UIColor
@IBInspectable var errorColor: UIColor
```
#### bgColor, borderColor, textColor
The DEFAULT color of the Field's Background, Border and it's Text.
```swift
@IBInspectable var bgColor: UIColor
@IBInspectable var borderColor: UIColor
@IBInspectable var textColor: UIColor
```

#### validBgColor, validBorderColor, validTextColor, validImage
The [VALID] state color of the Field's Background, Border, Text as well as the right view indicator image
```swift
@IBInspectable var validBorderColor: UIColor
@IBInspectable var validBgColor: UIColor
@IBInspectable var validTextColor: UIColor
@IBInspectable var validImage: UIImage
```
#### invalidBgColor, invalidBorderColor, invalidTextColor, invalidImage
The [INVALID] state color of the Field's Background, Border, Text as well as the right view indicator image
```swift
@IBInspectable var invalidBorderColor: UIColor
@IBInspectable var invalidBgColor: UIColor
@IBInspectable var invalidTextColor: UIColor
@IBInspectable var invalidImage: UIImage
```

### Internal Stuff
#### validationMode
You can set the validation mode programmaticaly:
```swift
enum ValidationMode: Int {
    case name = 0,email,password,confirmPassword
}

nameField.validationMode = .name
```
#### mode
`@IBInspectable` property to set validation mode (See ValidationMode Enum)
```
     0 = Name , Surname
     1 = Email
     2 = Password
     3 = Confirm PassWord
```
#### text
Getter for the text field's text
```swift
public var text: String?
```

#### otherPasswordField
Set this in order for "Password" and "Confirm Password" fields to be able to see each other.
NOTE: Only set one of two fields. Only password field or confirm password field

```swift
weak var otherPasswordField: PRGValidationField
```

#### isValid
Get the validation status of the Text Field
```swift
var isValid: Bool?
```

#### PRGValidationFieldDelegate
There is one optional callback function:
```swift
@objc optional func PRGValidationField(_field: PRGValidationField, didValidateWithResult result: Bool, andErrorMessage errorMessage: String?)
```
## Installation
#### Manual
Just clone this repo and copy the PRGValidationField folder into your project.

#### Cocoapods
Coming soon.

## Contributing

We welcome all contributions. Please contanct me or submit a pull request, and I will give you an e-Cookie :)

## License
`PRGValidationField` is made for Programize LLC by John Spiropoulos and it is available under the MIT license.
