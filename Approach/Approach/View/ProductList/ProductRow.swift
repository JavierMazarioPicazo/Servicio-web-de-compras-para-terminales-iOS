//
//  ProductRow.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation
import SwiftUI

struct ProductRow: View {
    
    var product: Product
    @EnvironmentObject var imageStore: ImageStore

    var body: some View {
        HStack {
            ProductImage(image: imageStore.image(url: product.imageInfo?.url))
            VStack(alignment: .leading) {
                Text(product.category).font(.headline)
                Text(product.color).font(.subheadline).foregroundColor(.gray)
                Spacer().frame(height: 15)
                Text("€" + String(product.price)).font(.title)
            }
        }
    }
}


