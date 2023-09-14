//
//  File.swift
//  
//
//  Created by Onoh on 07/09/23.
//

import Foundation
import Core

public struct RestaurantsTransformer<
    RestaurantMapper: Mapper
>: Mapper where
RestaurantMapper.Request == String,
RestaurantMapper.Response == RestaurantResponse,
RestaurantMapper.Entity == RestaurantEntity,
RestaurantMapper.Domain == RestaurantModel {

    public typealias Request = String
    public typealias Response = [RestaurantResponse]
    public typealias Entity = [RestaurantEntity]
    public typealias Domain = [RestaurantModel]

    private let restaurantMapper: RestaurantMapper

    public init(restaurantMapper: RestaurantMapper) {
        self.restaurantMapper = restaurantMapper
    }

    public func transformResponseToEntity(request: String?, response: [RestaurantResponse]) -> [RestaurantEntity] {
        return response.map { result in
            self.restaurantMapper.transformResponseToEntity(request: request, response: result)
        }
    }

    public func transformEntityToDomain(entity: [RestaurantEntity]) -> [RestaurantModel] {
        return entity.map { result in
          return self.restaurantMapper.transformEntityToDomain(entity: result)
        }
    }
}
