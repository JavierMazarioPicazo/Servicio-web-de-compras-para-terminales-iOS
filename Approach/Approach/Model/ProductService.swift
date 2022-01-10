//
//  ProductService.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation
import SwiftUI

protocol ProductService {
    
    func getProducts()
    
    func productList() -> [Product]
    
    func productDetails(productId: Int) -> Product
    func numberOfCartItems() -> Int
    func addToCart(productId: Int)
    
    func cartItems() -> Cart
    func checkout()
}
