//
//  ProductDetailImage.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation
import SwiftUI

struct ProductDetailImage: View {
    let image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: 220, height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .gray, radius: 10, x: 5, y: 5)
            .padding()
    }
}
