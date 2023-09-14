//
//  File.swift
//  
//
//  Created by Onoh on 11/09/23.
//

import Core
import Combine

public struct GetRestaurantRepository<
RestaurantLocaleDataSource: LocaleDataSource,
RemoteDataSource: DataSource,
Transformer: Mapper
>: Repository where
RestaurantLocaleDataSource.Request == String,
RestaurantLocaleDataSource.Response == RestaurantEntity,
RemoteDataSource.Request == String,
RemoteDataSource.Response == RestaurantResponse,
Transformer.Request == String,
Transformer.Response == RestaurantResponse,
Transformer.Entity == RestaurantEntity,
Transformer.Domain == RestaurantModel {

    public typealias Request = String
    public typealias Response = RestaurantModel

    private let localeDataSource: RestaurantLocaleDataSource
    private let remoteDataSource: RemoteDataSource
    private let mapper: Transformer

    public init(
        localeDataSource: RestaurantLocaleDataSource,
        remoteDataSource: RemoteDataSource,
        mapper: Transformer
    ) {
        self.localeDataSource = localeDataSource
        self.remoteDataSource = remoteDataSource
        self.mapper = mapper
    }

    public func execute(request: String?) -> AnyPublisher<RestaurantModel, Error> {
        guard let request = request else { fatalError("Request cannot be empty") }
        return self.localeDataSource.get(id: request)
            .flatMap { result -> AnyPublisher<RestaurantModel, Error> in
                if result.id.isEmpty {
                    return self.remoteDataSource.execute(request: request)
                        .map { self.mapper.transformResponseToEntity(request: request, response: $0) }
                        .catch { _ in self.localeDataSource.get(id: request) }
                        .flatMap { self.localeDataSource.update(id: request, entity: $0) }
                        .filter { $0 }
                        .flatMap { _ in self.localeDataSource.get(id: request)
                                .map { self.mapper.transformEntityToDomain(entity: $0) }
                        }.eraseToAnyPublisher()
                } else {
                    return self.localeDataSource.get(id: request)
                        .map { self.mapper.transformEntityToDomain(entity: $0) }
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
}
