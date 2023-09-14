//
//  File.swift
//  
//
//  Created by Onoh on 07/09/23.
//

import Core
import Combine

// 1
public struct GetRestaurantsRepository<
RestaurantLocaleDataSource: LocaleDataSource,
RemoteDataSource: DataSource,
Transformer: Mapper>: Repository where
RestaurantLocaleDataSource.Request == String,
RestaurantLocaleDataSource.Response == RestaurantEntity,
RemoteDataSource.Response == [RestaurantResponse],
Transformer.Request == String,
Transformer.Response == [RestaurantResponse],
Transformer.Entity == [RestaurantEntity],
Transformer.Domain == [RestaurantModel] {

    public typealias Request = String
    public typealias Response = [RestaurantModel]

    private let _localeDataSource: RestaurantLocaleDataSource
    private let _remoteDataSource: RemoteDataSource
    private let _mapper: Transformer

    public init(
        localeDataSource: RestaurantLocaleDataSource,
        remoteDataSource: RemoteDataSource,
        mapper: Transformer) {
            _localeDataSource = localeDataSource
            _remoteDataSource = remoteDataSource
            _mapper = mapper
        }

    public func execute(request: String?) -> AnyPublisher<[RestaurantModel], Error> {
        return _localeDataSource.list(request: nil)
            .flatMap { result -> AnyPublisher<[RestaurantModel], Error> in
                if result.isEmpty {
                    return _remoteDataSource.execute(request: nil)
                        .map { _mapper.transformResponseToEntity(request: request, response: $0) }
                        .catch { _ in _localeDataSource.list(request: nil) }
                        .flatMap { _localeDataSource.add(entities: $0) }
                        .filter { $0 }
                        .flatMap { _ in _localeDataSource.list(request: nil)
                                .map { _mapper.transformEntityToDomain(entity: $0) }
                        }
                        .eraseToAnyPublisher()
                } else {
                    return _localeDataSource.list(request: nil)
                        .map { _mapper.transformEntityToDomain(entity: $0) }
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
}
