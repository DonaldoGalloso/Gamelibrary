//
//  SignUp .swift
//  GamesApp
//
//  Created by Luis Donaldo Galloso Tapia on 13/07/23.
//

import SwiftUI

struct SignUp_: View {
    @State private var email = ""
    @State private var pass = ""
    @StateObject var login = FirebaseViewModel() // funciones de login y crear usuario
    @EnvironmentObject var loginShow : FirebaseViewModel // intercambiar las vistas
    var device = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        NavigationView {
            ZStack{
                Color("login").edgesIgnoringSafeArea(.all)
                VStack{
                    Text( "Registrate" )
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                        .frame(maxWidth: .infinity, maxHeight:200, alignment:.topLeading)
                    
                    HStack{
                        Image(systemName: "person.fill").foregroundColor(.white)
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.none)
                            .frame(width: device == .pad ? 400 : nil )
                    }.padding(10)
                    HStack{
                        Image(systemName: "lock.fill").foregroundColor(.white)
                        SecureField("Pass", text: $pass)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: device == .pad ? 400 : nil )
                    }.padding(10)
                    if login.errors != "" {
                        HStack{
                            Image(systemName: "exclamationmark.triangle")
                            Text(login.errors)
                        }
                        .foregroundColor(Color("ColorError"))
                        .font(.caption)
                        .padding(.bottom,40)
                    }
                    
                    Button(action:{
                        login.createUSer(email: email, pass: pass) { done in
                            if done {
                                UserDefaults.standard.set(true, forKey: "sesion")
                                loginShow.show.toggle()
                            }
                        }
                    }){
                        Text("Crear Cuenta")
                            .font(.title3)
                            .frame(width: 150,height: 30)
                            .foregroundColor(.white)
                            .padding(.vertical,10)
                    }.background(
                        Capsule()
                            .stroke(Color.white)
                    )
                }.padding(.all)
                }
        }

    }
}
        

struct SignUp__Previews: PreviewProvider {
    static var previews: some View {
        SignUp_()
    }
}
