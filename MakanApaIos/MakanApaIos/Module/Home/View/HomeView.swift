//
//  HomeView.swift
//  MakanApaIos
//
//  Created by Onoh on 01/09/23.
//

import SwiftUI
import Core
import Restaurant

struct HomeView: View {
@ObservedObject var presenter: GetListPresenter<String, RestaurantModel,
Interactor<String, [RestaurantModel], GetRestaurantsRepository<GetRestaurantsLocaleDataSource,
GetRestaurantsRemoteDataSource, RestaurantsTransformer<RestaurantTransformer>>>>

    var body: some View {
        ZStack {
            if presenter.isLoading {
                loadingIndicator
            } else if presenter.isError {
                errorResponse
            } else if presenter.list.isEmpty {
                emptyRestaurant
            } else {
                content
            }
        }.onAppear {
            if self.presenter.list.count == 0 {
                self.presenter.getList(request: nil)
            }
        }
    }
}

extension HomeView {
    var loadingIndicator: some View {
        VStack {
            Text("Loading...")
            ProgressView()
        }
    }

    var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                Image("img_home")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                VStack(alignment: .leading) {
                    Text("Mau makan apa?")
                        .font(
                            .title2
                                .weight(.bold)
                        )
                        .foregroundColor(.black)
                    Text("Jangan bilang terserah")
                        .font(
                            .title3
                        )
                        .foregroundColor(.black)
                    ForEach(
                        self.presenter.list,
                        id: \.id
                    ) { restaurant in
                        ZStack {
                            linkBuilder(for: restaurant) {
                                RestoView(restaurant: restaurant)
                            }.buttonStyle(PlainButtonStyle())
                        }.buttonStyle(PlainButtonStyle())
                    }
                }.padding(.all)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    var emptyRestaurant: some View {
        VStack {
            Image("img_empty")
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(width: 250)
            Text("Belum ada list restaurant")
                .font(.system(.body, design: .rounded))
        }
    }

    var errorResponse: some View {
        VStack {
            Image("img_empty")
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(width: 250)
            Text(presenter.errorMessage)
                .font(.system(.body, design: .rounded))
        }
    }
}

func linkBuilder<Content: View>(
    for restaurant: RestaurantModel,
    @ViewBuilder content: () -> Content
) -> some View {
    NavigationLink(
        destination: HomeRouter().makeDetailView(for: restaurant)
    ) { content() }
}
