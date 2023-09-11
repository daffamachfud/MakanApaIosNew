//
//  FavoriteView.swift
//  MakanApaIos
//
//  Created by Onoh on 01/09/23.
//

import SwiftUI
import Core
import Restaurant

struct FavoriteView: View {

@State private var showingAlert = false
@ObservedObject var presenter: GetListPresenter<String, RestaurantModel,
Interactor<String, [RestaurantModel], GetFavoriteRestaurantsRepository<GetFavoriteRestaurantsLocaleDataSource, RestaurantsTransformer<RestaurantTransformer>>>>

    var body: some View {
        ZStack {
          if presenter.isLoading {
            loadingIndicator
          } else if presenter.isError {
            errorIndicator
          } else if presenter.list.count == 0 {
            emptyIndicator
          } else {
              ScrollView(.vertical) {
                  VStack(alignment: .leading) {
                      header
                      content
                  }
              }
          }
        }.onAppear {
          self.presenter.getList(request: nil)
        }.navigationBarTitle(
          Text("Favorite Meals"),
          displayMode: .automatic
        )
    }
}

extension FavoriteView {
    var loadingIndicator: some View {
        VStack {
            Text("Loading...")
            ProgressView()
        }
    }

    var errorIndicator: some View {
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

    var header: some View {
        VStack(alignment: .leading) {
            Image("img_fav")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("Favorit")
                .font(
                    .title2
                        .weight(.bold)
                )
                .foregroundColor(.black)
            Text("Tempat - tempat favorit kamu nih!")
                .font(
                    .title3
                )
                .foregroundColor(.black)
        }.padding(.all)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }

    var emptyIndicator: some View {
        VStack(alignment: .leading) {
            Image("img_fav")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("Favorit")
                .font(
                    .title2
                        .weight(.bold)
                )
                .foregroundColor(.black)
            Text("Tempat - tempat favorit kamu nih!")
                .font(
                    .title3
                )
                .foregroundColor(.black)
            Text("Belum ada favorit")
                .font(
                    .title3
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center) // Center-align the text
                        .foregroundColor(.black)
        }.padding(.all)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }

    var content: some View {
            ForEach(
                self.presenter.list,
                id: \.id
            ) { restaurant in
                ZStack {
                    self.linkBuilder(for: restaurant) {
                        FavoriteRow(restaurant: restaurant)
                    }.buttonStyle(PlainButtonStyle())
                }.padding(8)
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
}
