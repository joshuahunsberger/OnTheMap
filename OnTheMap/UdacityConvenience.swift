//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 2/22/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import Foundation

// MARK: UdacityClient (Convenience Methods)
extension UdacityClient {
    
    func postLogin(username: String, password: String, completionHandlerForSession: (success: Bool, error: NSError?) -> Void) {
        
        let jsonBody =  "{\"udacity\" : {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"

        taskForPostMethod(UdacityClient.Methods.session, parameters: nil, jsonBody: jsonBody) { (results, error) in
            
            if let error = error {
                completionHandlerForSession(success: false, error: error)
            } else {
                // Get userID and sessionID
                guard let account = results[UdacityClient.JSONResponseKeys.account] as? [String: AnyObject] else {
                    completionHandlerForSession(success: false, error: NSError(domain: "postSession parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse postLogin account dictionary"]))
                    return
                }
                
                guard let userID = account[UdacityClient.JSONResponseKeys.accountKey] as? String else {
                    completionHandlerForSession(success: false, error: NSError(domain: "postSession parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse userID"]))
                    return
                }
                
                guard let session = results[UdacityClient.JSONResponseKeys.session] as? [String: AnyObject] else {
                    completionHandlerForSession(success: false, error: NSError(domain: "postSession parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse postLogin session dictionary"]))
                    return
                }
                
                guard let sessionID = session[UdacityClient.JSONResponseKeys.sessionID] as? String else {
                    completionHandlerForSession(success: false, error: NSError(domain: "postSession parsing sessionID", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse sessionID"]))
                    return
                }
                
                self.userID = userID
                self.sessionID = sessionID
                completionHandlerForSession(success: true, error: nil)
            }
        }
    }
    
    func deleteSession(completionHandlerForDeleteSession: (success: Bool, error: NSError?) -> Void) {
        let method = UdacityClient.Methods.session
        
        taskForDeleteMethod(method) { (results, error) in
            self.userID = nil
            self.sessionID = nil
            self.userFirstName = nil
            self.userLastName = nil
            if let error = error {
                completionHandlerForDeleteSession(success: false, error: error)
            } else {
                print(results)
                completionHandlerForDeleteSession(success: true, error: nil)
            }
        }
    }
    
    func getName(completionHandlerForGetUserData: (success: Bool, error: NSError?) -> Void) {
        guard let  userID = userID else {
            completionHandlerForGetUserData(success: false, error: NSError(domain: "getName", code: 1, userInfo: [NSLocalizedDescriptionKey: "User ID is not set."]))
            return
        }
        let method = UdacityClient.Methods.users.stringByReplacingOccurrencesOfString("{key}", withString: userID)
        taskForGetMethod(method, parameters: nil) { (results, error) in
            if let error = error {
                completionHandlerForGetUserData(success: false, error: error)
            } else {
                guard let user = results[UdacityClient.JSONResponseKeys.user] as? [String: AnyObject] else {
                    completionHandlerForGetUserData(success: false, error: NSError(domain: "getName parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse user dictionary"]))
                    return
                }
                
                guard let firstName = user[UdacityClient.JSONResponseKeys.userFirstName] as? String else {
                    completionHandlerForGetUserData(success: false, error: NSError(domain: "getName parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse first name."]))
                    return
                }
                
                guard let lastName = user[UdacityClient.JSONResponseKeys.userLastName] as? String else {
                    completionHandlerForGetUserData(success: false, error: NSError(domain: "getName parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse last naem."]))
                    return
                }
                
                self.userFirstName = firstName
                self.userLastName = lastName

                completionHandlerForGetUserData(success: true, error: nil)
            }
        }
    }
}