//
//  GithubRepositoryOwner+CoreDataProperties.swift
//  AboutMe
//
//  Created by Peter Mäder on 05.10.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import Foundation
import CoreData


extension GithubRepositoryOwner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GithubRepositoryOwner> {
        return NSFetchRequest<GithubRepositoryOwner>(entityName: "GithubRepositoryOwner");
    }

    @NSManaged public var id: Int64
    @NSManaged public var login: String?
    @NSManaged public var avatarURL: String?
    @NSManaged public var avatar: NSData?
    @NSManaged public var repository: NSSet?

}

// MARK: Generated accessors for repository
extension GithubRepositoryOwner {

    @objc(addRepositoryObject:)
    @NSManaged public func addToRepository(_ value: GithubRepository)

    @objc(removeRepositoryObject:)
    @NSManaged public func removeFromRepository(_ value: GithubRepository)

    @objc(addRepository:)
    @NSManaged public func addToRepository(_ values: NSSet)

    @objc(removeRepository:)
    @NSManaged public func removeFromRepository(_ values: NSSet)

}
