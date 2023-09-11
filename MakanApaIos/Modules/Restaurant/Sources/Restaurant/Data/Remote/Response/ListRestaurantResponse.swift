//
//  File.swift
//  
//
//  Created by Onoh on 07/09/23.
//

import Foundation

// MARK: - ListRestaurant
public struct ListRestaurantResponse: Codable {
    let error: Bool
    let message: String
    let count: Int
    var restaurants: [RestaurantResponse]
}
