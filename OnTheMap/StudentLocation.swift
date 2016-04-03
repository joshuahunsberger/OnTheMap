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
    
    let objectID: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    
    //MARK: Initializers
    
    init(studentDictionary: [String: AnyObject]) {
        firstName = studentDictionary[ParseClient.JSONKeys.firstName] as! String
        lastName = studentDictionary[ParseClient.JSONKeys.lastname] as! String
        latitude = studentDictionary[ParseClient.JSONKeys.latitude] as! Double
        longitude = studentDictionary[ParseClient.JSONKeys.longitude] as! Double
        mediaURL = studentDictionary[ParseClient.JSONKeys.urlString] as! String
        objectID = studentDictionary[ParseClient.JSONKeys.objectId] as! String
        uniqueKey = studentDictionary[ParseClient.JSONKeys.uniqueKey] as! String
        mapString = studentDictionary[ParseClient.JSONKeys.mapString] as! String
    }
    
}