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
    
    //MARK: Interface Builder Action functions
    
    @IBAction func findButtonPressed(sender: AnyObject) {
        let address = locationTextField.text!
        
        if(address.isEmpty) {
            //TODO: Show an alert to user to enter address string
            print("No location entered.")
        } else {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    guard let placemarks = placemarks else {
                        print("No placemarks.")
                        return
                    }
                    if(placemarks.count > 0) {
                        let placemark = placemarks[0]
                        self.latitude = placemark.location?.coordinate.latitude
                        self.longitude = placemark.location?.coordinate.longitude
                        self.toggleUIState()
                        self.locationMapView.addAnnotation(MKPlacemark(placemark: placemark))
                        self.locationMapView.showAnnotations(self.locationMapView.annotations, animated: true)
                        
                    }
                }
            })
        }
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        submitButton.enabled = false
        cancelButton.enabled = false
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.activityIndicatorViewStyle = .Gray
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        let linkText = linkTextField.text!
        
        if(linkText == "") {
            //TODO: Alert user to enter a link
            print("Enter a link")
            return
        }
        
        guard let _ = NSURL(string: linkText) else {
            //TODO: Alert user to enter a valid link
            print("Can't convert to URL")
            return
        }
        
        let location = StudentLocation(firstName: UdacityClient.sharedInstance().userFirstName!, lastName: UdacityClient.sharedInstance().userLastName!, latitude: latitude!, longitude: longitude!, mediaURL: linkText)
        
        ParseClient.sharedInstance().postStudentLocation(location) { (success, error) in
            if(success) {
                dispatch_async(dispatch_get_main_queue()) {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                var errorString: String!
                
                if let error = error {
                    errorString = error.localizedDescription
                } else {
                    errorString = "Please try again"
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    // TODO: Display alert
                    print("Error posting data: \(errorString)")
                    
                    self.submitButton.enabled = true
                    self.cancelButton.enabled = true
                }
            }
            
            
        }
    }
}
