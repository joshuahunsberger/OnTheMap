//
//  OnTheMapTextFieldDelegate.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 3/31/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import UIKit


/**
 A text field delegate for text fields in the app.
 
 Describes how the text fields should behave when the return key is pressed.
 */
class OnTheMapTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    /// Dismisses the keyboard when the return key is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}