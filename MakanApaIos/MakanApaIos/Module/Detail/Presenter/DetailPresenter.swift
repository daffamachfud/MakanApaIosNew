//
//  DetailPresenter.swift
//  MakanApaIos
//
//  Created by Onoh on 01/09/23.
//

import Foundation
import Combine

class DetailPresenter: ObservableObject {

    private let detailUseCase: DetailUseCase
    private var cancellables: Set<AnyCancellable> = []
    @Published var restaurant: RestaurantModel
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false

init(detailUseCase: DetailUseCase) {
        self.detailUseCase = detailUseCase
        restaurant = detailUseCase.getRestaurant()
    }

func getRestaurant() {
        isLoading = true
        detailUseCase.getRestaurant()
          .receive(on: RunLoop.main)
          .sink(receiveCompletion: { completion in
              switch completion {
              case .failure(let error):
                  print(error)
                self.errorMessage = error.localizedDescription
                self.isError = true
                self.isLoading = false
              case .finished:
                self.isLoading = false
              }
            }, receiveValue: { restaurant in
              self.restaurant = restaurant
            })
            .store(in: &cancellables)
      }

      func updateFavoriteRestaurant() {
        detailUseCase.updateFavoriteRestaurant()
          .receive(on: RunLoop.main)
          .sink(receiveCompletion: { completion in
              switch completion {
              case .failure:
                self.errorMessage = String(describing: completion)
              case .finished:
                self.isLoading = false
              }
            }, receiveValue: { restaurant in
              self.restaurant = restaurant
            })
            .store(in: &cancellables)
      }
}
