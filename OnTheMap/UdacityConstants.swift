//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 2/21/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

// MARK: UdacityClient (Constants)

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URL Components
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    // MARK: Methods
    struct Methods {
        static let session = "/session"
        static let users = "/users/{key}"
    }
    
    struct JSONBodyKeys {
        static let dictionaryName = "udacity"
        static let userName = "username"
        static let password = "password"
    }
    
    struct JSONResponseKeys {
        // MARK: Dictionary Names
        static let account = "account"
        static let session = "session"
        static let user = "user"
        
        // MARK: Key names
        static let accountKey = "key"
        static let sessionID = "id"
        static let userFirstName = "first_name"
        static let userLastName = "last_name"
    }
}
