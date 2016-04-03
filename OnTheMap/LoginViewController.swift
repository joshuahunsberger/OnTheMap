//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 2/14/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let attributes = [
        NSForegroundColorAttributeName : UIColor.whiteColor()
    ]
    let textFieldDelegate = OnTheMapTextFieldDelegate()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackground()
        
        // Use an invisible UI View to create padding for the left edge of the text fields.
        // As described by StackOverflow user Evil Trout here: http://stackoverflow.com/a/4423805

        let emailPaddingView = UIView(frame: CGRectMake(0,0,10,30))
        let passwordPaddingView = UIView(frame: CGRectMake(0,0,10,30))
        emailTextField.leftView = emailPaddingView
        emailTextField.leftViewMode = .Always
        passwordTextField.leftView = passwordPaddingView
        passwordTextField.leftViewMode = .Always
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributes)
        
        emailTextField.delegate = textFieldDelegate
        passwordTextField.delegate = textFieldDelegate
        
        hideKeyboardWhenTappedAround()
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        dismissKeyboard()
        
        if(email == "" || password == "") {
            Alert.alert(self, title: "Error", message: "Enter a user name and password.")
        } else {
            loginButton.enabled = false
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.activityIndicatorViewStyle = .WhiteLarge
            view.addSubview(activityIndicator)
            activityIndicator.frame = view.frame
            activityIndicator.center = view.center
            activityIndicator.layer.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.75).CGColor
            activityIndicator.startAnimating()
            
            UdacityClient.sharedInstance().postLogin(email, password: password) { (success, error) in
                if(success) {

                    dispatch_async(dispatch_get_main_queue()){
                        let navController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarNavigationController") as! UINavigationController
                        self.presentViewController(navController, animated: true, completion: nil)
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                        self.loginButton.enabled = true
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                    }
                } else {
                    var errorString: String!
                    
                    if let error = error {
                        errorString = error.localizedDescription
                    } else {
                        errorString = "There was an error completing your login. Please try again."
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        Alert.alert(self, title: "Error", message: errorString)
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                        self.loginButton.enabled = true
                    }
                }
            }
        }
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup")!
        let app = UIApplication.sharedApplication()
        app.openURL(url)
    }
    
    /// Function from the Udacity MovieManager example app to display a gradient background between two colors
    private func configureBackground() {
        let backgroundGradient = CAGradientLayer()
        let colorTop = UIColor(red: 1, green: 152/255, blue: 12/255, alpha: 1.0).CGColor // R 255 G 152 B 12
        let colorBottom = UIColor(red: 1, green: 111/255, blue: 0, alpha: 1.0).CGColor // R 255 G 111 B 0
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
    }
    
}

// Extending UIViewController as suggested by StackOverflow user Esq here: http://stackoverflow.com/a/27079103
// Need to add hideKeyboardWhenTappedAround() to each view controller that wants to tap to dismiss keyboard

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
