//
//  GithubConstants.swift
//  AboutMe
//
//  Created by Peter Mäder on 30.09.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

extension RestNetworkClient{
    
    struct APIConstants {
        static let ApiScheme = "https"
        static let ApiHost : [String:String] = ["github":"api.github.com", "flickr":"api.flickr.com"]
        static let ApiPath : [String:String] = ["github":"/users", "flickr":"/services"]

    }
}
