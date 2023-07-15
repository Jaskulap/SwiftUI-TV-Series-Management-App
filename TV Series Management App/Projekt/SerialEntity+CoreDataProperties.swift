//
//  SerialEntity+CoreDataProperties.swift
//  Projekt
//
//  Created by Pawel Jaskula on 12/06/2023.
//
//

import Foundation
import CoreData


extension SerialEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SerialEntity> {
        return NSFetchRequest<SerialEntity>(entityName: "SerialEntity")
    }

    @NSManaged public var dodano: Bool
    @NSManaged public var iloscOdcinkow: Int16
    @NSManaged public var napis: String?
    @NSManaged public var obrazek: String?
    @NSManaged public var obrazek2: String?
    @NSManaged public var obrazekP: String?
    @NSManaged public var ocena: Double
    @NSManaged public var sredniCzasOdcinka: Int16
    @NSManaged public var streszczenie: String?
    @NSManaged public var tag: String?
    @NSManaged public var toOdcinekEntity: NSSet?
    public var odcinekArray: [OdcinekEntity] {
        let set = toOdcinekEntity as? Set<OdcinekEntity> ?? []
        
        return set.sorted { odcinek1, odcinek2 in
            if let tytul1 = odcinek1.tytul, let tytul2 = odcinek2.tytul {
                // Wyciągnij numery odcinków
                let components1 = tytul1.components(separatedBy: " ")
                let components2 = tytul2.components(separatedBy: " ")
                
                if let numer1 = components1.last, let numer2 = components2.last {
                    if let numerInt1 = Int(numer1), let numerInt2 = Int(numer2) {
                        // Porównaj numery odcinków
                        return numerInt1 < numerInt2
                    }
                }
            }
            
            // Jeśli wystąpił błąd, użyj standardowego porównania tytułów
            return odcinek1.tytul ?? "" < odcinek2.tytul ?? ""
        }
    }

}

// MARK: Generated accessors for toOdcinekEntity
extension SerialEntity {

    @objc(addToOdcinekEntityObject:)
    @NSManaged public func addToToOdcinekEntity(_ value: OdcinekEntity)

    @objc(removeToOdcinekEntityObject:)
    @NSManaged public func removeFromToOdcinekEntity(_ value: OdcinekEntity)

    @objc(addToOdcinekEntity:)
    @NSManaged public func addToToOdcinekEntity(_ values: NSSet)

    @objc(removeToOdcinekEntity:)
    @NSManaged public func removeFromToOdcinekEntity(_ values: NSSet)

}

extension SerialEntity : Identifiable {

}
