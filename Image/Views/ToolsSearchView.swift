//
//  ToolsSearch.swift
//  Image
//
//  Created by Влад on 06.07.2022.
//

import SwiftUI

struct ToolsSearch: View {
    
    @EnvironmentObject var imageManager: ImageManager
    
    @Environment(\.presentationMode) var presentationMode
    
    struct NamedSize: Identifiable {
        let name: String
        var id: String { name }
    }
    
    var sizeVariants: [NamedSize] = [
        NamedSize(name: "Большой"),
        NamedSize(name: "Cредний"),
        NamedSize(name: "Иконка")
    ]
    
    enum Size {
        case L
        case M
        case I
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Размеры")
                    .bold()
                HStack{
                    Button{
                        selectSize(.L)
                    } label: {
                        Text(sizeVariants[0].name)
                            .foregroundColor(Color("TextColor"))
                    }
                    .padding(10)
                    .background(imageManager.isSelectedLarge ? .blue: Color("ButtonColor"))
                    .cornerRadius(50)
                    Button{
                        selectSize(.M)
                    } label: {
                        Text(sizeVariants[1].name)
                            .foregroundColor(Color("TextColor"))
                    }
                    .padding(10)
                    .background(imageManager.isSelectedMedium ? .blue: Color("ButtonColor"))
                    .cornerRadius(50)
                    Button{
                        selectSize(.I)
                    } label: {
                        Text(sizeVariants[2].name)
                            .foregroundColor(Color("TextColor"))
                    }
                    .padding(10)
                    .background(imageManager.isSelectedIcon ? .blue : Color("ButtonColor"))
                    .cornerRadius(50)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            Form {
                Section("Страна") {
                    Picker("Страна", selection: $imageManager.location){
                        ForEach(ImageManager.Location.allCases) { variant in
                            Text(variant.rawValue.capitalized)
                                .tag(variant)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                Section("Язык") {
                    Picker("Язык", selection: $imageManager.languages){
                        ForEach(ImageManager.Languages.allCases) { variant in
                            Text(variant.rawValue.capitalized)
                                .tag(variant)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Сохранить")
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(.blue)
            .cornerRadius(50)
            .padding()
            .foregroundColor(Color("TextColor"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
   private func selectSize(_ size: Size) {
        
        switch size {
        case .L:
            imageManager.isSelectedLarge.toggle()
            imageManager.isSelectedMedium = false
            imageManager.isSelectedIcon = false
        case .M:
            imageManager.isSelectedLarge = false
            imageManager.isSelectedMedium.toggle()
            imageManager.isSelectedIcon = false
        case .I:
            imageManager.isSelectedLarge = false
            imageManager.isSelectedMedium = false
            imageManager.isSelectedIcon.toggle()
        }
    }
    
}

struct ToolsSearch_Previews: PreviewProvider {
    
    
    
    static var previews: some View {
        ToolsSearch()
            .environmentObject(ImageManager())
    }
}
