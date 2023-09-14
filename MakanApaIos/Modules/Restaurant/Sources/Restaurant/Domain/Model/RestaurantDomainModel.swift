//
//  File.swift
//  
//
//  Created by Onoh on 07/09/23.
//

public struct RestaurantModel: Equatable, Identifiable {
    public let id: String
    public let name: String
    public let description: String
    public let pictureID: String
    public let city: String
    public let rating: Double
    public var favorite: Bool = false

    public init(id: String, name: String, description: String, pictureID: String,
                city: String, rating: Double, favorite: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.pictureID = pictureID
        self.city = city
        self.rating = rating
        self.favorite = favorite
    }
}
