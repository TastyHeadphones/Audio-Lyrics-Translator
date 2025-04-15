//
//  ContentView.swift
//  Audio Lyrics Translator
//
//  Created by Young Geo on 4/15/25.
//

import Speech
import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
            .onAppear {
                SFSpeechRecognizer.requestAuthorization { _ in }
            }
    }
}

#Preview {
    ContentView()
}
