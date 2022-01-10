//
//  ProductDeatilButton.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation
import SwiftUI

struct ProductDetailButton: View {

    var text: String
    var buttonColor: Color

    var body: some View {
        HStack {
            Text(text)
                .fontWeight(.semibold)
        }
        .frame(width: 200)
        .padding()
        .foregroundColor(.white)
        .background(buttonColor)
        .cornerRadius(40)
    }
}
