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
    
    // MARK: Initializer
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    // MARK: PUT
    
    // MARK: Helpers
    
    func parseURLFromParameters(method: String, parameters: [String: AnyObject]?) -> NSURL {
        let components = NSURLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath
        
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
}