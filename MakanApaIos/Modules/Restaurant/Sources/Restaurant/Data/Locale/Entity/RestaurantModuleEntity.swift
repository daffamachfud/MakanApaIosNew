//
//  File.swift
//  
//
//  Created by Onoh on 07/09/23.
//

import Foundation
import RealmSwift

public class RestaurantEntity: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var descriptions: String = ""
    @objc dynamic var pictureId: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var rating: Double = 0.0
    @objc dynamic var favorite = false

    public override static func primaryKey() -> String? {
        return "id"
    }
}
