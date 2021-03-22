//
//  Users+CoreDataProperties.swift
//  Practise2021
//
//  Created by Nand Parikh on 22/03/21.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var userId: String?
    @NSManaged public var avatar: Data?
    @NSManaged public var phoneNumber: Int64
    @NSManaged public var gender: Bool

}

extension Users : Identifiable {

}
