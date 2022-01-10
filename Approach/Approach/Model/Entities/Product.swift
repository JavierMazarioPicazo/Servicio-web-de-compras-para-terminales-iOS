//
//  Product.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation
import SwiftUI

struct Product: Decodable, Identifiable {
    var id: Int
    var productId: String
    var reference: String
    var color: String
    var category: String
    var price: Double
    var composition: String
    var isAvailable: Bool
    let imageInfo: ImageFile?
    
    struct ImageFile: Codable {
        let filename: String?
        let mime: String?
        let url: URL?
    }
}

extension Product {
    var image: Image {
        Image(uiImage: ImageStore.shared.image(url: imageInfo!.url!))
    }
}
