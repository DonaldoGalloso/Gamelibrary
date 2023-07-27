//
//  EditarView.swift
//  GamesApp
//
//  Created by Luis Donaldo Galloso Tapia on 28/06/23.
//

import SwiftUI

struct EditarView: View {
    @State private var titulo = ""
    @State private var desc = ""
    var plataforma : String
    var datos : FirebaseModel
    @StateObject var guardar = FirebaseViewModel()
    
    @State private var imageData: Data = .init(capacity: 0 ) //almacenar imagen
    @State private var mostrarMenu = false
    @State private var imagePicker = false
    @State private var source : UIImagePickerController.SourceType = .camera
    @State private var progress = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                NavigationLink(destination: ImagePicker(show: $imagePicker, image: $imageData, source: source),isActive: $imagePicker){
                    EmptyView()
                }.toolbar(.hidden)
                
                Color("login").edgesIgnoringSafeArea(.all)
                VStack(spacing: 40){
                    VStack(alignment: .leading){
                        Text("Titulo:")
                            .foregroundColor(.white)
                            .bold()
                        TextField("Titulo", text: $titulo)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onAppear{
                                titulo = datos.titulo
                            }
                    }
                    VStack(alignment:.leading){
                        Text("Descripción:")
                            .foregroundColor(.white)
                            .bold()
                        TextEditor(text: $desc)
                            .onAppear{
                                desc = datos.desc
                            }
                            .frame(height: 200)
                    }
                    
                    Button {
                        mostrarMenu.toggle()
                    } label: {
                        Image(systemName: "camera.viewfinder")
                            .foregroundColor(.white)
                        Text("Agregar Imagen")
                            .foregroundColor(.white)
                            .bold()
                            .font(.title3)
                        
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
                    }
                    
                    Button(action:{
                        if imageData.isEmpty{
                            guardar.edit(titulo: titulo, desc: desc, plataforma: plataforma, id: datos.id) { done in
                                if done {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }else{
                            progress = true
                            guardar.editWithImage(titulo: titulo, desc: desc, plataforma: plataforma, id: datos.id, index: datos, portada: imageData) { done in
                                if done {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }){
                        Text("Editar Juego")//vista
                            .padding()
                            .bold()
                            .foregroundColor(.black)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }.padding(.top,50)
                    
                    if(progress){
                        Text("Espere un momento por favor").foregroundColor(.black)
                        ProgressView()
                    }

                    Spacer()
                }.padding(.all)
            }.onAppear{
                print(datos)
            }

        }
    }
}


