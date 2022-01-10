//
//  ProductListView.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation
import SwiftUI


struct ProductListState {
    var service: ProductService
}

struct ProductListView: View {
    
    @ObservedObject
    var viewModel: AnyViewModel<ProductListState, Never>
    @ObservedObject var mockProductService: MockProductService
    
    var body: some View{
        NavigationView{
            VStack(alignment: .leading){
                HStack{
                    Text("Lista de productos")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    Spacer()
                    
                    NavigationLink(destination: ProfileView()){
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 25.0))
                            .foregroundColor(Color.black)
                        
                    }
                }
                .padding()
                List(mockProductService.products) { product in
                    NavigationLink(destination: NavigationLazyView(ProductDetailView(service: self.viewModel.state.service, productId: product.id))) {
                        ProductRow(product: product)
                    }
                }
                .navigationBarTitle("Tienda")
            }
        }
        
        
    }
}

