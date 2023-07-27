//
//  ListView.swift
//  GamesApp
//
//  Created by Luis Donaldo Galloso Tapia on 23/06/23.
//

import SwiftUI

struct ListView: View {
    
    var device = UIDevice.current.userInterfaceIdiom
    @Environment(\.horizontalSizeClass) var  width
    
    func getColumns() -> Int {
        return (device == .pad) ? 3 : (width == .regular  ? 3 : 1 )
    }
    var plataforma : String
    @StateObject var datos = FirebaseViewModel()
    //@State private var showEditar = false
    
    
    var body: some View {
        
        ScrollView(.vertical,showsIndicators: false){
            Text(plataforma)
                .foregroundColor(.white)
                .bold()
                .font(.title2)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.all)
                .textCase(.uppercase)
            
            
            LazyVGrid (columns: [GridItem(.adaptive(minimum: 250))],spacing: 20 ){
                ForEach(datos.datos){item in
                    if item.portada == "ruta"{
                        CardView(titulo: item.titulo, portada: "gs://gamescrud.appspot.com/imagenes/EDAC4D14-2B01-4178-86A4-098622676C86",index: item,plataforma: plataforma)
                    }else{
                        CardView(titulo: item.titulo, portada: item.portada,index: item,plataforma: plataforma)
                            .onTapGesture {
                                datos.sendData(item: item)
                            }.sheet(isPresented: $datos.showEditar, content: {
                                EditarView(plataforma: plataforma, datos: datos.itemUpdate)
                            })
                            .padding(.all)
                    }
                    
                       
                }
            }
        }.onAppear{
            
            datos.getData(plataforma: plataforma)
        }
    }
}
