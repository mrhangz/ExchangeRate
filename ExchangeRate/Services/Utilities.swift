//
//  Utilities.swift
//  ExchangeRate
//
//  Created by Teerawat Vanasapdamrong on 14/2/2565 BE.
//

import UIKit

class Utilities {
    static func addKeyboardDoneButton(sender: AnyObject, textField: UITextField?) {
        guard let textField = textField else {
            return
        }
        
        let keypadToolbar: UIToolbar = UIToolbar()
        
        keypadToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: sender, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: textField, action: #selector(UITextField.resignFirstResponder))
        ]
        keypadToolbar.sizeToFit()
        textField.inputAccessoryView = keypadToolbar
    }
}
