//
//  ProductDetailLabel.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation
import SwiftUI

struct ProductDetailLabel: View {

    var text: String

    var body: some View {
        Text(text)
            .fontWeight(.semibold)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

