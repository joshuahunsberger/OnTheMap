//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 3/1/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import Foundation

// MARK: UdacityClient (Constants)

extension ParseClient {
    
    // MARK: Constants
    
    struct Constants {
        
        static let applicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URL Components
        
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1/classes"
    }
    
    // MARK: Methods
    
    struct Methods {
        static let studentLocations = "StudentLocation"
    }
    
    // MARK: HTTP Headers
    
    struct HTTPHeaders {
        static let appIDHeader = "X-Parse-Application-Id"
        static let restAPIHeader = "X-Parse-REST-API-Key"
    }
    
    // MARK: Parameters
    
    /*
    Optional Parameters:
    limit - (Number) specifies the maximum number of StudentLocation objects to return in the JSON response
    ex: https://api.parse.com/1/classes/StudentLocation?limit=100
    
    skip - (Number) use this parameter with limit to paginate through results
    ex: https://api.parse.com/1/classes/StudentLocation?limit=200&skip=400
    
    order - (String) a comma-separate list of key names that specify the sorted order of the results
    Prefixing a key name with a negative sign reverses the order (default order is descending)
    ex: https://api.parse.com/1/classes/StudentLocation?order=-updatedAt
    */
    struct ParameterKeys {
        static let resultLimit = "limit"
        static let numResultsToSkip = "skip"
        static let orderBy = "order"
    }

    // MARK: JSON Keys
    
    struct JSONResponseKeys {
        // MARK: Dictionary Names
        
        static let results = "results"
        
        // MARK: Key names
        
        static let firstName = "firstName"
        static let lastname = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let urlString = "mediaURL"
    }
    
}
