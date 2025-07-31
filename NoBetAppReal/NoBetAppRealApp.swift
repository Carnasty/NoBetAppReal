//
//  NoBetAppRealApp.swift
//  NoBetAppReal
//
//  Created by Carsen Werbes on 7/23/25.
//

import SwiftUI
import Firebase

@main
struct NoBetAppRealApp: App {
    // This hooks in your custom AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
