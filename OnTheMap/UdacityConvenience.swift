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
                guard let session = results[UdacityClient.JSONResponseKeys.session] as? [String: AnyObject] else {
                    completionHandlerForSession(success: false, error: NSError(domain: "postSession parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse postLogin dictionary"]))
                    return
                }
                
                guard let sessionID = session[UdacityClient.JSONResponseKeys.sessionID] as? String else {
                    completionHandlerForSession(success: false, error: NSError(domain: "postSession parsing sessionID", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse sessionID"]))
                    return
                }
                self.sessionID = sessionID
                completionHandlerForSession(success: true, error: nil)
            }
        }
    }
    
    // TODO: Implement method to DELETE the current session
    func deleteSession(completionHandlerForDelete: (success: Bool, error: NSError?) -> Void){
        let method = UdacityClient.Methods.session
        
        taskForDeleteMethod(method) { (results, error) in
            if let error = error {
                completionHandlerForDelete(success: false, error: error)
            } else {
                print(results)
                completionHandlerForDelete(success: true, error: nil)
            }
        }
    }
    
    // TODO: Implement method to GET public user data
}