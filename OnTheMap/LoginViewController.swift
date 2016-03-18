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
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if(email == "" || password == "") {
            alert("Error", message: "Enter a user name and password.")
        } else {
            loginButton.enabled = false
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.activityIndicatorViewStyle = .Gray
            view.addSubview(activityIndicator)
            activityIndicator.center = view.center
            activityIndicator.startAnimating()
            
            UdacityClient.sharedInstance().postLogin(email, password: password) { (success, error) in
                if(success) {

                    dispatch_async(dispatch_get_main_queue()){
                        let navController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarNavigationController") as! UINavigationController
                        self.presentViewController(navController, animated: true, completion: nil)
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                        self.loginButton.enabled = true
                    }
                } else {
                    var errorString: String!
                    
                    if let error = error {
                        errorString = error.localizedDescription
                    } else {
                        errorString = "Please try again"
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.alert("Error", message: errorString)
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                        self.loginButton.enabled = true
                    }
                }
            }
        }
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        alert.addAction(dismissAction)
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
}
