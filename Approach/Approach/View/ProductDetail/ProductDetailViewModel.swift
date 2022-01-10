//
//  ProductDetailViewModel.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation

class ProductDetailViewModel: ViewModel {

    @Published
    var state: ProductDetailState

    init(service: ProductService, id: Int) {
        let detail = service.productDetails(productId: id)
        let items = service.numberOfCartItems()
        state = ProductDetailState(service: service, productDetail: detail, cartItems: items)
    }

    func trigger(_ input: ProductDetailInput) {
        switch input {
        case .addProductToCart:
            state.service.addToCart(productId: state.productDetail.id)
            state.cartItems = state.service.numberOfCartItems()
        case .reloadState:
            state.productDetail = state.service.productDetails(productId: state.productDetail.id)
            state.cartItems = state.service.numberOfCartItems()
        }
    }
}

