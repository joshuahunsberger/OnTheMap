//
//  StudentLocationViewController.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 3/19/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import UIKit

class StudentLocationViewController: UIViewController {
    
    func getStudentLocations(completionHandlerForLocations: ([StudentLocation]?) -> Void ) {
        
        // Display activity view indicator
        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.frame
        activityIndicator.center = view.center
        activityIndicator.layer.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.75).CGColor
        activityIndicator.startAnimating()
        
        // Get new list of student locations from Parse
        ParseClient.sharedInstance().getStudentLocations(100, skip: 0, order: "-updatedAt"){ (success, error) in
            if(success){
                guard let locations = ParseClient.sharedInstance().studentLocations else {
                    dispatch_async(dispatch_get_main_queue()){
                        activityIndicator.stopAnimating()
                        completionHandlerForLocations(nil)
                        Alert.alert(self, title: "Error", message: "Unable to retrieve student locations.")
                    }
                    return
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    activityIndicator.stopAnimating()
                }
                
                completionHandlerForLocations(locations)
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    activityIndicator.stopAnimating()
                    completionHandlerForLocations(nil)
                    guard let error = error else {
                        Alert.alert(self, title: "Error", message: "Unknown error occurred.")
                        return
                    }
                    Alert.alert(self, title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    func refresh() {
        // Implement in subclass
    }
}