//
//  Cart.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation

struct Item: Identifiable {
    var id: String
    var item: Product
    var units: Int
}


struct Cart {
    var items: [Item]
    var numberOfItems: Int
    var total: Double
}
