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
    var mapString: String!
    var latitude: Double!
    var longitude: Double!
    let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
    let textFieldDelegate = OnTheMapTextFieldDelegate()
    
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
        
        state = ViewState.locationEntry
        locationTextField.delegate = textFieldDelegate
        linkTextField.delegate = textFieldDelegate
        
        hideKeyboardWhenTappedAround()
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
    
    func disableUIAndDisplayActivityIndicator() {
        cancelButton.enabled = false
        if(state == ViewState.locationEntry) {
            findButton.enabled = false
        } else {
            submitButton.enabled = false
        }
        
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.frame
        activityIndicator.center = view.center
        activityIndicator.layer.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.75).CGColor
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
            Alert.alert(self, title: "Error", message: "Please enter your location.")
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
                
                Alert.alert(self, title: "Error", message: errorString)
            } else {
                guard let placemarks = placemarks else {
                    self.enableUIAndRemoveActivityIndicator()
                    Alert.alert(self, title: "Error", message: "Unable to find location. Please enter a different location.")
                    return
                }
                if(placemarks.count > 0) {
                    let placemark = placemarks[0]
                    
                    guard let location = placemark.location else {
                        self.enableUIAndRemoveActivityIndicator()
                        Alert.alert(self, title: "Error", message: "Unable to access location. Please try again.")
                        return
                    }
                    
                    self.mapString = address
                    self.latitude = location.coordinate.latitude
                    self.longitude = location.coordinate.longitude
                    
                    self.enableUIAndRemoveActivityIndicator()
                    self.toggleUIState()
                    
                    self.locationMapView.addAnnotation(MKPlacemark(placemark: placemark))
                    self.locationMapView.showAnnotations(self.locationMapView.annotations, animated: true)
                } else {
                    self.enableUIAndRemoveActivityIndicator()
                    Alert.alert(self, title: "Error", message: "No locations found.")
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
            Alert.alert(self, title: "Error", message: "Please enter a link before submitting.")
            return
        }
        
        guard let url = NSURL(string: linkText) where UIApplication.sharedApplication().canOpenURL(url) else {
            enableUIAndRemoveActivityIndicator()
            Alert.alert(self, title: "Error", message: "Cannot convert link to URL. Please submit a valid URL.")
            return
        }
        
        if var existingLocation = UdacityClient.sharedInstance().mostRecentLocation {
            existingLocation.latitude = latitude
            existingLocation.longitude = longitude
            existingLocation.mapString = mapString
            existingLocation.mediaURL = linkText
            
            ParseClient.sharedInstance().putStudentLocation(existingLocation) { (success, error) in
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
                        errorString = "An unknown error occurred. Please try again."
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.enableUIAndRemoveActivityIndicator()
                        Alert.alert(self, title: "Error", message: errorString)
                    }
                }
            }
        } else {
            let dictionary: [String : AnyObject] = [
                ParseClient.JSONKeys.uniqueKey : UdacityClient.sharedInstance().uniqueKey!,
                ParseClient.JSONKeys.firstName : UdacityClient.sharedInstance().userFirstName!,
                ParseClient.JSONKeys.lastname : UdacityClient.sharedInstance().userLastName!,
                ParseClient.JSONKeys.latitude : latitude,
                ParseClient.JSONKeys.longitude : longitude,
                ParseClient.JSONKeys.urlString : linkText,
                ParseClient.JSONKeys.mapString : mapString
            ]
            let newLocation = StudentLocation(studentDictionary: dictionary)

            ParseClient.sharedInstance().postStudentLocation(newLocation) { (success, error) in
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
                        Alert.alert(self, title: "Error", message: errorString)
                    }
                }
            }
        }
    }
}
