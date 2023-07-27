//
//  CardView.swift
//  GamesApp
//
//  Created by Luis Donaldo Galloso Tapia on 21/05/23.
//

import SwiftUI

struct CardView: View {
    
    var titulo: String
    var portada : String
    
    var index : FirebaseModel
    var plataforma: String
    
    @StateObject var datos = FirebaseViewModel()
    
    var body: some View {
        VStack(spacing: 20){
            ImagenFireBase(imageUrl: portada)
            Text(titulo)
                .font(.title)
                .bold()
                .foregroundColor(.black)
            Button(action:{
                datos.delete(index: self.index , plataforma: self.plataforma)
            }){
                Text("Eliminar").foregroundColor(.red)
                    .padding(.vertical,10)
                    .padding(.horizontal,25)
                    .background(Capsule().stroke(Color.red))
            }
        }.padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 40)
    }
}

