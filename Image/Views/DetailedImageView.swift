//
//  DetailedImageView.swift
//  Image
//
//  Created by Влад on 05.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailedImageView: View {
    
    @State var currentImage : ImagesResult
    @State var imageArray: ImageModel?
    @State private var openOriginalPage = false
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: currentImage.thumbnail))
                .resizable()
                .scaledToFit()
            Text(currentImage.title)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            HStack() {
                Button {
                    withAnimation{
                        currentImage = LastImage(currentImage, imageArray: imageArray!)
                    }
                } label: {
                    Image(systemName: "arrow.left.square.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                Spacer()
                Button {
                    withAnimation{
                        currentImage = NextImage(currentImage, imageArray: imageArray!)
                    }
                } label: {
                    Image(systemName: "arrow.right.square.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            .padding()
        }
        .toolbar{
            Menu {
                Button {
                    openOriginalPage.toggle()
                } label: {
                    Label("Открыть оригинал", systemImage: "globe" )
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    
                }
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 15)
            }
        }
        .sheet(isPresented: $openOriginalPage) {
            ImageWebView(url: currentImage.original!)
        }
    }
    
    private func NextImage(_ currentImage: ImagesResult, imageArray: ImageModel) -> ImagesResult {
        for (index, value) in imageArray.imagesResults.enumerated(){
            if currentImage.thumbnail == value.thumbnail && index + 1 != imageArray.imagesResults.count {
                return imageArray.imagesResults[index + 1]
            }
        }
        return currentImage
    }
    
    private func LastImage(_ currentImage: ImagesResult, imageArray: ImageModel) -> ImagesResult {
        for (index, value) in imageArray.imagesResults.enumerated(){
            if currentImage.thumbnail == value.thumbnail && index != 0 {
                return imageArray.imagesResults[index - 1]
            }
        }
        return currentImage
    }
}

struct DetailedImageView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedImageView(currentImage: ImagesResult(position: 1, thumbnail: "https://serpapi.com/searches/62c655aeb7b1ccd5d5377a8c/images/7f7752e5a4b69e29640c304e36fa46367af516da5fe6b93915ea5d093b600f5f.jpeg", source: "Google Play", title: "Приложения в Google Play – Car Parking MultiplayerGoogle Play", link: "https://play.google.com/store/apps/details?id=com.olzhas.carparking.multyplayer&hl=ru&gl=US", original: "https://play-lh.googleusercontent.com/Ip_LzDVSk0AuWeJqJJC6qmcH9jl31FIdfsvl3AcG-lxJNu0R0nqyhTZF1-9izOvEdQ=w526-h296-rw", isProduct: false))
    }
}
