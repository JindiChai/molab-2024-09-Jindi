//
//  Week6App.swift
//  Week6
//
//  Created by Jindi Chai on 10/17/24.
//

import SwiftUI

@main
struct Week6App: App {
    
    @StateObject var document = Document()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(document)
        }
    }
}
