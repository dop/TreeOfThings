//
//  ContentView.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 2019-11-11.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import SwiftUI

struct AppView: View {
    let commander: AppCommander
    @Environment(\.editMode) var mode
    @EnvironmentObject private var appState: AppState

    var body: some View {
        switch appState.documents {
        case .uninitialized:
            return AnyView(Button(action: commander.loadDocuments) {
                Text("Load Org Files")
            })
        case .loading:
            return AnyView(Text("Loading ..."))
        case .loaded(let documents):
            return AnyView(DocumentListView(documents: documents, onFilesDelete: commander.removeFiles))
        case .failed(_):
            return AnyView(Text("Failed to load Org files."))
        }
    }
}
