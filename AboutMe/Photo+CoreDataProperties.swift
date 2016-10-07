//
//  Photo+CoreDataProperties.swift
//  AboutMe
//
//  Created by Peter Mäder on 06.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var id: Int64
    @NSManaged public var owner: String?
    @NSManaged public var sourceURL: String?
    @NSManaged public var title: String?
    @NSManaged public var image: NSData?

}
