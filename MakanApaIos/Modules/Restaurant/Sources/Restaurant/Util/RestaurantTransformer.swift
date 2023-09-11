//
//  File.swift
//  
//
//  Created by Onoh on 11/09/23.
//

import Core
import RealmSwift

public struct RestaurantTransformer: Mapper
{
    
    public typealias Request = String
    public typealias Response = RestaurantResponse
    public typealias Entity = RestaurantEntity
    public typealias Domain = RestaurantModel
    
    public init() {}
    
    public func transformResponseToEntity(request: String?, response: RestaurantResponse) -> RestaurantEntity {
        let restaurantEntity = RestaurantEntity()
        restaurantEntity.id = response.id
        restaurantEntity.descriptions = response.description
        restaurantEntity.city = response.city
        restaurantEntity.pictureId = response.pictureID
        restaurantEntity.name = response.name
        restaurantEntity.rating = response.rating
        return restaurantEntity
    }
    
    public func transformEntityToDomain(entity: RestaurantEntity) -> RestaurantModel {
        return RestaurantModel(
            id: entity.id,
            name: entity.name,
            description: entity.descriptions,
            pictureID: entity.pictureId,
            city: entity.city,
            rating: entity.rating,
            favorite: entity.favorite
        )
    }
}
