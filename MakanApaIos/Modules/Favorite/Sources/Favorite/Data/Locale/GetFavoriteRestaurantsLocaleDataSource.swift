//
//  File.swift
//  
//
//  Created by Onoh on 09/09/23.
//

import Core
import Combine
import RealmSwift
import Foundation
import Restaurant

public struct GetFavoriteRestaurantsLocaleDataSource: LocaleDataSource {

  public typealias Request = String
  public typealias Response = RestaurantEntity
  private let realm: Realm

  public init(realm: Realm) {
    self.realm = realm
  }

  public func list(request: String?) -> AnyPublisher<[RestaurantEntity], Error> {
    return Future<[RestaurantEntity], Error> { completion in

      let restaurantEntities = {
        realm.objects(RestaurantEntity.self)
          .filter("favorite = \(true)")
          .sorted(byKeyPath: "name", ascending: true)
      }()
      completion(.success(restaurantEntities.toArray(ofType: RestaurantEntity.self)))

    }.eraseToAnyPublisher()
  }

  public func add(entities: [RestaurantEntity]) -> AnyPublisher<Bool, Error> {
    fatalError()
  }

  public func get(id: String) -> AnyPublisher<RestaurantEntity, Error> {
      debugPrint("Iyah kesini")
    return Future<RestaurantEntity, Error> { completion in
      if let restaurantEntity = {
        self.realm.objects(RestaurantEntity.self).filter("id = '\(id)'")
      }().first {
        do {
          try self.realm.write {
            restaurantEntity.setValue(!restaurantEntity.favorite, forKey: "favorite")
          }
          completion(.success(restaurantEntity))
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }.eraseToAnyPublisher()
  }

    public func update(id: String, entity: RestaurantEntity) -> AnyPublisher<Bool, Error> {
        fatalError()
    }

}
