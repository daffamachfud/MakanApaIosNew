//
//  File.swift
//  
//
//  Created by Onoh on 07/09/23.
//

import Foundation
import RealmSwift

public class RestaurantEntity: Object {
    @objc dynamic public var id: String = ""
    @objc dynamic public var name: String = ""
    @objc dynamic public var descriptions: String = ""
    @objc dynamic public var pictureId: String = ""
    @objc dynamic public var city: String = ""
    @objc dynamic public var rating: Double = 0.0
    @objc dynamic public var favorite = false

    public override static func primaryKey() -> String? {
        return "id"
    }
}
