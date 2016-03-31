//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 2/17/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : StudentLocationViewController, MKMapViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: View lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let locations = ParseClient.sharedInstance().studentLocations {
            addAnnotations(locations)
        } else {
            refresh()
        }
    }
    
    //MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = MKPinAnnotationView.redPinColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let link = view.annotation?.subtitle! {
                if let url = NSURL(string: link){
                    if(app.canOpenURL(url)) {
                        app.openURL(url)
                    } else {
                        Alert.alert(self, title: "Error", message: "Invalid URL")
                    }
                } else {
                    Alert.alert(self, title: "Error", message: "Invalid URL")
                }
            }
        }
    }

    //MARK:  - Helper functions
    
    func addAnnotations(locations: [StudentLocation]) {
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
    
    //MARK: Refresh
    
    override func refresh() {
        getStudentLocations() { studentLocations in
            // Only update annotations if able to retrieve new list
            if let locations = studentLocations {
                // Perform updates on main thread
                dispatch_async(dispatch_get_main_queue()){
                    // Clear any existing annotations
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    // Add newly retrieved annotations
                    self.addAnnotations(locations)
                }
            }
        }
    }
}