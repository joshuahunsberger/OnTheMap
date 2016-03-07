//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 3/6/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().deleteSession() { (success, error) in
            if(!success) {
                print("Error while logging out. \(error!.localizedDescription)")
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}