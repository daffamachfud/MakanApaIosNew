//
//  FavoriteRouter.swift
//  MakanApaIos
//
//  Created by Onoh on 04/09/23.
//

import SwiftUI
import Core
import Restaurant
import Favorite

class FavoriteRouter {

    func makeMealView(for restaurant: RestaurantModel) -> some View {
        let useCase: Interactor<
            String,
            RestaurantModel,
            GetRestaurantRepository<
                GetRestaurantsLocaleDataSource,
                GetRestaurantRemoteDataSource,
                RestaurantTransformer>
        > = Injection.init().provideRestaurant()

        let favoriteUseCase: Interactor<
            String,
            RestaurantModel,
            UpdateFavoriteRestaurantRepository<
                GetFavoriteRestaurantsLocaleDataSource,
                RestaurantTransformer>
        > = Injection.init().provideUpdateFavorite()

        let presenter = RestaurantPresenter(restaurantUseCase: useCase)
        let favoritePresenter = FavoritePresenter(favoriteUseCase: favoriteUseCase)

        return DetailView(presenter: presenter, favPresenter: favoritePresenter, restaurant: restaurant)
    }

}
