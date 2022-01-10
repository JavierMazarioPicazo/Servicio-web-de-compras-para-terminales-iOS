//
//  ContentView.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//
import SwiftUI
import GoogleSignIn

struct ContentView: View {
    @EnvironmentObject var googleDelegate: GoogleDelegate
    
    @ObservedObject
    var viewModel: AnyViewModel<ProductListState, Never>
    
    @ObservedObject var mockProductService: MockProductService
    var body: some View {
        Group {
            if googleDelegate.signedIn {
                ProductListView(viewModel: viewModel, mockProductService: mockProductService)
            } else {
                ZStack{
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        Spacer()
                        Image("logo-2")
                            .resizable()
                            .frame(width: 200, height: 70)
                            
                            .padding()
                        Spacer()
                        Button(action: {
                            GIDSignIn.sharedInstance().signIn()
                        }, label: {
                            Image("logoGoogle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            
                            Text("Sign In With Google")
                                
                                
                        })
                            
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(10)
                            .shadow(color: .white, radius: 5)
                        Spacer()
                    }
                    
                    
                }
                
                
            }
        }
    }
        
}


