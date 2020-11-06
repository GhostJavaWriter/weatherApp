//
//  Sights+CoreDataProperties.swift
//  weatherApp
//
//  Created by Баир Надцалов on 06.11.2020.
//
//

import Foundation
import CoreData


extension Sights {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Sights> {
        return NSFetchRequest<Sights>(entityName: "Sights")
    }

    @NSManaged public var fullDescr: String
    @NSManaged public var image: String
    @NSManaged public var location: String
    @NSManaged public var name: String
    @NSManaged public var relationTo: String
    @NSManaged public var shortDescr: String

}

extension Sights : Identifiable {

}
