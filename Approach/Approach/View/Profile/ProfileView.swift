//
//  ProfileView.swift
//  Approach
//
//  Created by Javier Mazario on 23/9/21.
//

import SwiftUI
import GoogleSignIn

struct ProfileView: View {
    @EnvironmentObject var googleDelegate: GoogleDelegate
    @EnvironmentObject var imageStore: ImageStore
    
    var body: some View {
        Group {
            if googleDelegate.signedIn {
                VStack{
                    ProfileImage(image: imageStore.image(url: GIDSignIn.sharedInstance().currentUser?.profile?.imageURL(withDimension: 80)))
                    Spacer()
                        .frame(height: 50)
                    Text(GIDSignIn.sharedInstance().currentUser!.profile.name)
                    Spacer()
                        .frame(height: 20)
                    Text(GIDSignIn.sharedInstance().currentUser!.profile.email)
                    Spacer()
                    Button(action: {
                        GIDSignIn.sharedInstance().signOut()
                        googleDelegate.signedIn = false
                    }, label: {
                        Text("Cerrar Sesión")
                            
                    })
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .shadow(color: .white, radius: 5)
                    
                }
                Spacer()
            } else {}
            
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
