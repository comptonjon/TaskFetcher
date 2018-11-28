//
//  LocalUser+CoreDataProperties.swift
//  TaskFetcher
//
//  Created by Jonathan Compton on 11/27/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//
//

import Foundation
import CoreData


extension LocalUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalUser> {
        return NSFetchRequest<LocalUser>(entityName: "LocalUser")
    }

    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var firebaseID: String?

}
