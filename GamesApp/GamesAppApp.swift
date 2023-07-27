//
//  GamesAppApp.swift
//  GamesApp
//
//  Created by Luis Donaldo Galloso Tapia on 21/05/23.
//

import SwiftUI

@main
struct GamesAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        let login = FirebaseViewModel()
        WindowGroup {
            ContentView().environmentObject(login)
        }
    }
}
