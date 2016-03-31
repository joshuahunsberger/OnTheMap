//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 2/17/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InformationPostingViewController: UIViewController {
    
    // Enumeration to indicate which state the view should be in
    enum ViewState {
        case locationEntry
        case linkEntry
    }
    
    //MARK: Properties
    
    var state: ViewState!
    let blueColor = UIColor(red: 61/255, green: 118/255, blue: 167/255, alpha: 1)
    let grayColor = UIColor(red: 217/255, green: 217/255, blue: 213/255, alpha: 1)
    var latitude: Double!
    var longitude: Double!
    let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
    
    //MARK: Interface Builder Outlets
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        state = ViewState.locationEntry
    }
    
    //MARK: Helper functions
    
    func toggleUIState() {
        // Switch state and view colors
        if(state == ViewState.locationEntry) {
            state = ViewState.linkEntry
            topView.backgroundColor = blueColor
            bottomView.alpha = 0.25
            cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        } else {
            state = ViewState.locationEntry
            topView.backgroundColor = grayColor
            bottomView.alpha = 1
            cancelButton.setTitleColor(blueColor, forState: UIControlState.Normal)
        }
        
        // Toggle hidden state of elements
        
        whereLabel.hidden = !whereLabel.hidden
        studyingLabel.hidden = !studyingLabel.hidden
        todayLabel.hidden = !todayLabel.hidden
        locationTextField.hidden = !locationTextField.hidden
        findButton.hidden = !findButton.hidden
        
        linkTextField.hidden = !linkTextField.hidden
        locationMapView.hidden = !locationMapView.hidden
        submitButton.hidden = !submitButton.hidden
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(dismissAction)
        self.presentViewController(alert, animated: false, completion: nil)
    }
    
    func disableUIAndDisplayActivityIndicator() {
        cancelButton.enabled = false
        if(state == ViewState.locationEntry) {
            findButton.enabled = false
        } else {
            submitButton.enabled = false
        }
        
        activityIndicator.activityIndicatorViewStyle = .Gray
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
    }
    
    func enableUIAndRemoveActivityIndicator() {
        cancelButton.enabled = true
        if(state == ViewState.locationEntry) {
            findButton.enabled = true
        } else {
            submitButton.enabled = true
        }
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
    }
    
    func dismiss() {
        if let navController = presentingViewController as? UINavigationController {
            if let tab = navController.viewControllers[0] as? TabBarViewController {
                if let vc = tab.selectedViewController as? StudentLocationViewController {
                    dismissViewControllerAnimated(true) {
                        vc.refresh()
                        return
                    }
                }
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Interface Builder Action functions
    
    @IBAction func findButtonPressed(sender: AnyObject) {
        disableUIAndDisplayActivityIndicator()
        
        let address = locationTextField.text!
        
        if(address == "" || address == "Enter your location here.") {
            enableUIAndRemoveActivityIndicator()
            alert("Error", message: "Please enter your location.")
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let error = error {
                self.enableUIAndRemoveActivityIndicator()
                
                // CL Error Handling from user Martin R on StackOverflow:
                // http://stackoverflow.com/questions/24509621/swift-corelocation-handling-nserror-in-didfailwitherror
                let errorString: String!
                
                if let clErr = CLError(rawValue: error.code) {
                    switch clErr {
                    case .Network:
                        errorString = "Network error occurred."
                    case .GeocodeCanceled:
                        errorString = "Geocoding request was canceled."
                    case .GeocodeFoundNoResult:
                        errorString = "Location was not found."
                    case .GeocodeFoundPartialResult:
                        errorString = "Geocoding request only yielded partial result."
                    default:
                        errorString = "Unknown location error."
                    }
                } else {
                    errorString = "An unknown error occurred."
                }
                
                self.alert("Error", message: "There was and issue finding the location: \(errorString)")
            } else {
                guard let placemarks = placemarks else {
                    self.enableUIAndRemoveActivityIndicator()
                    self.alert("Error", message: "Unable to find location. Please enter a different location.")
                    return
                }
                if(placemarks.count > 0) {
                    let placemark = placemarks[0]
                    
                    guard let location = placemark.location else {
                        self.enableUIAndRemoveActivityIndicator()
                        self.alert("Error", message: "Unable to access location. Please try again.")
                        return
                    }
                    
                    self.latitude = location.coordinate.latitude
                    self.longitude = location.coordinate.longitude
                    
                    self.enableUIAndRemoveActivityIndicator()
                    self.toggleUIState()
                    
                    self.locationMapView.addAnnotation(MKPlacemark(placemark: placemark))
                    self.locationMapView.showAnnotations(self.locationMapView.annotations, animated: true)
                } else {
                    self.enableUIAndRemoveActivityIndicator()
                    self.alert("Error", message: "No locations found.")
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismiss()
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        disableUIAndDisplayActivityIndicator()
        
        let linkText = linkTextField.text!
        
        if(linkText == "" || linkText == "Share a link here.") {
            enableUIAndRemoveActivityIndicator()
            alert("Error", message: "PLease enter a link before submitting.")
            return
        }
        
        guard let _ = NSURL(string: linkText) else {
            enableUIAndRemoveActivityIndicator()
            alert("Error", message: "Cannot convert link to URL. Please submit a valid URL.")
            return
        }
        
        let location = StudentLocation(firstName: UdacityClient.sharedInstance().userFirstName!, lastName: UdacityClient.sharedInstance().userLastName!, latitude: latitude!, longitude: longitude!, mediaURL: linkText)
        
        ParseClient.sharedInstance().postStudentLocation(location) { (success, error) in
            if(success) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.enableUIAndRemoveActivityIndicator()
                    self.dismiss()
                }
            } else {
                var errorString: String!
                
                if let error = error {
                    errorString = error.localizedDescription
                } else {
                    errorString = "Please try again"
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.enableUIAndRemoveActivityIndicator()
                    self.alert("Error", message: errorString)
                }
            }
        }
    }
}
