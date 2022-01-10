//
//  AppDelegate.swift
//  Approach
//
//  Created by Javier Mazario on 16/9/21.
//

import UIKit
import GoogleSignIn
import Braintree
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let googleDelegate = GoogleDelegate()
    private let returnURLSchemeBraintree = "Your BundleIdentifier.payments"
    private let returnURLSchemeGoogle = "Your OAuthID"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GIDSignIn.sharedInstance().clientID = "OAuthID"
        GIDSignIn.sharedInstance().delegate = googleDelegate
        BTAppContextSwitcher.setReturnURLScheme(returnURLSchemeBraintree)
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        guard url.scheme?.lowercased() == returnURLSchemeBraintree.lowercased() else { return true }
        if(url.scheme!.isEqual(returnURLSchemeGoogle)) {
            return GIDSignIn.sharedInstance().handle(url)
        } else {
            return BTAppContextSwitcher.handleOpenURL(url)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}



