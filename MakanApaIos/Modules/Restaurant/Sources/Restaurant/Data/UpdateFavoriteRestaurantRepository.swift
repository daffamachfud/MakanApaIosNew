//
//  File.swift
//  
//
//  Created by Onoh on 11/09/23.
//

import Core
import Combine

public struct UpdateFavoriteRestaurantRepository<
  RestaurantLocaleDataSource: LocaleDataSource,
  Transformer: Mapper
>: Repository where
RestaurantLocaleDataSource.Request == String,
RestaurantLocaleDataSource.Response == RestaurantEntity,
  Transformer.Request == String,
  Transformer.Response == RestaurantResponse,
  Transformer.Entity == RestaurantEntity,
  Transformer.Domain == RestaurantModel
{

  public typealias Request = String
  public typealias Response = RestaurantModel

  private let localeDataSource: RestaurantLocaleDataSource
  private let mapper: Transformer

  public init(
    localeDataSource: RestaurantLocaleDataSource,
    mapper: Transformer
  ) {
    self.localeDataSource = localeDataSource
    self.mapper = mapper
  }

  public func execute(request: String?) -> AnyPublisher<RestaurantModel, Error> {
    return self.localeDataSource.get(id: request ?? "")
      .map { self.mapper.transformEntityToDomain(entity: $0) }
      .eraseToAnyPublisher()
  }
}
