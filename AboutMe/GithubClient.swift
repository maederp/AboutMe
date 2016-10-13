//
//  GithubClient.swift
//  AboutMe
//
//  Created by Peter Mäder on 30.09.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//
import Foundation
import CoreData



class GithubClient {

    typealias CompletionHandler = (_ result: AnyObject?, _ error: NSError?) -> Void
    
    let githubAPI : String = "github"
    
    var session: URLSession
    
    init() {
        session = URLSession.shared
    }
    
    // MARK: - Shared Instance
    class func sharedInstance() -> GithubClient {
        
        struct Singleton {
            static var sharedInstance = GithubClient()
        }
        
        return Singleton.sharedInstance
    }
    
    // NSManagedObjectContext shared context
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // MARK: - GitHub convenience Methods to retrieve User Repo Data
    func getUserRepoData(_ userName: String, completionHandler: @escaping CompletionHandler) -> Void {
        
        _ = RestNetworkClient.sharedInstance().taskForGETMethod(api: githubAPI, apiPathParameters: [userName, "repos"], urlParameter: nil, completionHandlerForGET: { (result, error) in
            
            if error != nil {
                completionHandler(nil,error)
            }else{
                
                if let githubRepos = result as? [[String:AnyObject]]{
                    
                    for githubRepo in githubRepos{
                        
                        let addGithubDict : [String:AnyObject?] = [
                            GithubRepository.Keys.ID : githubRepo[GithubClient.GithubResponseKeys.ID],
                            GithubRepository.Keys.HtmlUrl : githubRepo[GithubClient.GithubResponseKeys.HtmlURL],
                            GithubRepository.Keys.Name : githubRepo[GithubClient.GithubResponseKeys.RepositoryName],
                            GithubRepository.Keys.CreatedAt : githubRepo[GithubClient.GithubResponseKeys.CreatedAt],
                            GithubRepository.Keys.UpdatedAt : githubRepo[GithubClient.GithubResponseKeys.UpdatedAt],
                            GithubRepository.Keys.PushedAt : githubRepo[GithubClient.GithubResponseKeys.PushedAt]
                        ]
                        
                        let _ = GithubRepository(dictionary: addGithubDict, context: self.sharedContext)

                    }
                    CoreDataStackManager.sharedInstance().saveContext()
                }
                completionHandler(result, nil)
            }
        })
    }
    
}
