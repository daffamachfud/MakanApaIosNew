//
//  FavoriteRow.swift
//  MakanApaIos
//
//  Created by Onoh on 07/09/23.
//

import SwiftUI
import CachedAsyncImage
import Core
import Restaurant

struct FavoriteRow: View {
    var restaurant: RestaurantModel
    var body: some View {
        HStack {
            imageCategory
            content
        }
    }
}

extension FavoriteRow {
    var imageCategory: some View {
        CachedAsyncImage(url: URL(string: restaurant.pictureID)) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }.cornerRadius(10).frame(width: 120, height: 100)
    }
    var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(restaurant.name)
            let formattedRating = String(format: "%.1f", restaurant.rating)
            Label(formattedRating, systemImage: "star.fill")
            Label(restaurant.city, systemImage: "mappin.and.ellipse")
        }
    }
}
