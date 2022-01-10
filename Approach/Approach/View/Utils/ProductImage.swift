//
//  PorductImage.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation
import SwiftUI

struct ProductImage: View {
    
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
        .resizable()
        .frame(width: 110, height: 110)
        .aspectRatio(contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .gray, radius: 10, x: 5, y: 5)
        .padding()
    }
}
