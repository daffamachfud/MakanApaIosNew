//
//  File.swift
//  
//
//  Created by Onoh on 11/09/23.
//

import Foundation
import Combine
import Core
import Alamofire

public struct GetRestaurantRemoteDataSource: DataSource {
    public typealias Request = String
    public typealias Response = RestaurantResponse
    private let endpoint: String
    public init (endpoint: String) {
        self.endpoint = endpoint
    }

    public func execute(request: String?) -> AnyPublisher<RestaurantResponse, Error> {
        return Future<RestaurantResponse, Error> { completion in

          guard let request = request else { return completion(.failure(URLError.invalidRequest) )}

          if let url = URL(string: self.endpoint + request) {
            AF.request(url)
              .validate()
              .responseDecodable(of: RestaurantResponse.self) { response in
                switch response.result {
                case .success(let value):
                  completion(.success(value))
                case .failure:
                  completion(.failure(URLError.invalidResponse))
                }
              }
          }
        }.eraseToAnyPublisher()
    }
}
