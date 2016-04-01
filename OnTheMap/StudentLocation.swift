//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 3/3/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

/**
    Struct that represents the StudentLocation object retrieved from the Parse API
*/

struct StudentLocation {
    
    //MARK: Properties
    
    let uniqueKey: String!
    let firstName: String
    let lastName: String
    let mapString: String!
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
    //MARK: Initializers
    
    init(studentDictionary: [String: AnyObject]) {
        firstName = studentDictionary[ParseClient.JSONKeys.firstName] as! String
        lastName = studentDictionary[ParseClient.JSONKeys.lastname] as! String
        latitude = studentDictionary[ParseClient.JSONKeys.latitude] as! Double
        longitude = studentDictionary[ParseClient.JSONKeys.longitude] as! Double
        mediaURL = studentDictionary[ParseClient.JSONKeys.urlString] as! String
        
        uniqueKey = studentDictionary[ParseClient.JSONKeys.uniqueKey] as! String
        mapString = studentDictionary[ParseClient.JSONKeys.mapString] as! String
    }
    
    init(firstName: String, lastName: String, latitude: Double, longitude: Double, mediaURL: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mediaURL = mediaURL
        
        // Initialize other properties to nil
        self.uniqueKey = nil
        self.mapString = nil
    }
    
}