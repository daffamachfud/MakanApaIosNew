//
//  Injection.swift
//  MakanApaIos
//
//  Created by Onoh on 01/09/23.
//

import Core
import UIKit
import Restaurant
import SwiftUI
import RealmSwift

final class Injection: NSObject {
    private let realm = try? Realm()

    func provideRestaurants<U: UseCase>() -> U where U.Request == String, U.Response == [RestaurantModel] {
      let locale = GetRestaurantsLocaleDataSource(realm: realm!)
      let remote = GetRestaurantsRemoteDataSource(endpoint: EndPoints.Gets.list.url,
        endPointPict: EndPoints.Gets.image.url)
      let restaurantMapper = RestaurantTransformer()
      let mapper = RestaurantsTransformer(restaurantMapper: restaurantMapper)

      let repository = GetRestaurantsRepository(
        localeDataSource: locale,
        remoteDataSource: remote,
        mapper: mapper)

        if let interactor = Interactor(repository: repository) as? U {
                return interactor
            } else {
                fatalError("Failed to cast Interactor to type U")
            }
    }

    func provideRestaurant<U: UseCase>() -> U where U.Request == String, U.Response == RestaurantModel {
      let locale = GetRestaurantsLocaleDataSource(realm: realm!)
      let remote = GetRestaurantRemoteDataSource(endpoint: EndPoints.Gets.detail.url)
      let mapper = RestaurantTransformer()

      let repository = GetRestaurantRepository(
        localeDataSource: locale,
        remoteDataSource: remote,
        mapper: mapper)
      
        if let interactor = Interactor(repository: repository) as? U {
                return interactor
            } else {
                fatalError("Failed to cast Interactor to type U")
            }
    }

    func provideUpdateFavorite<U: UseCase>() -> U where U.Request == String, U.Response == RestaurantModel {
      let locale = GetFavoriteRestaurantsLocaleDataSource(realm: realm!)
      let mapper = RestaurantTransformer()

      let repository = UpdateFavoriteRestaurantRepository(
        localeDataSource: locale,
        mapper: mapper)

        if let interactor = Interactor(repository: repository) as? U {
                return interactor
            } else {
                fatalError("Failed to cast Interactor to type U")
            }
    }

    func provideFavorite<U: UseCase>() -> U where U.Request == String, U.Response == [RestaurantModel] {
      let locale = GetFavoriteRestaurantsLocaleDataSource(realm: realm!)
      let restaurantMapper = RestaurantTransformer()
      let mapper = RestaurantsTransformer(restaurantMapper: restaurantMapper)

      let repository = GetFavoriteRestaurantsRepository(
        localeDataSource: locale,
        mapper: mapper)

        if let interactor = Interactor(repository: repository) as? U {
                return interactor
            } else {
                fatalError("Failed to cast Interactor to type U")
            }
    }
}
