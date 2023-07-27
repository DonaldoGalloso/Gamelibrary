//
//  Home.swift
//  GamesApp
//
//  Created by Luis Donaldo Galloso Tapia on 21/05/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct Home: View {
    @State private var index = "PlayStation"
    @State private var backgroundColorHome = Color("PlayStation")
    @State private var menu = false
    @State private var widtmenu = UIScreen.main.bounds.width
    @EnvironmentObject var loginShow : FirebaseViewModel
    

    var body: some View {
        ZStack{
            VStack{
                NavBar(index: $index, menu: $menu)
                ZStack{
                    if index == "PlayStation" {
                        ListView(plataforma: "playstation")
                    }else if index == "Xbox"{
                        ListView(plataforma: "xbox")
                    }else if index == "Nintendo"{
                        ListView(plataforma: "nintendo")
                    }else{
                        AddView()
                    }
                }
            }
            //termina parte de navbar ipad
            if menu {
                HStack{
                    Spacer()
                    VStack{
                        HStack{
                            Spacer()
                            Button(action:{
                                withAnimation {
                                    menu.toggle()
                                }
                            }){
                                Image(systemName: "xmark")
                                    .font(.system(size: 22,weight: .bold))
                                    .foregroundColor(.white)
                                
                            }
                        }.padding()
                        .padding(.top,40)
                        VStack(alignment: .center, spacing: 20){
                            ButtonView(index: $index, menu: $menu, title: "PlayStation")
                            ButtonView(index: $index, menu: $menu, title: "Xbox")
                            ButtonView(index: $index, menu: $menu, title: "Nintendo")
                            Button(action:{
                                try! Auth.auth().signOut()
                                UserDefaults.standard.removeObject(forKey: "sesion")
                                loginShow.show = false
                            }){
                                Text("Salir")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                        Spacer()
                    }.frame(width: widtmenu - 180)
                    .background(Color("login"))
                }
            }
        }.background(Color(index))
        
    }
}

