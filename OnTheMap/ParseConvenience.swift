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
                guard let locationsList = results[JSONKeys.results] as? [[String: AnyObject]] else {
                    completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse results list."]))
                    return
                }
                
                var studentLocations: [StudentLocation] = [StudentLocation]()
                
                for location in locationsList {
                    // Check for required values from JSON Student Location dictionary
                    guard let _ = location[JSONKeys.firstName] as? String else {
                        completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse first name."]))
                        return
                    }
                    
                    guard let _ = location[JSONKeys.lastname] as? String else {
                        completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse last name."]))
                        return
                    }
                    
                    guard let _ = location[JSONKeys.latitude] as? Double else {
                        completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse latitude."]))
                        return
                    }
                    
                    guard let _ = location[JSONKeys.longitude] as? Double else {
                        completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse longitude."]))
                        return
                    }
                    
                    guard let _ = location[JSONKeys.urlString] as? String else {
                        completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse URL."]))
                        return
                    }
                    
                    guard let _ = location[JSONKeys.objectId] as? String else {
                        completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse objectID."]))
                        return
                    }
                    
                    guard let _ = location[JSONKeys.uniqueKey] as? String else {
                        completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse uniqueKey."]))
                        return
                    }
                    
                    guard let _ = location[JSONKeys.mapString] as? String else {
                        completionHandlerForGetLocations(success: false, error: NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse mapString."]))
                        return
                    }
                    
                    let student = StudentLocation(studentDictionary: location)
                    studentLocations.append(student)
                }
                
                self.studentLocations = studentLocations
                self.queryStudentLocationByUniqueKey(UdacityClient.sharedInstance().uniqueKey!, completionHandlerForQueryLocation: completionHandlerForGetLocations)
                //completionHandlerForGetLocations(success: true, error: nil)
            }
        }
    }
    
    func postStudentLocation(location: StudentLocation, completionHandlerForPostLocation: (success: Bool, error: NSError?) -> Void) {
        
        var jsonBody = "{\"\(JSONKeys.uniqueKey)\": \"\(location.uniqueKey)\", "
        jsonBody += "\"\(JSONKeys.firstName)\": \"\(location.firstName)\", "
        jsonBody += "\"\(JSONKeys.lastname)\": \"\(location.lastName)\", "
        jsonBody += "\"\(JSONKeys.mapString)\": \"\(location.mapString)\", "
        jsonBody += "\"\(JSONKeys.urlString)\": \"\(location.mediaURL)\", "
        jsonBody += "\"\(JSONKeys.latitude)\": \(location.latitude), "
        jsonBody += "\"\(JSONKeys.longitude)\": \(location.longitude)}"
        
        taskForPostMethod(Methods.studentLocations, parameters: nil, jsonBody: jsonBody){ (results, error) in
            
            if let error = error {
                completionHandlerForPostLocation(success: false, error: error)
            } else {
                guard let _ = results[JSONKeys.objectId] as? String else {
                    completionHandlerForPostLocation(success: false, error: NSError(domain: "postStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse object ID."]))
                    return
                }
                
                UdacityClient.sharedInstance().mostRecentLocation = location
                completionHandlerForPostLocation(success: true, error: nil)
            }
            
        }
    }
    
    func queryStudentLocationByUniqueKey(key: String, completionHandlerForQueryLocation: (success: Bool, error: NSError?) -> Void) {
        
        let parameters: [String: AnyObject] = [
            "where" : "{\"uniqueKey\":\"\(key)\"}",
            "order" : "-updatedAt",
            "limit" : 1
        ]
        
        taskForGetMethod(Methods.studentLocations, parameters: parameters) { (results, error) in
            guard error == nil else {
                completionHandlerForQueryLocation(success: false, error: error)
                return
            }
            
            guard let locationList = results[JSONKeys.results] as? [[String: AnyObject]] else {
                completionHandlerForQueryLocation(success: false, error: NSError(domain: "queryStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse results list."]))
                return
            }
            
            if(!locationList.isEmpty){
                // Existing post, check values
                let location = locationList[0]
                
                guard let _ = location[JSONKeys.firstName] as? String else {
                    completionHandlerForQueryLocation(success: false, error: NSError(domain: "queryStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse first name."]))
                    return
                }
                
                guard let _ = location[JSONKeys.lastname] as? String else {
                    completionHandlerForQueryLocation(success: false, error: NSError(domain: "queryStudentLocations parsing", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not parse last name."]))
                    return
                }
                
                guard let _ = location[JSONKeys.latitude] as? Double else {
                    completionHandlerForQueryLocation(success: false, error: NSError(domain: "queryStudentLocations parsing", code: 3, userInfo: [NSLocalizedDescriptionKey: "Could not parse latitude."]))
                    return
                }
                
                guard let _ = location[JSONKeys.longitude] as? Double else {
                    completionHandlerForQueryLocation(success: false, error: NSError(domain: "queryStudentLocations parsing", code: 4, userInfo: [NSLocalizedDescriptionKey: "Could not parse longitude."]))
                    return
                }
                
                guard let _ = location[JSONKeys.urlString] as? String else {
                    completionHandlerForQueryLocation(success: false, error: NSError(domain: "queryStudentLocations parsing", code: 5, userInfo: [NSLocalizedDescriptionKey: "Could not parse URL."]))
                    return
                }
                
                guard let _ = location[JSONKeys.objectId] as? String else {
                    completionHandlerForQueryLocation(success: false, error: NSError(domain: "queryStudentLocations parsing", code: 6, userInfo: [NSLocalizedDescriptionKey: "Could not parse objectID."]))
                    return
                }
                
                guard let _ = location[JSONKeys.uniqueKey] as? String else {
                    completionHandlerForQueryLocation(success: false, error: NSError(domain: "queryStudentLocations parsing", code: 7, userInfo: [NSLocalizedDescriptionKey: "Could not parse uniqueKey."]))
                    return
                }
                
                guard let _ = location[JSONKeys.mapString] as? String else {
                    completionHandlerForQueryLocation(success: false, error: NSError(domain: "queryStudentLocations parsing", code: 8, userInfo: [NSLocalizedDescriptionKey: "Could not parse mapString."]))
                    return
                }
                
                UdacityClient.sharedInstance().mostRecentLocation = StudentLocation(studentDictionary: location)
                
                completionHandlerForQueryLocation(success: true, error: nil)
            }
        }
    }
    
    func putStudentLocation(location: StudentLocation, completionHandlerForPutLocation: (success: Bool, error: NSError?) -> Void) {
        let objectID = location.objectID
        let method = Methods.specificStudentLocation.stringByReplacingOccurrencesOfString("{key}", withString: objectID)
        
        
        var jsonBody = "{\"\(JSONKeys.uniqueKey)\": \"\(location.uniqueKey)\", "
        jsonBody += "\"\(JSONKeys.firstName)\": \"\(location.firstName)\", "
        jsonBody += "\"\(JSONKeys.lastname)\": \"\(location.lastName)\", "
        jsonBody += "\"\(JSONKeys.mapString)\": \"\(location.mapString)\", "
        jsonBody += "\"\(JSONKeys.urlString)\": \"\(location.mediaURL)\", "
        jsonBody += "\"\(JSONKeys.latitude)\": \(location.latitude), "
        jsonBody += "\"\(JSONKeys.longitude)\": \(location.longitude)}"
        
        taskForPutMethod(method, parameters: nil, jsonBody: jsonBody) { (results, error) in
            guard error == nil else {
                completionHandlerForPutLocation(success: false, error: error)
                return
            }
            
            guard let _ = results[JSONKeys.updatedAt] as? String else {
                completionHandlerForPutLocation(success: false, error: NSError(domain: "putStudentLocation parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse updated time."]))
                return
            }
            
            UdacityClient.sharedInstance().mostRecentLocation = location
            completionHandlerForPutLocation(success: true, error: nil)
        }
    }
}