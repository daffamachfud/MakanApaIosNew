//
//  APICall.swift
//  MakanApaIos
//
//  Created by Onoh on 01/09/23.
//

import Foundation

struct API {
    static let baseUrl = "https://restaurant-api.dicoding.dev/"
}

protocol Endpoint {
    var url: String { get }
}

enum EndPoints {
    enum Gets: Endpoint {
       case list
        case detail
        case image

       public var url: String {
         switch self {
         case .list: return "\(API.baseUrl)list"
         case .detail: return "\(API.baseUrl):"
         case .image: return "\(API.baseUrl)images/large/"
         }
       }
     }
}
