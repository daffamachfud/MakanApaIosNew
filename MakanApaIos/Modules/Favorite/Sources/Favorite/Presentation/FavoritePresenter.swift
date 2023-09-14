//
//  File.swift
//  
//
//  Created by Onoh on 14/09/23.
//

import Foundation
import Combine
import Core
import Restaurant

public class FavoritePresenter<
    FavoriteUseCase: UseCase
>: ObservableObject where
FavoriteUseCase.Request == String,
FavoriteUseCase.Response == RestaurantModel {

    private var cancellables: Set<AnyCancellable> = []
    private let favoriteUseCase: FavoriteUseCase

    @Published public var item: RestaurantModel?
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false

    public init(favoriteUseCase: FavoriteUseCase) {
        self.favoriteUseCase = favoriteUseCase
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
