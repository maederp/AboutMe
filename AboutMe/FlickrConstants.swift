//
//  FlickrConstants.swift
//  AboutMe
//
//  Created by Peter Mäder on 05.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

extension FlickrClient{
    
    struct APIConstants {
        static let ApiKey = "api_key"
    }
    
    struct APIMethods {
        static let MethodKeyWord = "method"
        static let FlickrPhotoSearch = "flickr.photos.search"
        static let FlickrPhotosGetSizes = "flickr.photos.getSizes"
    }
    
    // MARK: Flickr Photo Search Constants
    struct ConstantsFlickrPhotoSearch {
        static let UserID = "user_id"
        static let Method = "method"
        static let Per_page = "per_page"
        static let Page = "page"
        static let Format = "format"
        static let NoJSONCallBack = "nojsoncallback"
    }
    
    struct ConstantsFlickrPhotoSearchResponse {
        static let Photos = "photos"
        static let Photo = "photo"
        static let id = "id"
        static let owner = "owner"
        static let source = "source"
        static let title = "title"
        static let Page = "page"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    // MARK: Flickr GetSizes Constants
    struct ConstantsFlickrGetSizes {
        static let PhotoID = "photo_id"
    }
    
    struct ConstantsFlickrGetSizesResponse {
        static let Sizes = "sizes"
        static let Size = "size"
        static let Label = "label"
        static let Source = "source"
        static let Url = "url"
        static let Media = "media"
    }

}
