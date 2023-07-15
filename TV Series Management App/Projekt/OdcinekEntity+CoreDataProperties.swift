//
//  OdcinekEntity+CoreDataProperties.swift
//  Projekt
//
//  Created by Pawel Jaskula on 12/06/2023.
//
//

import Foundation
import CoreData


extension OdcinekEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OdcinekEntity> {
        return NSFetchRequest<OdcinekEntity>(entityName: "OdcinekEntity")
    }

    @NSManaged public var czyDodanoOdcinek: Bool
    @NSManaged public var tytul: String?
    @NSManaged public var toSerialEntity: SerialEntity?

}

extension OdcinekEntity : Identifiable {

}
