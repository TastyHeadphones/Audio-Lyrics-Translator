//
//  DetailView.swift
//  Audio Lyrics Translator
//
//  Created by Young Geo on 4/15/25.
//

import SwiftUI

struct DetailView: View {
    let musicUrl: URL
    
    var body: some View {
        VStack {
            LyricsView(musicUrl: musicUrl)
            Spacer()
            PlayerView(musicUrl: musicUrl)
        }
        
    }
}
