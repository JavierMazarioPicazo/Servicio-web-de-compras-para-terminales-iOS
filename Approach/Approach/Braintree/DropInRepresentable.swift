//
//  DropInRepresentable.swift
//  Approach
//
//  Created by Javier Mazario on 27/9/21.
//


import SwiftUI
import BraintreeDropIn

struct DropInRepresentable: UIViewControllerRepresentable {
    
    var authorization: String
    var handler: BTDropInControllerHandler
    var braintreeClient: BTAPIClient!
    @ObservedObject
    var viewModel: AnyViewModel<CartState, CartInput>
    
    
    init(authorization: String, handler: @escaping BTDropInControllerHandler, service: ProductService) {
        self.authorization = authorization
        self.handler = handler
        self.viewModel = AnyViewModel(CartViewModel(service: service))
        
    }
    
    func makeUIViewController(context: Context) -> BTDropInController {
        let payPalRequest = BTPayPalCheckoutRequest(amount:"\(viewModel.state.cart.total)")
        let request = BTDropInRequest()
        
        request.payPalRequest = payPalRequest
        request.applePayDisabled = true
        request.cardDisabled = true  
        
        let dropInController = BTDropInController(authorization: authorization, request: request, handler: handler)!
        return dropInController
    }
    
    func updateUIViewController(_ uiViewController: BTDropInController, context: UIViewControllerRepresentableContext<DropInRepresentable>) {
        
    }
}


