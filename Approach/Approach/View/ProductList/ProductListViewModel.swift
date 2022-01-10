//
//  ProductListViewModel.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation
import Combine
import SwiftUI

class ProductListViewModel: ViewModel {
    
    @Published
    var state: ProductListState
    
    init(service: ProductService) {
        self.state = ProductListState(service: service)
        
    }
    
    func trigger(_ input: Never) {
    }
    
}
