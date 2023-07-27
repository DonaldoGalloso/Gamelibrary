//
//  ImagenFireBase.swift
//  GamesApp
//
//  Created by Luis Donaldo Galloso Tapia on 23/06/23.
//

import SwiftUI

struct ImagenFireBase: View {
    
    let imagesAlternativa = UIImage(systemName: "photo")
    @ObservedObject var imageLoader : PortadaViewModel
    
    init(imageUrl: String){
        imageLoader = PortadaViewModel(imageUrl: imageUrl)
    }
    
    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }
    
    
    var body: some View {
        Image(uiImage: image ?? imagesAlternativa!)
            .resizable()
            .cornerRadius(20)
            .shadow(radius: 5)
            .aspectRatio(contentMode: .fit)
    }
}

