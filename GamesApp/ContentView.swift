//
//  ContentView.swift
//  GamesApp
//
//  Created by Luis Donaldo Galloso Tapia on 21/05/23.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var loginShow : FirebaseViewModel
    
    var body: some View {
        return Group{
            if loginShow.show{
                Home()
                    .edgesIgnoringSafeArea(.all)
            }else {
                Login()
            }
        }.onAppear{
            if (UserDefaults.standard.object(forKey: "sesion") != nil){
                loginShow.show = true
            }
        }
    }
}

