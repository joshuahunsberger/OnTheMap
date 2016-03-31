//
//  Alert.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 3/31/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import UIKit

struct Alert {
    static func alert(presentingViewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(dismissAction)
        presentingViewController.presentViewController(alert, animated: false, completion: nil)
    }
}