//
//  FireStorageController.swift
//  AboutMe
//
//  Created by Peter Mäder on 27.09.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import Firebase

class FireStorageClient {
    
    lazy var storageRef : FIRStorageReference = {
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://aboutme-4052e.appspot.com")
        return storageRef
    }()
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> FireStorageClient {
        struct Singleton {
            static var sharedInstance = FireStorageClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func getImage(title: String, completionHandler: @escaping (_ image: UIImage?, _ error: NSError?) -> Void)  {
        
        // Create a reference to the file you want to download
        let islandRef = storageRef.child(title)
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.data(withMaxSize: (1 * 1024 * 1024)) { (data, error) -> Void in
            if (error != nil) {
                
                print( "FireStorage download failed")
                print( error?.localizedDescription)
                
                completionHandler( nil, error as NSError?)
                
            } else {
                if let image = UIImage(data: data!){
                    print ("FirStorag download succeeded: \(image.description)")
                    completionHandler( image, nil)
                }
            }
        }
    }

}
