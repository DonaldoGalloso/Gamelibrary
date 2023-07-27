//
//  FirebaseViewModel.swift
//  GamesApp
//
//  Created by Luis Donaldo Galloso Tapia on 25/05/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseViewModel: ObservableObject {
    
    @Published var show = false
    @Published var datos = [FirebaseModel]()
    @Published var itemUpdate : FirebaseModel!
    @Published var showEditar = false
    @Published var errors = ""
    
    func sendData(item: FirebaseModel){
        itemUpdate = item
        showEditar.toggle()
    }
    
    func login(email:String, pass: String, completion: @escaping (_ done: Bool)-> Void ){
        Auth.auth().signIn(withEmail: email, password: pass){(user,error)in
            if user != nil {
                completion(true)
            }else{
                self.errors = "Error Al inciar sesión"
                if let error = error?.localizedDescription{
                    self.errors = error
                }else{
                    self.errors = "Error Al inciar sesión"
                }
            }
        }
    }
    
    func createUSer(email: String , pass : String, completion: @escaping (_ done: Bool)->Void){
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if user != nil {
                print("Entró y se registró")
                completion(true)
            }else{
                self.errors = "Error Al inciar sesión"
                if let error = error?.localizedDescription{
                    self.errors = error
                }else{
                    self.errors = "Error Al Registrarse"
                }
            }
        }
    }
    
    //base de Datos
    
    //GUARDAR
    func saveGame(titulo:String,desc: String, plataforma:String, portada:Data, completion: @escaping(_ done: Bool) -> Void){
        
        let storage = Storage.storage().reference()
        let nombrePortada = UUID()
        let directorio = storage.child("imagenes/\(nombrePortada)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        directorio.putData(portada,metadata: metadata){data,error in
            if error == nil {
                print("Guardo la imagen")
                // Guardar texto
                let db = Firestore.firestore()
                let id = UUID().uuidString
                guard let idUser = Auth.auth().currentUser?.uid else {return }
                guard let email = Auth.auth().currentUser?.email else {return }
                let campos: [String:Any] = ["titulo":titulo,"desc":desc,"portada":String(describing: directorio),"idUSer":idUser,"email":email]
                db.collection(plataforma).document(id).setData(campos){error in
                    if let error = error?.localizedDescription{
                        print("Error al guardar en firestore")
                    }else{
                        print("guardó todo")
                        completion(true)
                    }
                }
                // Terminno de guardar texto
            }else{
                if let error = error?.localizedDescription{
                    print("Fallo al subit la imagen en e storage",error)
                }else{
                    print("fallo la app")
                }
            }
            
        }
    }
    
    //Mostrar los datos
    func getData(plataforma: String){
        let db = Firestore.firestore() // referenci a la bd
        db.collection(plataforma).addSnapshotListener { QuerySnapshot, error in
            if (error?.localizedDescription) != nil{
                print("Error al mostrar datos")
                
            }else{
                self.datos.removeAll()
                for document in QuerySnapshot!.documents{
                    let valor = document.data() // aqui estan los valores
                    let id = document.documentID
                    let titulo = valor["titulo"] as? String ?? "Sin titulo"
                    let descripcion = valor["desc"] as? String ?? "Sin descripcion"
                    let portada = valor["portada"] as? String ?? "Sin Portada"
                    DispatchQueue.main.async {
                        let registros = FirebaseModel(id: id, titulo: titulo, desc: descripcion, portada: portada)
                        self.datos.append(registros)
                    }
                }
            }
        }
    }
    
    //eliminar
    func delete(index: FirebaseModel,plataforma: String){
        //eliminar firestore
        let id = index.id
        let db = Firestore.firestore() // referencia
        db.collection(plataforma).document(id).delete()
        // eliminar del storage
        let imagen = index.portada
        let borrarImagen = Storage.storage().reference(forURL: imagen)
        borrarImagen.delete(completion: nil)
    }
    
    //editar solo el texto
    func edit(titulo: String, desc: String, plataforma: String, id:String, completion: @escaping(_ done:Bool)-> Void){
        let db = Firestore.firestore()
        let campos : [String:Any] = ["titulo":titulo,"desc":desc]
        db.collection(plataforma).document(id).updateData(campos){error in
            if let error = error?.localizedDescription{
                print("error al editar ",error)
            }else{
                print("Edito solo el texto")
                completion(true)
            }
        }
    }
    //editar imagens si es necesario
    func editWithImage(titulo: String, desc: String, plataforma: String, id:String,index:FirebaseModel,portada:Data, completion: @escaping(_ done:Bool)-> Void){
        //eliminar imagen
        let imagen = index.portada
        let borrarImagen = Storage.storage().reference(forURL: imagen)
        borrarImagen.delete(completion: nil)
        
        //subir la nueva imagen
        let storage = Storage.storage().reference()
        let nombrePortada = UUID()
        let directorio = storage.child("imagenes/\(nombrePortada)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        directorio.putData(portada,metadata: metadata){data,error in
            if error == nil {
                print("Guardo la imagenNueva")
                // Editando texto
                let db = Firestore.firestore()
                let campos : [String:Any] = ["titulo":titulo,"desc":desc,"portada": String(describing: directorio)]
                db.collection(plataforma).document(id).updateData(campos){error in
                    if let error = error?.localizedDescription{
                        print("error al editar ",error)
                    }else{
                        print("Edito solo el texto")
                        completion(true)
                    }
                }
                
                // Terminno de guardar texto
            }else{
                if let error = error?.localizedDescription{
                    print("Fallo al subit la imagen en e storage",error)
                }else{
                    print("fallo la app")
                }
            }
            
            
        }
    }
}
