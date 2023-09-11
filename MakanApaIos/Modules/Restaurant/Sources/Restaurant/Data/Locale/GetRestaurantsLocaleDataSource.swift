//
//  File.swift
//  
//
//  Created by Onoh on 07/09/23.
//

import Core
import Combine
import RealmSwift
import Foundation

public struct GetRestaurantsLocaleDataSource: LocaleDataSource {

    public typealias Request = String
    public typealias Response = RestaurantEntity

    private let _realm: Realm

    public init(realm: Realm) {
        _realm = realm
    }

    public func list(request: String?) -> AnyPublisher<[RestaurantEntity], Error> {
        return Future<[RestaurantEntity], Error> { completion in
            let restaurants: Results<RestaurantEntity> = {
              _realm.objects(RestaurantEntity.self)
                .sorted(byKeyPath: "name", ascending: true)
            }()
            completion(.success(restaurants.toArray(ofType: RestaurantEntity.self)))

        }.eraseToAnyPublisher()
    }

    // 4
    public func add(entities: [RestaurantEntity]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            do {
                try _realm.write {
                    for restaurant in entities {
                        _realm.add(restaurant, update: .all)
                    }
                    completion(.success(true))
                }
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }
        }.eraseToAnyPublisher()
    }

    // 5
    public func get(id: String) -> AnyPublisher<RestaurantEntity, Error> {
        return Future<RestaurantEntity, Error> { completion in

          let restaurants: Results<RestaurantEntity> = {
            self._realm.objects(RestaurantEntity.self)
              .filter("id = '\(id)'")
          }()

          guard let restaurant = restaurants.first else {
            completion(.failure(DatabaseError.requestFailed))
            return
          }

          completion(.success(restaurant))

        }.eraseToAnyPublisher()
    }

    public func update(id: String, entity: RestaurantEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
          if let restaurantEntity = {
            self._realm.objects(RestaurantEntity.self).filter("id = '\(id)'")
          }().first {
            do {
              try self._realm.write {
                  restaurantEntity.setValue(entity.name, forKey: "name")
                  restaurantEntity.setValue(entity.descriptions, forKey: "descriptions")
                  restaurantEntity.setValue(entity.pictureId, forKey: "pictureId")
                  restaurantEntity.setValue(entity.city, forKey: "city")
                  restaurantEntity.setValue(entity.rating, forKey: "rating")
                  restaurantEntity.setValue(entity.favorite, forKey: "favorite")
              }
              completion(.success(true))

            } catch {
              completion(.failure(DatabaseError.requestFailed))
            }
          } else {
            completion(.failure(DatabaseError.invalidInstance))
          }
        }.eraseToAnyPublisher()
    }
}
