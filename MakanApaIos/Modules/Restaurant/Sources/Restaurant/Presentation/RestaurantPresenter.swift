//
//  File.swift
//  
//
//  Created by Onoh on 11/09/23.
//

import Foundation
import Combine
import Core

public class RestaurantPresenter<
    RestaurantUseCase: UseCase,
    FavoriteUseCase: UseCase
>: ObservableObject where
RestaurantUseCase.Request == String,
RestaurantUseCase.Response == RestaurantModel,
FavoriteUseCase.Request == String,
FavoriteUseCase.Response == RestaurantModel
{
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let restaurantUseCase: RestaurantUseCase
    private let favoriteUseCase: FavoriteUseCase
    
    @Published public var item: RestaurantModel?
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false
    
    public init(restaurantUseCase: RestaurantUseCase, favoriteUseCase: FavoriteUseCase) {
        self.restaurantUseCase = restaurantUseCase
        self.favoriteUseCase = favoriteUseCase
    }
    
    public func getRestaurant(request: RestaurantUseCase.Request) {
        isLoading = true
        self.restaurantUseCase.execute(request: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure (let error):
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                    self.isLoading = false
                case .finished:
                    self.isLoading = false
                }
            }, receiveValue: { item in
                self.item = item
            })
            .store(in: &cancellables)
    }
    
    public func updateFavoriteRestaurant(request: FavoriteUseCase.Request) {
        self.favoriteUseCase.execute(request: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.isLoading = false
                }
            }, receiveValue: { item in
                self.item = item
            })
            .store(in: &cancellables)
    }
    
}
