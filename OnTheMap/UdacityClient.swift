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
    
    // Udacity sessionID
    var sessionID: String!
    // Udacity userID
    var userID: String!
    // Udacity user full name
    var userFullName: String!
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGetMethod(method: String, parameters: [String: AnyObject]?, completionHandlerForGet: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(method, parameters: parameters))
        
        // Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            // Process the data
            self.processDataWithCompletionHandler(data, response: response, error: error, domain: "taskForGetMethod", completionHandlerForProcessData: completionHandlerForGet)
        }
        // Start the request
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPostMethod(method: String, parameters: [String: AnyObject]?, jsonBody: String, completionHandlerForPost: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(method, parameters: parameters))
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)

        // Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            // Process the data
            self.processDataWithCompletionHandler(data, response: response, error: error, domain: "taskForPostMethod", completionHandlerForProcessData: completionHandlerForPost)
        }
        // Start the request
        task.resume()
        
        return task
    }
    
    // MARK: DELETE
    
    func taskForDeleteMethod(method: String, completionHandlerForDelete: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        // Build the URL and configure the request
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(method, parameters: nil))
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies! {
            if (cookie.name == "XSRF-TOKEN") { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        // Make the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            // Process the data
            self.processDataWithCompletionHandler(data, response: response, error: error, domain: "taskForDeleteMethod", completionHandlerForProcessData: completionHandlerForDelete)
        }
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        // Skip the first 5 characters of Udacity API responses, which are used for security purposes
        let dataSubset = data.subdataWithRange(NSMakeRange(5, data.length - 5))
        
        var parsedResult: AnyObject!
        do{
            parsedResult = try NSJSONSerialization.JSONObjectWithData(dataSubset, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse data as JSON: \(dataSubset)"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    func processDataWithCompletionHandler(data: NSData?, response: NSURLResponse?, error: NSError?, domain: String, completionHandlerForProcessData: (result: AnyObject!, error: NSError?) -> Void) {
        func sendError(error: String){
            let userInfo = [NSLocalizedDescriptionKey: error]
            completionHandlerForProcessData(result: nil, error: NSError(domain: domain, code: 1, userInfo: userInfo))
        }
        
        // Check for any error conditions from the request
        
        guard (error == nil) else {
            sendError(error!.localizedDescription)
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
        
        convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForProcessData)
    }
    
    func udacityURLFromParameters(method: String, parameters: [String: AnyObject]?) -> NSURL{
        
        let components = NSURLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + method

        // Append parameters, if there are any
        if let parameters = parameters {
            components.queryItems = [NSURLQueryItem]()
            for(key,value) in parameters {
                let queryItem = NSURLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.URL!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}