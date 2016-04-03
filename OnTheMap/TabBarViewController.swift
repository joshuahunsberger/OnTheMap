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
        self.dismissViewControllerAnimated(true, completion: nil)

        UdacityClient.sharedInstance().deleteSession() { (success, error) in
            if(!success) {
                print("Error while logging out. \(error!.localizedDescription)")
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
        if UdacityClient.sharedInstance().mostRecentLocation != nil {
            var message = "There is alread a Student Location posted for user "
            message += "\(UdacityClient.sharedInstance().userFirstName!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())) "
            message += "\(UdacityClient.sharedInstance().userLastName!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())). "
            message += "Do you wish to overwrite this location?"
            let alert = UIAlertController(title: "Existing Location", message: message, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            let overwriteAction = UIAlertAction(title: "Overwrite", style: .Destructive) { (action) in
                let informationPostingView = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingView") as! InformationPostingViewController
                self.presentViewController(informationPostingView, animated: true, completion: nil)
            }
            alert.addAction(overwriteAction)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
        } else {
            let informationPostingView = storyboard!.instantiateViewControllerWithIdentifier("InformationPostingView") as! InformationPostingViewController
            presentViewController(informationPostingView, animated: true, completion: nil)
        }
    }
}