//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 3/3/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import Foundation

// MARK: ParseClient (Convenience Methods)

extension ParseClient {
    
    func getStudentLocations(limit: Int, skip: Int, order: String, completionHandlerForGetLocations: (success: Bool, error: NSError?) -> Void) {
        
        let parameters : [String: AnyObject] = [
            ParameterKeys.resultLimit : limit,
            ParameterKeys.numResultsToSkip : skip,
            ParameterKeys.orderBy : order
        ]
        
        taskForGetMethod(Methods.studentLocations, parameters: parameters) { (results, error) in
            
            if let error = error {
                completionHandlerForGetLocations(success: false, error: error)
            } else {
                guard let locationsList = results[JSONKeys.results] as? [NSDictionary] else {
                    completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse results list."]))
                    return
                }
                
                var studentLocations: [StudentLocation] = [StudentLocation]()
                
                for location in locationsList {
                    // Extract values from JSON Student Location dictionary
                    guard let firstName = location[JSONKeys.firstName] as? String else {
                        completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse first name."]))
                        return
                    }
                    
                    guard let lastName = location[JSONKeys.lastname] as? String else {
                        completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse last name."]))
                        return
                    }
                    
                    guard let latitude = location[JSONKeys.latitude] as? Double else {
                        completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse latitude."]))
                        return
                    }
                    
                    guard let longitude = location[JSONKeys.longitude] as? Double else {
                        completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse longitude."]))
                        return
                    }
                    
                    guard let url = location[JSONKeys.urlString] as? String else {
                        completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse URL."]))
                        return
                    }
                    
                    let student = StudentLocation(firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mediaURL: url)
                    studentLocations.append(student)
                }
                
                self.studentLocations = studentLocations
                completionHandlerForGetLocations(success: true, error: nil)
            }
        }
    }
    
    //TODO: Create method to send student location with POST
    func postStudentLocation(location: StudentLocation, completionHandlerForPostLocation: (success: Bool, error: NSError?) -> Void) {
        
        let jsonBody = "{\"\(JSONKeys.uniqueKey)\": \"\(location.uniqueKey)\", \"firstName\": \"\(location.firstName)\", \"lastName\": \"\(location.lastName)\",\"mapString\": \"\(location.mapString!)\", \"mediaURL\": \"\(location.mediaURL)\",\"latitude\": \(location.latitude), \"longitude\": \(location.longitude)}"

        
        taskForPostMethod(Methods.studentLocations, parameters: nil, jsonBody: jsonBody){ (results, error) in
            
            
        }
    }
}