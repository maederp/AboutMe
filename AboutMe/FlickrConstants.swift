//
//  FlickrConstants.swift
//  AboutMe
//
//  Created by Peter Mäder on 05.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

extension FlickrClient{
    
    struct APIConstants {
        static let ApiKey = ""
        static let ApiSecret = ""
    }
    
    struct Methods {
        static let FlickrPhotoSearch = "flickr.photos.search"
        static let FlickrPhotosGetSizes = "flickr.photos.getSizes"
    }
    
    // MARK: Flickr Photo Search Constants
    struct ConstantsFlickrPhotoSearch {
        static let ApiKey = "api_key"
        static let UserID = "user_id"
        static let Method = "method"
        static let Per_page = "per_page"
        static let Page = "page"
        static let Format = "format"
        static let NoJSONCallBack = "nojsoncallback"
    }
}
