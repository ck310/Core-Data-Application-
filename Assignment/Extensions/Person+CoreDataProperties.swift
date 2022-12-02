//
//  Person+CoreDataProperties.swift
//  Assignment02
//
//  Created by C Karthika on 01/04/2022.
//

import Foundation
import CoreData


extension People {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var name   : String?
    @NSManaged public var gender : String?
    @NSManaged public var age    : String?
    @NSManaged public var phone  : String?
    @NSManaged public var details: String?
    @NSManaged public var image  : String?

}

extension People : Identifiable {

}

