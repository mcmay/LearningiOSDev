// 
//  Copyright © 2020 Big Nerd Ranch
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer! // This is needed to add the tapGestureRecognizer view to the view hierarchy
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    } ()
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("ConversionViewController laoded its view.")
        updateCelsiusLabel()
    }
    
    @IBAction func fahrenheitFieldEditingChanged (_ textField: UITextField) {
        //celsiusLabel.text = textFiled.text
        /*if let text = textFiled.text, !text.isEmpty {
            celsiusLabel.text = text
        } else {
            celsiusLabel.text = "???"
        }*/
        //if let text = textFiled.text, let value = Double(text) {
            //fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    @IBAction func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    func updateCelsiusLabel () {
        if let celsiusValue = celsiusValue {
            //celsiusLabel.text = "\(celsiusValue.value)"
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    func textField (_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //print("Current text: \(String(describing: textField.text))")
        //print("Replacement text: \(string)")
        //let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        //let replacementTextHasDecimalSeparator = string.range(of: ".")
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        for ch in string.unicodeScalars {
            if CharacterSet.letters.contains(ch) {
                return false
            }
        }
        
        if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
            return false
        }
        return true
    }
}

