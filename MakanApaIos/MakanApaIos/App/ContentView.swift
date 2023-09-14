//
//  ContentView.swift
//  MakanApaIos
//
//  Created by Onoh on 01/09/23.
//

import SwiftUI
import Core
import Restaurant
import Favorite

struct ContentView: View {
@EnvironmentObject var homePresenter:
GetListPresenter<String, RestaurantModel,
Interactor<String, [RestaurantModel], GetRestaurantsRepository<GetRestaurantsLocaleDataSource,
GetRestaurantsRemoteDataSource, RestaurantsTransformer<RestaurantTransformer>>>>

@EnvironmentObject var favoritePresenter:
GetListPresenter<String, RestaurantModel,
Interactor<String, [RestaurantModel], GetFavoriteRestaurantsRepository<GetFavoriteRestaurantsLocaleDataSource,
RestaurantsTransformer<RestaurantTransformer>>>>

    var body: some View {
        TabView {
            NavigationView {
                HomeView(presenter: homePresenter)
            }.tabItem {
                Label("Explore", systemImage: "safari")
            }
            NavigationView {
                FavoriteView(presenter: favoritePresenter)
            }.tabItem {
                Label("Favorite", systemImage: "heart.fill")
            }
            NavigationView {
                AboutView()
            }.tabItem {
                Label("About", systemImage: "person")
            }
        }
    }
}
