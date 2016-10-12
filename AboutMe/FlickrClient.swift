//
//  FlickrClient.swift
//  AboutMe
//
//  Created by Peter Mäder on 05.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import CoreData

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
    
    // NSManagedObjectContext shared context
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    /* MARK: Get fotos by userID
     1. Fill query parameters
     2. Request Photo List for User (flickr.photos.search)
     3. Create Photo Object and store in CoreData
     */
    func getPhotosBy(userID: String, completionHandler: @escaping CompletionHandler) {
        
        //initialize Flickr Page to 1
        let flickrSearchPage = 1
        
        // fill search parameters
        let parameters : [String:AnyObject] = [
            FlickrClient.APIMethods.MethodKeyWord : FlickrClient.APIMethods.FlickrPhotoSearch as AnyObject,
            FlickrClient.APIConstants.ApiKey : Bundle.main.object(forInfoDictionaryKey: "FlickrAPIKey") as AnyObject,
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
                
                if let photos = result?[FlickrClient.ConstantsFlickrPhotoSearchResponse.Photos] as? [String:AnyObject] {
                    
                    if let photoArray = photos[FlickrClient.ConstantsFlickrPhotoSearchResponse.Photo] as? [[String:AnyObject]]{
                        
                        performUIUpdatesOnMain {
                            for photo in photoArray{
                                
                                let addFotoDict : [String:AnyObject?] = [
                                    Photo.Keys.ID : photo[FlickrClient.ConstantsFlickrPhotoSearchResponse.id],
                                    Photo.Keys.Owner : photo[FlickrClient.ConstantsFlickrPhotoSearchResponse.owner],
                                    Photo.Keys.Source : photo[FlickrClient.ConstantsFlickrPhotoSearchResponse.source],
                                    Photo.Keys.Title : photo[FlickrClient.ConstantsFlickrPhotoSearchResponse.title],
                                    Photo.Keys.Image : nil
                                ]
                                
                                let _ = Photo(dictionary: addFotoDict, context: self.sharedContext)
                            }
                            
                            CoreDataStackManager.sharedInstance().saveContext()
                           
                        }
                    }
                }
                
                completionHandler(result, nil)
            }
        })
    }
    
    /* MARK: Get single photo by photoID
     1. Fill query parameters
     2. Request Photo details for given PhotoID (flickr.photos.getSizes)
     3. Download Images (high & low resolution)
     */
    func getFotoForId(_ photoID: Int64, completionHandler: @escaping CompletionHandler) {
        let parameters : [String:AnyObject] = [
            FlickrClient.APIMethods.MethodKeyWord : FlickrClient.APIMethods.FlickrPhotosGetSizes as AnyObject,
            FlickrClient.APIConstants.ApiKey : Bundle.main.object(forInfoDictionaryKey: "FlickrAPIKey") as AnyObject,
            FlickrClient.ConstantsFlickrGetSizes.PhotoID : photoID as AnyObject,
            FlickrClient.ConstantsFlickrPhotoSearch.Format : "json" as AnyObject,
            FlickrClient.ConstantsFlickrPhotoSearch.NoJSONCallBack : 1 as AnyObject
        ]
        
        _ = RestNetworkClient.sharedInstance().taskForGETMethod(api: flickrAPI, apiPathParameters: ["rest/"], urlParameter: parameters, completionHandlerForGET: { (result, error) in
            
            if let error = error {
                completionHandler( nil, error)
            } else {
                
                if let photoSizes = result?[FlickrClient.ConstantsFlickrGetSizesResponse.Sizes] as? [String:AnyObject] {
                    
                    if let sizeArray = photoSizes[FlickrClient.ConstantsFlickrGetSizesResponse.Size] as? [[String:AnyObject]]{
                        
                        for size in sizeArray{
                            
                            // Extract the Download URL for high resolution images
                            if (size[FlickrClient.ConstantsFlickrGetSizesResponse.Label] as! String) == "Medium"{

                                let highResURL = (size[FlickrClient.ConstantsFlickrGetSizesResponse.Source] as! String)
                                
                                self.downloadImageFor(urlString: highResURL, completionHandler: {(image, error) in
                                    
                                    if error != nil{
                                        completionHandler(nil,error)
                                    }else{
                                        completionHandler(image,nil)
                                    }
                                })
                            
                            }
                        }
                    }
                } else {
                    completionHandler( nil, NSError(domain: "getFotoForId parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFotoForId Json"]))
                }
            }
        })
    }
    
    private func downloadImageFor(urlString: String, completionHandler: @escaping CompletionHandler) {
        
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        let downloadTask = self.session.dataTask(with: request, completionHandler: {(image, response, downloadError) in
            
            if let error = downloadError {
                completionHandler(nil, error as NSError?)
            } else {
                completionHandler(image as AnyObject?, nil)
            }
        })
        
        downloadTask.resume()
    }
}
