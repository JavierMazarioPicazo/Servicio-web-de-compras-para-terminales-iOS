//
//  CartView.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import Foundation
import SwiftUI
import BraintreeDropIn

struct CartState {
    var cart: Cart
    var service: ProductService
}

enum CartInput {
    case checkout
}


struct CartView: View {
    @State var showDropIn = false
    let tokenizationKey = "Your tokenization Key"
    @Binding var showModal: Bool
    
    @State private var showingAlert = false
    @ObservedObject
    var viewModel: AnyViewModel<CartState, CartInput>
    
    init(service: ProductService, showModal: Binding<Bool>) {
        self.viewModel = AnyViewModel(CartViewModel(service: service))
        self._showModal = showModal
    }
    
    var body: some View {
        
        ZStack {
            ScrollView(.vertical) {
                
                VStack {
                    // Dismiss button
                    HStack() {
                        Image("iconClose")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding(20)
                        
                        Spacer()
                    }
                    
                    // Title
                    VStack {
                        Text("Tu cesta")
                            .font(.system(size: 34))
                            .fontWeight(.bold)
                        Text(String(viewModel.state.cart.numberOfItems) + " ítems")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                    
                    // Item list
                    VStack(alignment: .leading) {
                        ForEach(viewModel.state.cart.items) { item in
                            CartRow(item: item)
                        }
                    }
                    
                    Spacer().frame(height: 20)
                    
                    // Summary
                    HStack {
                        VStack {
                            Image("shipping")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .padding(.bottom, -8)
                            Text("FREE")
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                        }.frame(width: 64, height: 64)
                            .background(Color.gray.opacity(0.4))
                            .cornerRadius(15)
                        
                        Spacer().frame(width: 40)
                        
                        VStack(alignment: .leading) {
                            Text("Total:")
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                            Text("€" + String(roundTotal(viewModel.state.cart.total)))
                                .font(.system(size: 34))
                                .fontWeight(.bold)
                        }
                        
                        Spacer().frame(width: 80)
                    }
                    
                    // Checkout button
                    Divider().padding()
                    
                    Button(action: {
                        self.showingAlert = true
                        self.showDropIn = true
                    }) {
                        HStack {
                            Text("Pasar por caja")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                        }
                        .frame(width: 200)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(40)
                    }
                    
                }
                
                
            }
            if self.showDropIn {
                DropInRepresentable(authorization: tokenizationKey, handler: { controller, result, error in
                    if let error = error {
                        print(error)
                    } else if (result?.isCanceled == true) {
                        self.showDropIn = false
                    } else  if let result=result{
                        let url = URL(string: "The url of your server")!
                        var request = URLRequest(url: url)
                        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
                        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
                        request.httpMethod = "POST"
                        let parameters: [String: String] = ["amount": "\(roundTotal(viewModel.state.cart.total))", "payment_method_nonce":"\(result.paymentMethod!.nonce)"]
                        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
                        request.httpBody = httpBody
                        
                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            guard let data = data,
                                  let response = response as? HTTPURLResponse,
                                  error == nil else {                                              // check for fundamental networking error
                                      print("error", error ?? "Unknown error")
                                      return
                                  }
                            
                            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                                print("statusCode should be 2xx, but is \(response.statusCode)")
                                print("response = \(response)")
                                return
                            }
                            
                            let responseString = String(data: data, encoding: .utf8)
                            print("\(responseString!)")
                        }
                        
                        task.resume()
                        
                        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
                            print(request)
                        }.resume()
                        self.showModal.toggle()
                        self.viewModel.trigger(.checkout)
                        self.showDropIn = false
                        
                    }
                   
                                
                    
                }, service: self.viewModel.state.service).edgesIgnoringSafeArea(.vertical)
                    
            }
        }
    }
}

private extension CartView {
    func roundTotal(_ total: Double) -> Double {
        let divisor = pow(10.0, Double(2))
        return (total * divisor).rounded() / divisor
    }
    
    func checkout() {
        viewModel.trigger(.checkout)
        self.showModal.toggle()
    }
}
