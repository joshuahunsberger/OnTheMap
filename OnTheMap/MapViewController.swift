//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 2/17/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : UIViewController, MKMapViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: View lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshStudentLocationData()
        
        if let locations = ParseClient.sharedInstance().studentLocations {
            addAnnotations(locations)
        } else {
            refreshStudentLocationData()
        }
    }

    //MARK:  - Helper functions
    
    func addAnnotations(locations: [StudentLocation]){
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func refreshStudentLocationData() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.activityIndicatorViewStyle = .Gray
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        ParseClient.sharedInstance().getStudentLocations(100, skip: 0, order: "-updatedAt"){ (success, error) in
            if(success){
                guard let locations = ParseClient.sharedInstance().studentLocations else {
                    dispatch_async(dispatch_get_main_queue()){
                        activityIndicator.stopAnimating()
                        self.alert("Error", message: "Can't access locations")
                    }
                    return
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    activityIndicator.stopAnimating()
                    self.addAnnotations(locations)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    activityIndicator.stopAnimating()
                    self.alert("Error", message: error!.localizedDescription)
                }
            }
        }
    }
    
    //MARK: Alert
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        alert.addAction(dismissAction)
        self.presentViewController(alert, animated: false, completion: nil)
    }
}