//
//  CartRow.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import SwiftUI

struct CartRow: View {
    var item: Item
    @EnvironmentObject var imageStore: ImageStore
    var body: some View {
        HStack {
            ProductImage(image: imageStore.image(url: item.item.imageInfo?.url))
            VStack(alignment: .leading) {
                Text(item.item.category)
                Text(item.item.reference)
                Spacer().frame(height: 15)
                Text("€" + String(item.item.price)).font(.system(size: 18)).bold()
            }.padding([.top, .bottom])
                .frame(width: 150)

            ProductDetailLabel(text: "x" + String(item.units))
                .padding(.leading, 20)
        }
    }
}

