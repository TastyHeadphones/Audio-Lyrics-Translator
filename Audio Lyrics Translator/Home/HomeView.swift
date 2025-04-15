//
//  HomeView.swift
//  Audio Lyrics Translator
//
//  Created by Young Geo on 4/15/25.
//

import UniformTypeIdentifiers
import SwiftUI

extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}

struct HomeView: View {
    @State private var selectedFileURL: URL?
    @State private var isFilePickerPresented = false
    
    // select a file and push to detail
    var body: some View {
        Button("Upload MP3 File") {
            isFilePickerPresented = true
        }
        .fileImporter(
            isPresented: $isFilePickerPresented,
            allowedContentTypes: [UTType.audio],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    selectedFileURL = url
                }
            case .failure(let error):
                print("Error selecting file: \(error.localizedDescription)")
            }
        }
        .sheet(item: $selectedFileURL) { fileURL in
            VStack(alignment: .leading) {
                Button(action: {
                    self.selectedFileURL = nil
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 10, height: 10)
                }
                DetailView(musicUrl: fileURL)
            }
        }
    }
}
