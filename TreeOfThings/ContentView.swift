//
//  ContentView.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 2019-11-11.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import SwiftUI

struct Loader: View {
    var body: some View {
        Text("Loading ...")
    }
}

struct ContentView: View {
    let documentService: DocumentService;
    
    @State var doc: DocumentState = .empty

    var body: some View {
        documentOrLoader
    }
    
    private var documentOrLoader: AnyView {
        switch (doc) {
        case .ok(let org):
            return AnyView(DocumentView(org))
        case .fail(_):
            return AnyView(Text("Failed to load example."))
        default:
            return AnyView(Loader().onAppear(perform: self.parseDocument))
        }
    }

    private func parseDocument() {
        doc = documentService.parse(resource: "Example")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(documentService: DocumentService())
    }
}
