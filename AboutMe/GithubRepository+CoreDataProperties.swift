//
//  GithubRepository+CoreDataProperties.swift
//  AboutMe
//
//  Created by Peter Mäder on 12.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import CoreData


extension GithubRepository {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GithubRepository> {
        return NSFetchRequest<GithubRepository>(entityName: "GithubRepository");
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var htmlURL: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var pushedAt: NSDate?

}
