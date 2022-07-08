//
//  ImageApp.swift
//  Image
//
//  Created by Влад on 05.07.2022.
//

import SwiftUI

@main
struct ImageApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ImageManager())
        }
    }
}
