//
//  AddView.swift
//  GamesApp
//
//  Created by Luis Donaldo Galloso Tapia on 31/05/23.
//

import SwiftUI

struct AddView: View {
    @State private var titulo = ""
    @State private var desc = ""
    var consolas = ["playstation","xbox","nintendo"]
    @State private var plataforma = "playstation"
    @StateObject var guardar = FirebaseViewModel()
    
    @State private var imageData: Data = .init(capacity: 0 ) //almacenar imagen
    @State private var mostrarMenu = false
    @State private var imagePicker = false
    @State private var source : UIImagePickerController.SourceType = .camera
    @State private var progress = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                NavigationLink(destination: ImagePicker(show: $imagePicker, image: $imageData, source: source),isActive: $imagePicker){
                    EmptyView()
                }.toolbar(.hidden)
                Color("login").edgesIgnoringSafeArea(.all)
                VStack (spacing:20){
                    TextField("Titulo", text: $titulo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextEditor(text: $desc)
                        .frame(height: 200)
                    Picker("Consolas",selection: $plataforma){
                        ForEach(consolas, id: \.self){ item in
                            Text(item)
                                .foregroundColor(.black)
                        }
                    }.foregroundColor(.white)
                        .pickerStyle(.segmented)
                    
                    Button {
                        mostrarMenu.toggle()
                    } label: {
                        Text("Agregar Imagen")
                            .padding()
                            .bold()
                            .foregroundColor(.black)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }.confirmationDialog( "¿Seguro de abrir la camara?", isPresented: $mostrarMenu) {
                        Button("Camara"){
                            source = .camera
                            imagePicker.toggle()
                        }
                        Button("Libreria"){
                            source = .photoLibrary
                            imagePicker.toggle()
                        }
                        Button("Cancelar",role: .cancel){
                            
                        }
                    }
                    
                    if imageData.count != 0{
                        Image(uiImage: UIImage(data: imageData)!)
                            .resizable()
                            .frame(width: 250,height: 250)
                            .cornerRadius(15)
                        
                        Button(action:{
                            progress = true
                            guardar.saveGame(titulo: titulo, desc: desc, plataforma: plataforma, portada: imageData){ (done) in
                                if done {
                                    titulo = ""
                                    desc = ""
                                    imageData = .init(Data(capacity: 0))
                                    progress = false
                                }
                            }
                        }){
                            Text("Agregar Juego")//vista
                                .padding()
                                .bold()
                                .foregroundColor(.black)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                        
                        if(progress){
                            Text("Espere un momento por favor").foregroundColor(.black)
                            ProgressView()
                        }
                        
                    }

                    Spacer()
                }.padding(.all)
            }

        }
    }
}

