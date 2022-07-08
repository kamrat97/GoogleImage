//
//  ContentView.swift
//  Image
//
//  Created by Влад on 05.07.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    
    @EnvironmentObject var imageManager: ImageManager
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State var searchText:String = ""
    
    @State private var showImage = false
    @State private var showToolsSearch = false
    
    @State private var opacityValue = 1.0
    
    var body: some View {
        NavigationView {
            VStack {
                if !imageManager.search {
                    if let imageArray = imageManager.imageArray{
                        ScrollView {
                            LazyVGrid(columns: columns) {
                                ForEach(imageArray.imagesResults, id: \.link) { value in
                                    NavigationLink {
                                        DetailedImageView(currentImage: value, imageArray: imageArray)
                                    } label: {
                                        WebImage(url: URL(string:value.thumbnail))
                                            .placeholder{
                                                Rectangle()
                                                    .foregroundColor(.gray)
                                                    .opacity(opacityValue)
                                                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true))
                                                    .onAppear {
                                                        self.opacityValue = 0.3
                                                    }
                                            }
                                            .resizable()
                                            .scaledToFit()
                                            .padding()
                                            
                                    }
                                }
                            }
                        }
                        .background(.ultraThinMaterial)
                    } else {
                        Text("Введите запрос 🙂")
                    }
                } else {
                    ProgressView().progressViewStyle(.circular)
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Поиск"))
            .onSubmit(of: .search) {
                Task {
                    do{
                        try await imageManager.startSearchImage(searchString: searchText)
                    } catch {
                        print(error)
                    }
                }
            }
            .toolbar{
                Button {
                    showToolsSearch.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
            .popover(isPresented: $showToolsSearch){
                ToolsSearch()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Поиск фото")
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(searchText: "Apple")
            .environmentObject(ImageManager())
    }
}
