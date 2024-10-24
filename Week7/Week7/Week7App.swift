//
//  Week7App.swift
//  Week7
//
//  Created by Jindi Chai on 10/24/24.
//

import SwiftUI

@main
struct Week7App: App {
    @StateObject var document = Document()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(document)
        }
    }
}
