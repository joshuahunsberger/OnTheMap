//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Joshua Hunsberger on 3/1/16.
//  Copyright © 2016 Joshua Hunsberger. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // MARK: Properties
    var session = NSURLSession.sharedSession()
    
    // Array of student locations retrieved from server
    var studentLocations : [StudentLocation]?
    
    // MARK: Initializer
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGetMethod(method: String, parameters: [String: AnyObject]?, completionHandlerForgGet: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // Build the URL and configure the request
        let request = NSMutableURLRequest(URL: parseURLFromParameters(method, parameters: parameters))
        request.addValue(ParseClient.Constants.applicationID, forHTTPHeaderField: ParseClient.HTTPHeaders.appIDHeader)
        request.addValue(ParseClient.Constants.RestApiKey, forHTTPHeaderField: ParseClient.HTTPHeaders.restAPIHeader)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            self.processDataWithCompletionHandler(data, response: response, error: error, domain: "taskForGetMethod", completionHandlerForProcessData: completionHandlerForgGet)
        }
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPostMethod(method: String, parameters: [String: AnyObject]?, jsonBody: String, completionHandlerForPost: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: parseURLFromParameters(method, parameters: parameters))
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.applicationID, forHTTPHeaderField: ParseClient.HTTPHeaders.appIDHeader)
        request.addValue(ParseClient.Constants.RestApiKey, forHTTPHeaderField: ParseClient.HTTPHeaders.restAPIHeader)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) in
            self.processDataWithCompletionHandler(data, response: response, error: error, domain: "taskForPostMethod", completionHandlerForProcessData: completionHandlerForPost)
        }
        task.resume()
        
        return task
    }
    
    // MARK: PUT
    
    func taskForPutMethod(method: String, parameters: [String: AnyObject]?, jsonBody: String, completionHandlerForPut: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = NSMutableURLRequest(URL: parseURLFromParameters(method, parameters: parameters))
        request.HTTPMethod = "PUT"
        request.addValue(ParseClient.Constants.applicationID, forHTTPHeaderField: ParseClient.HTTPHeaders.appIDHeader)
        request.addValue(ParseClient.Constants.RestApiKey, forHTTPHeaderField: ParseClient.HTTPHeaders.restAPIHeader)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            self.processDataWithCompletionHandler(data, response: response, error: error, domain: "taskForPutMethod", completionHandlerForProcessData: completionHandlerForPut)
        }
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    func parseURLFromParameters(method: String, parameters: [String: AnyObject]?) -> NSURL {
        let components = NSURLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = "\(ParseClient.Constants.ApiPath)/\(method)"
        
        // Append parameters, if any
        if let parameters = parameters {
            components.queryItems = [NSURLQueryItem]()
            for(key, value) in parameters{
                let queryItem = NSURLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.URL!
    }
    
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
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}