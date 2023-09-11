//
//  File.swift
//  
//
//  Created by Onoh on 07/09/23.
//

import Core
import Combine
import Alamofire
import Foundation

public struct GetRestaurantsRemoteDataSource: DataSource {
    public typealias Request = Any
    public typealias Response = [RestaurantResponse]
    private let _endpoint: String
    private let _endPointPict: String
    public init(endpoint: String, endPointPict: String) {
        _endpoint = endpoint
        _endPointPict = endPointPict
    }

    public func execute(request: Any?) -> AnyPublisher<[RestaurantResponse], Error> {
        return Future<[RestaurantResponse], Error> { completion in
            if let url = URL(string: _endpoint) {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: ListRestaurantResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            var restaurants = value.restaurants
                            restaurants = restaurants
                                .compactMap { restaurant -> RestaurantResponse? in
                                    var restaurantWithImage = restaurant
                                    restaurantWithImage.pictureID = _endPointPict + restaurant.pictureID
                                    return restaurantWithImage
                                }
                            completion(.success(restaurants))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
}
