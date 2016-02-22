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
    
    func taskForGetMethod(method: String, parameters: [String: AnyObject], completionHandlerForGet: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
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
            
            // Parse the result and send it to the completion handler
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
        }
        // Start the request
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPostMethod(method: String, parameters: [String: AnyObject], jsonBody: [String: AnyObject], completionHandlerForPost: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/\(method)")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert jsonBody dictionary to a string
        var bodyString = "{\n"
        for(key, value) in jsonBody{
            bodyString += "\"\(key)\" : \"\(value)\",\n"
        }
        bodyString += "\n}"
        
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            func sendError(error: String){
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPost(result: nil, error: NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
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
            
            // Parse the result and send it to the completion handler
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPost)
        }
        // Start the request
        task.resume()
        
        return task
    }
    
    // MARK: DELETE
    
    func taskForDeleteMethod(method: String, completionHandlerForDelete: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        // Build the URL and configure the request
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/\(method)")!)
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies! {
            if (cookie.name == "XSRF-TOKEN") { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            func sendError(error: String){
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForDelete(result: nil, error: NSError(domain: "taskForDeleteMethod", code: 1, userInfo: userInfo))
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
            
            // Parse the result and send it to the completion handler
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDelete)
        }
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do{
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse data as JSON: \(data)"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
}