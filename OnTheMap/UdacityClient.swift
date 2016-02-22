//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 2/21/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGetMethod(method: String, parameters: [String: AnyObject], completionHandlerForGet: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask{
        
        // Build the URL and configure the request
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/\(method)")!)
        
        // Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            func sendError(error: String){
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGet(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            // Check for any error conditions from the request
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Request returned invalid status code.")
                return
            }
            
            guard let data = data else{
                sendError("No data returned.")
                return
            }
            
            var parsedResult: AnyObject!
            do{
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                sendError("Could not parse data as JSON: \(data)")
                return
            }
            completionHandlerForGet(result: parsedResult, error: nil)
        }
        task.resume()
        
        return task
    }
    
}