//
//  GoogleDelegate.swift
//  Approach
//
//  Created by Javier Mazario on 22/9/21.
//

import Foundation
import GoogleSignIn

class GoogleDelegate: NSObject,GIDSignInDelegate, ObservableObject {
    @Published var signedIn: Bool = false
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("El usuario no ha inicado sesión previamente o se cerró la sesión.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Si no se producen errores, la autenticación se ha realizado correctamente.
        print("Inicio de sesión exitoso")
        signedIn = true
    }
}
