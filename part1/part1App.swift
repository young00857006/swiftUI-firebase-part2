//
//  part1App.swift
//  part1
//
//  Created by 賴冠宏 on 2022/5/30.
//

import SwiftUI
import Firebase

@main
struct part1App: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
