//
//  BestCatPhotosApp.swift
//  BestCatPhotos
//
//  Created by arta.zidele on 20/01/2022.
//

import SwiftUI
import Firebase

@main
struct BestCatPhotosApp: App {
    
//    init() {
//        FirebaseApp.configure()
//    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
