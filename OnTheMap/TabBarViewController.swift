//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 3/6/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    //MARK: Interface Builder Actions
    
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
    
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        // Get current view controller
        guard let vc = selectedViewController as? StudentLocationViewController else {
            //Error
            print("Error accessing selected view controller.")
            return
        }
        // Refresh view controller
        vc.refresh()
    }
    
    @IBAction func newLocationButtonPressed(sender: UIBarButtonItem) {
        let informationPostingView = storyboard!.instantiateViewControllerWithIdentifier("InformationPostingView") as! InformationPostingViewController
        presentViewController(informationPostingView, animated: true, completion: nil)
    }
}