//
//  Photo+CoreDataClass.swift
//  AboutMe
//
//  Created by Peter Mäder on 06.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import CoreData


public class Photo: NSManagedObject {

    struct Keys {
        static let Image = "image"
        static let ID = "id"
        static let Owner = "owner"
        static let Source = "source"
        static let Title = "title"
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String : AnyObject?], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context)!
        
        super.init(entity: entity, insertInto: context)
        
        id = Int64((dictionary[Keys.ID] as? String)!)!
        owner = dictionary[Keys.Owner] as? String
        image = dictionary[Keys.Image] as? NSData
        sourceURL = dictionary[Keys.Source] as? String
        title = dictionary[Keys.Title] as? String
    }
}
