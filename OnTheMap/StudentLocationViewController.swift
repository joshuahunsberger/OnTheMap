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
        //let studentLocations = [StudentLocation]()
        
        // Display activity view indicator
        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.activityIndicatorViewStyle = .Gray
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        // Get new list of student locations from Parse
        ParseClient.sharedInstance().getStudentLocations(100, skip: 0, order: "-updatedAt"){ (success, error) in
            if(success){
                guard let locations = ParseClient.sharedInstance().studentLocations else {
                    dispatch_async(dispatch_get_main_queue()){
                        activityIndicator.stopAnimating()
                        completionHandlerForLocations(nil)
                        //TODO: Display error
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
                    //TODO: Display error
                }
            }
        }
    }
    
    func refresh() {
        // Implement in subclass
    }
}