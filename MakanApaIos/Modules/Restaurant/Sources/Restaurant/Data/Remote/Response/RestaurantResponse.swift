//
//  File.swift
//  
//
//  Created by Onoh on 07/09/23.
//

import Foundation

public struct RestaurantResponse: Codable {
    let id, name, description: String
    var pictureID: String
    let city: String
    let rating: Double

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case pictureID = "pictureId"
        case city, rating
    }
}
