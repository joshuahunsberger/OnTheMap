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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func toggleUIState() {
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
                        
                        self.locationMapView.addAnnotation(MKPlacemark(placemark: placemark))
                        self.toggleUIState()
                    }
                }
            })
        }
    }
}
