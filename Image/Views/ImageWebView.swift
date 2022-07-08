//
//  ImageWebView.swift
//  Image
//
//  Created by Влад on 08.07.2022.
//

import SwiftUI

struct ImageWebView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var url: String
    
    var body: some View {
        VStack {
            Button{
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Закрыть")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
            }
            WebView(url: url)
        }
        .ignoresSafeArea()
    }
}

struct ImageWebView_Previews: PreviewProvider {
    static var previews: some View {
        ImageWebView(url: "https://play-lh.googleusercontent.com/Ip_LzDVSk0AuWeJqJJC6qmcH9jl31FIdfsvl3AcG-lxJNu0R0nqyhTZF1-9izOvEdQ=w526-h296-rw")
    }
}
