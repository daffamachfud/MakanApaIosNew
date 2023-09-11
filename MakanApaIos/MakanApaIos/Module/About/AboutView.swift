//
//  AboutView.swift
//  MakanApaIos
//
//  Created by Onoh on 01/09/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("img_profile")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("Daffa Radifanka")
                .font(
                    .title2
                        .weight(.bold)
                )
                .foregroundColor(.black)
            Text("Mobile Developer")
            Text("daffamachfud@gmail.com")
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
