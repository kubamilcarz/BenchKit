//
//  ContentView.swift
//  BenchKit
//
//  Created by Kuba on 10/9/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding(30)
        .background(.accent, in: Capsule())
        .padding(30)
    }
}

#Preview {
    ContentView()
}
