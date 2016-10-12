//
//  GithubConstants.swift
//  AboutMe
//
//  Created by Peter Mäder on 11.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation

extension GithubClient{
    
    // MARK: Github Repo response Constants
    struct GithubResponseKeys {
        static let ID = "id"
        static let RepositoryName = "name"
        static let HtmlURL = "html_url"
        static let CreatedAt = "created_at"
        static let UpdatedAt = "updated_at"
        static let PushedAt = "pushed_at"
    }
}
