//
//  MakanApaIosApp.swift
//  MakanApaIos
//
//  Created by Onoh on 01/09/23.
//

import SwiftUI
import RealmSwift
import Core
import Restaurant
import Favorite

let injection = Injection()

let restaurantUseCase: Interactor<
  String,
  [RestaurantModel],
  GetRestaurantsRepository<
    GetRestaurantsLocaleDataSource,
    GetRestaurantsRemoteDataSource,
    RestaurantsTransformer<RestaurantTransformer>>
> = injection.provideRestaurants()

let favoriteUseCase: Interactor<
    String,
    [RestaurantModel],
    GetFavoriteRestaurantsRepository<
        GetFavoriteRestaurantsLocaleDataSource,
        RestaurantsTransformer<RestaurantTransformer>>
> = injection.provideFavorite()

@main
struct MakanApaIosApp: SwiftUI.App {
    let homePresenter = GetListPresenter(useCase: restaurantUseCase)
    let favoritePresenter = GetListPresenter(useCase: favoriteUseCase)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homePresenter)
                .environmentObject(favoritePresenter)
        }
    }
}
