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
    
    //TODO: Create method to retrieve student locations with GET
    func getStudentLocations(limit: Int, skip: Int, order: String, completionHandlerForGetLocations: (success: Bool, error: NSError?) -> Void) {
        
        let parameters : [String: AnyObject] = [
            ParameterKeys.resultLimit : limit,
            ParameterKeys.numResultsToSkip : skip,
            ParameterKeys.orderBy : order
        ]
        
        taskForGetMethod(Methods.studentLocations, parameters: parameters) { (results, error) in
            
            if(error != nil){
                
            }
        }
    }
    
    //TODO: Create method to send student location with POST
}