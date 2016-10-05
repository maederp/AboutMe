//
//  GithubClient.swift
//  AboutMe
//
//  Created by Peter Mäder on 30.09.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//
import Foundation

let githubAPI : String = "github"

class GithubClient {

    typealias CompletionHandler = (_ result: AnyObject?, _ error: NSError?) -> Void
    
    var session: URLSession
    
    init() {
        session = URLSession.shared
    }
    
    // MARK: - GitHub convenience Methods to retrieve User Repo Data
    func getUserRepoData(_ userName: String, completionHandler: @escaping CompletionHandler) -> Void {
        
        _ = RestNetworkClient.sharedInstance().taskForGETMethod(api: githubAPI, apiPathParameters: [userName, "repos"], urlParameter: nil, completionHandlerForGET: { (result, error) in
            
            if error != nil {
                completionHandler(nil,error)
            }else{
                
                if let githubRepos = result as? [AnyObject]{
                    var githubRepositories = [String]()
                    
                    for githubRepo in githubRepos{
                        githubRepositories.append(githubRepo["name"] as! String)
                    }
                    
                    completionHandler(githubRepositories as AnyObject?, nil)
                }
            }
        })
    }
    

    
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> GithubClient {
        
        struct Singleton {
            static var sharedInstance = GithubClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
