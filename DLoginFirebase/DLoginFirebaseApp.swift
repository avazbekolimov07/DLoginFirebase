//
//  DLoginFirebaseApp.swift
//  DLoginFirebase
//
//  Created by 1 on 24/09/21.
//

import SwiftUI
import Firebase

@main
struct DLoginFirebaseApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
