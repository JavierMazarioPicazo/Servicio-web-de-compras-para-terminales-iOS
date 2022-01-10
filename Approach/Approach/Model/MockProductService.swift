//
//  MockProductService.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation
import Combine
import SwiftUI
import UIKit
import BraintreeDropIn
import Braintree

class MockProductService: ProductService, ObservableObject {

    let session = URLSession.shared
    let urlBase = "The url of your server"
    let tokenizationKey = "Your sandbox tokenization key"
    
    @Published var products: [Product] = []
    var cart = Cart(items: [], numberOfItems: 0, total: 0)
    
    
    func getProducts() {
            let url = URL(string: "\(self.urlBase)")
            URLSession.shared.dataTask(with: url!) { data, response, error in
                if let _ = error {
                    print("Error")
                }
                
                if let data = data,
                   let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 {
                    let products = try! JSONDecoder().decode([Product].self, from: data)
                    DispatchQueue.main.async(){
                        self.products = products
                        print("Productos cargados")
                        print(self.products)
                    }
                    
                }
                
            }.resume()

        
    }
    
    
    func productList() -> [Product] {
        return products
    }
    
    func productDetails(productId: Int) -> Product {
        let details = products.first{$0.id == productId}
        return details!
    }
    
    func numberOfCartItems() -> Int {
        return cart.numberOfItems
    }
    
    func addToCart(productId: Int) {
        guard let product = (products.first{$0.id == productId}) else {return}
        
        cart.numberOfItems += 1
        cart.total += product.price
        updateItemCart(product: product)
    }
    
    func cartItems() -> Cart {
        return cart
    }
    
    func checkout() {
        for item in cart.items {
            productAvailable(id: item.item.id)
        }
        cart = Cart(items: [], numberOfItems: 0, total: 0)
    }
    
}

private extension MockProductService {
    
    func productAvailable(id: Int) {
        if let row = products.firstIndex(where: {$0.id == id}),
            var product = products.first(where: {$0.id == id}) {
            product.isAvailable = true
            products[row] = product
        }
    }

    func updateItemCart(product: Product) {
        if let index = (cart.items.firstIndex{ $0.item.id == product.id }) {
            cart.items[index].units += 1
        } else {
            cart.items.append(Item(id: UUID().uuidString, item: product, units: 1))
        }
    }
    
}
