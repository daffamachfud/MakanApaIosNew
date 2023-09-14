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
    RestaurantUseCase: UseCase
>: ObservableObject where
RestaurantUseCase.Request == String,
RestaurantUseCase.Response == RestaurantModel {

    private var cancellables: Set<AnyCancellable> = []
    private let restaurantUseCase: RestaurantUseCase

    @Published public var item: RestaurantModel?
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false

    public init(restaurantUseCase: RestaurantUseCase) {
        self.restaurantUseCase = restaurantUseCase
    }

    public func getRestaurant(request: RestaurantUseCase.Request) {
        isLoading = true
        self.restaurantUseCase.execute(request: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
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

}
