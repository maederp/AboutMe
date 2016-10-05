//
//  FlickrClient.swift
//  AboutMe
//
//  Created by Peter Mäder on 05.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation

let flickrAPI : String = "flickr"

class FlickrClient {

    typealias CompletionHandler = (_ result: AnyObject?, _ error: NSError?) -> Void
    
    var session: URLSession
    
    init() {
        session = URLSession.shared
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> FlickrClient {
        
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        
        return Singleton.sharedInstance
    }

    // MARK: Get fotos by geo location
    func getPhotosBy(userID: String, completionHandler: @escaping CompletionHandler) {
        
        //initialize Flickr Page to 1
        let flickrSearchPage = 1
        
        // fill search parameters
        let parameters : [String:AnyObject] = [
            FlickrClient.ConstantsFlickrPhotoSearch.Method : FlickrClient.Methods.FlickrPhotoSearch as AnyObject,
            FlickrClient.ConstantsFlickrPhotoSearch.ApiKey : Bundle.main.object(forInfoDictionaryKey: "FlickrAPIKey") as AnyObject,
            FlickrClient.ConstantsFlickrPhotoSearch.UserID : userID as AnyObject,
            FlickrClient.ConstantsFlickrPhotoSearch.Format : "json" as AnyObject,
            FlickrClient.ConstantsFlickrPhotoSearch.NoJSONCallBack : 1 as AnyObject,
            FlickrClient.ConstantsFlickrPhotoSearch.Per_page : 48 as AnyObject,
            FlickrClient.ConstantsFlickrPhotoSearch.Page : flickrSearchPage as AnyObject
        ]
        
        _ = RestNetworkClient.sharedInstance().taskForGETMethod(api: flickrAPI, apiPathParameters: ["rest/"], urlParameter: parameters, completionHandlerForGET: { (result, error) in
            
            if let error = error {
                completionHandler(nil, error)
            } else {
                print(result)
            }
        })
    }
}
