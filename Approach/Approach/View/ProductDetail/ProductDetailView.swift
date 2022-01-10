//
//  ProductDetailView.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//


import SwiftUI

struct ProductDetailState {
    var service: ProductService
    var productDetail: Product
    var cartItems: Int
}

enum ProductDetailInput {
    case addProductToCart
    case reloadState
}


struct ProductDetailView: View {
    var size = ["S", "M", "L", "XL", "2XL", "3XL"]
    @State private var selectedSize = "L"
    @EnvironmentObject var imageStore: ImageStore
    @ObservedObject
    var viewModel: AnyViewModel<ProductDetailState, ProductDetailInput>
    
    @State private var showModal = false
    @State private var showAlert = false
    
    init(service: ProductService, productId: Int) {
        self.viewModel = AnyViewModel(ProductDetailViewModel(service: service, id: productId))
    }
    
    var body: some View {
        VStack {
            
            ProductDetailImage(image: imageStore.image(url: viewModel.state.productDetail.imageInfo?.url))
            Spacer()
                .frame(height: 30)
            
            Text(viewModel.state.productDetail.category)
                .font(.system(size: 20, weight: .semibold))
                .padding([.leading, .trailing], 20)
            
            
            Spacer()
                .frame(height: 20)
            
            
            Text(viewModel.state.productDetail.color)
                .lineLimit(4)
                .padding([.leading, .trailing], 20)
                .lineSpacing(6)
                .foregroundColor(.gray)
            
            Spacer()
                .frame(height: 20)

            Divider()
                .padding(.bottom, 30)
                .padding([.leading, .trailing], 20)
            
            
            
            if viewModel.state.productDetail.isAvailable {
                // Read button
                Button(action: { self.showModal = true }) {
                    ProductDetailButton(text: "Comprado", buttonColor: Color.green)
                }
                .sheet(isPresented: self.$showModal) {
                    
                }
                
            } else {
                    Menu(content: {
                        Picker(selection: $selectedSize, label: Text("Selecciona una talla")) {
                                ForEach(size, id: \.self) {
                                    Text($0)
                                        .foregroundColor(Color.black)
                                        .fontWeight(.semibold)
                                }
                            }
                            }, label: {
                                Text("Talla \(selectedSize)")
                                    .fontWeight(.semibold)
                                Image(systemName: "chevron.down")
                                    
                            })
                    
                    .frame(width: 200)
                    .padding()
                    .foregroundColor(.black)
                    .background(.white)
                    .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.black)
                            )
                    

                                
                Button(action: {
                    self.addToCart()
                    self.showAlert = true
                }) {
                    ProductDetailButton(text: "Comprar " + String(viewModel.state.productDetail.price) + "€",
                                        buttonColor: Color.black)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Producto añadido al carrito"), message: Text("Estás listo para proceder con la compra"), dismissButton: .default(Text("Done")))
                }
            }
        }
        
        // NavBar item - Checkout button
        .navigationBarItems(trailing:
                                Button(action: {
            self.showModal = true
        }) {
            CartButtonView(numberOfItems: self.viewModel.state.cartItems)
        }.sheet(isPresented: self.$showModal, onDismiss: { self.reload() }) {
            CartView(service: self.viewModel.state.service, showModal: self.$showModal)
        })
        .navigationBarTitle(Text(""), displayMode: .inline)
    }
}

// MARK: - Private extension
private extension ProductDetailView {
    func addToCart() {
        viewModel.trigger(.addProductToCart)
    }
    
    func reload() {
        viewModel.trigger(.reloadState)
    }
}

struct DiscoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        return ProductDetailView(service: MockProductService(), productId: 0)
    }
}
