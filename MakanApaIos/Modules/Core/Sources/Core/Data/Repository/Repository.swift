//
//  File.swift
//  
//
//  Created by Onoh on 07/09/23.
//

import Combine

public protocol Repository {
    associatedtype Request
    associatedtype Response

    func execute(request: Request?) -> AnyPublisher<Response, Error>
}
