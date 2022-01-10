//
//  CartViewModel.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//


import Foundation

class CartViewModel: ViewModel {
    
    @Published
    var state: CartState

    init(service: ProductService) {
        let cart = service.cartItems()
        self.state = CartState(cart: cart, service: service)
    }

    func trigger(_ input: CartInput) {
        switch input {
        case .checkout:
            state.service.checkout()
            state.cart = state.service.cartItems()
        }
    }
    
}
