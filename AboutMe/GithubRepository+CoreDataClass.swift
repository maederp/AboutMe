//
//  GithubRepository+CoreDataClass.swift
//  AboutMe
//
//  Created by Peter Mäder on 05.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import CoreData


public class GithubRepository: NSManagedObject {

    struct Keys {
        static let Name = "name"
        static let HtmlUrl = "htmlURL"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let ID = "id"
        static let PushedAt = "pushedAt"
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String : AnyObject?], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "GithubRepository", in: context)!
        
        super.init(entity: entity, insertInto: context)
        
        /*
         "created_at": "2016-01-22T13:34:35Z",
         "updated_at": "2016-09-27T21:20:06Z"
         */
        let formatter_rfc3339 = DateFormatter()
        let local = Locale(identifier: "en_US_POSIX")
        formatter_rfc3339.locale = local
        
        formatter_rfc3339.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        
        name = dictionary[Keys.Name] as? String
        htmlURL = dictionary[Keys.HtmlUrl] as? String
        createdAt = formatter_rfc3339.date(from: (dictionary[Keys.CreatedAt] as? String)!) as NSDate?
        updatedAt = formatter_rfc3339.date(from: (dictionary[Keys.UpdatedAt] as? String)!) as NSDate?
        id = Int64((dictionary[Keys.ID] as? Int)!)
        pushedAt = formatter_rfc3339.date(from: (dictionary[Keys.PushedAt] as? String)!) as NSDate?
    }
    
}
