//
//  RestNetworkClient.swift
//  AboutMe
//
//  Created by Peter Mäder on 04.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation

class RestNetworkClient {
    
    typealias CompletionHandler = (_ result: AnyObject?, _ error: NSError?) -> Void
    
    var session: URLSession
    
    init() {
        session = URLSession.shared
    }

    // MARK: - Task for GET Requests to GitHub
    func taskForGETMethod(api: String!, apiPathParameters: [String?], urlParameter: [String:AnyObject]?, completionHandlerForGET: @escaping CompletionHandler) -> URLSessionDataTask {
        
        // 1. build possible api path extension string
        var apiPathExtension = String()
        
        if let apiPathComponents = apiPathParameters as? [String]{
            apiPathExtension = buildPathFrom(components: apiPathComponents)
        }
        
        // 2. build possible url components based on input dictionairy
        let requestURL = buildURLFromParametersFor(api: api, apiPathExtension: apiPathExtension, apiComponents: urlParameter)
        
        /* Build the URL, Configure the request */
        var request = URLRequest(url: requestURL)
        
        /* Create and execute the request */
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your GET Request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                sendError("Your HTTP GET request returned a status code other than 2xx -> \(response)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by this HTTP GET request!")
                return
            }
            
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandlerForGET)
        })
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Utilities
    
    // -> build a path out of path components
    fileprivate func buildPathFrom(components: [String]) -> String {
        
        var componentString = String()
        
        for component in components{
            componentString.append("/\(component)")
        }
        
        return componentString
    }
    
    // -> create a URL from parameters, fix Flikr API Host & Path
    fileprivate func buildURLFromParametersFor(api: String, apiPathExtension: String, apiComponents: [String:AnyObject]? ) -> URL {
        
        guard api == "flickr" || api == "github" else {
            fatalError("fatal API failure")
        }
        
        var components = URLComponents()
        
        components.scheme = RestNetworkClient.APIConstants.ApiScheme
        components.host = RestNetworkClient.APIConstants.ApiHost[api]!
        components.path = RestNetworkClient.APIConstants.ApiPath[api]!.appending(apiPathExtension)
        
        if apiComponents != nil{
            
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in apiComponents as [String:AnyObject]! {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    // -> Parsing JSON Data
    fileprivate func convertDataWithCompletionHandler(data: Data, completionHandlerForConvertData: CompletionHandler) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> RestNetworkClient {
        
        struct Singleton {
            static var sharedInstance = RestNetworkClient()
        }
        
        return Singleton.sharedInstance
    }
}
