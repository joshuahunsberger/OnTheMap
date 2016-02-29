//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 2/14/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if(email == "" || password == "") {
            // Alert user to enter username and password
            let alert = UIAlertController(title: "Error", message: "Enter a username and password.", preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.dismissViewControllerAnimated(false, completion: nil)
            }
            alert.addAction(dismissAction)
            self.presentViewController(alert, animated: false, completion: nil)
        } else{
            UdacityClient.sharedInstance().postLogin(email, password: password) { (success, error) in
                if(success) {
                    print("Login successful")
                } else {
                    print("Error with login: \(error!)")
                }
            }
        }
    }
    
    
}
