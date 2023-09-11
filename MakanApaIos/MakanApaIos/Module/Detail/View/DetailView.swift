//
//  DetailView.swift
//  MakanApaIos
//
//  Created by Onoh on 01/09/23.
//

import SwiftUI
import CachedAsyncImage
import Restaurant
import Core

struct DetailView: View {
    @State private var showingAlert = false

@ObservedObject var presenter: RestaurantPresenter<Interactor<String, RestaurantModel,
GetRestaurantRepository<GetRestaurantsLocaleDataSource, GetRestaurantRemoteDataSource, RestaurantTransformer>>,
Interactor<String, RestaurantModel, UpdateFavoriteRestaurantRepository<GetFavoriteRestaurantsLocaleDataSource,
RestaurantTransformer>>>

    var restaurant: RestaurantModel

    var body: some View {
        ZStack {
            if presenter.isLoading {
                loadingIndicator
            } else if presenter.isError {
                errorIndicator
            } else {
                ScrollView(.vertical) {
                    VStack {
                        imageMeal
                        content
                    }.padding()
                }
            }
        }.onAppear {
            self.presenter.getRestaurant(request: restaurant.id)
        }.alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Oops!"),
                message: Text("Something wrong!"),
                dismissButton: .default(Text("OK"))
            )
        }.navigationBarTitle(
            Text(presenter.item?.name ?? ""),
            displayMode: .automatic
        )
    }
}

extension DetailView {

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
            Text(presenter.errorMessage + "WOY")
                .font(.system(.body, design: .rounded))
        }
    }

    var imageMeal: some View {
        CachedAsyncImage(url: URL(string: self.presenter.item?.pictureID ?? "")) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }.scaledToFill()
            .frame(width: UIScreen.main.bounds.width - 32, height: 250.0, alignment: .center)
            .cornerRadius(30)
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()
                .padding(.vertical)
            HStack(alignment: .center) {
                Text(self.presenter.item?.name ?? "")
                    .font(
                        .title2
                            .weight(.bold)
                    )
                    .foregroundColor(.black)
                Spacer()
                Spacer()
                Spacer()
                if presenter.item?.favorite == true {
                    CustomIcon(
                        imageName: "heart.fill",
                        title: "Favorited"
                    ).onTapGesture {
                        self.presenter.updateFavoriteRestaurant(request: restaurant.id)
                    }
                } else {
                    CustomIcon(
                        imageName: "heart",
                        title: "Favorite"
                    ).onTapGesture {
                        self.presenter.updateFavoriteRestaurant(request: restaurant.id)
                    }
                }
            }
            HStack {
                let formattedRating = String(format: "%.1f", self.presenter.item?.rating ?? 0.0)
                Label(formattedRating, systemImage: "star.fill")
                Spacer()
                Spacer()
                Label(self.presenter.item?.city ?? "", systemImage: "mappin.and.ellipse")
            }
            Text(self.presenter.item?.description ?? "")
                .font(.system(size: 16))
        }.padding(.top)
    }
}

extension DetailView {
    func openUrl(_ linkUrl: String) {
        if let link = URL(string: linkUrl) {
            UIApplication.shared.open(link)
        } else {
            showingAlert = true
        }
    }
}
