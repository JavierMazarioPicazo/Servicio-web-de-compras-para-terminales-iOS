//
//  CartButtonView.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import SwiftUI

struct CartButtonView: View {
    
    var numberOfItems: Int

    var body: some View {
        VStack {
            Image("iconCart")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44, alignment: .center)
                .foregroundColor(.black)
                .overlay(ImageOverlay(numberOfItems: numberOfItems), alignment: .center)
            Spacer()
        }
    }

    struct ImageOverlay: View {
        var numberOfItems: Int

        var body: some View {
            ZStack {
                Text(String(numberOfItems))
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                    .padding(5)
            }
        }
    }
}

struct CartButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CartButtonView(numberOfItems: 3)
    }
}

