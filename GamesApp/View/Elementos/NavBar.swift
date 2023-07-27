//
//  NavBar.swift
//  GamesApp
//
//  Created by Luis Donaldo Galloso Tapia on 21/05/23.
//

import SwiftUI
import FirebaseAuth

struct NavBar: View {
    
    var device = UIDevice.current.userInterfaceIdiom
    @Binding var index : String
    @Binding var menu : Bool
    @EnvironmentObject var loginShow : FirebaseViewModel
    
    
    var body: some View {
    
        HStack{
            Text("Mis Juegos")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .font(.system(size: device == .phone ? 25 : 35 ))
            Spacer()
            if device == .pad {
                // menu para ipad
                HStack(spacing: 35){
                    ButtonView(index: $index, menu: $menu, title: "PlayStation")
                    ButtonView(index: $index, menu: $menu, title: "Xbox")
                    ButtonView(index: $index, menu: $menu, title: "Nintendo")
                    ButtonView(index: $index, menu: $menu, title: "Agregar")
                    Spacer()
                    Button(action:{
                        try! Auth.auth().signOut()
                        UserDefaults.standard.removeObject(forKey: "sesion")
                        loginShow.show = false
                    }){
                        Text("Salir")
                            .font(.title3)
                            .frame(width: 200)
                            .foregroundColor(.white)
                            .padding(.horizontal,10)
                    }.background{
                        Capsule().stroke(Color.white)
                    }
                    
                }
            }else {
                //menu para iphone
                Button(action:{
                    index = "Agregar"
                    
                }){
                   Image(systemName: "plus")
                        .font(.system(size:26))
                        .foregroundColor(.white)
                }
                
                Button(action:{
                    withAnimation{
                        menu.toggle()
                    }
                }){
                   Image(systemName: "line.horizontal.3")
                        .font(.system(size:26))
                        .foregroundColor(.white)
                }
            }
            
        }
        .padding(.top,25)
        .padding()
        .background(Color("login"))
    }
}

