//
//  ContentView.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 2019-11-11.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import SwiftUI

struct DocumentListView: View {
    @Environment(\.editMode) var mode
    let documents: [Document]
    let onFilesDelete: (IndexSet) -> Void

    var body: some View {
        NavigationView {
            List {
                ForEach(documents.map {doc in DocumentReader(doc) }) { reader in
                    NavigationLink(destination: DocumentOverview(reader)) {
                        Text(reader.title())
                    }
                }
                .onDelete(perform: onFilesDelete)
            }
            .navigationBarTitle("Org Files")
            .navigationBarItems(trailing: EditButton())
        }
    }
}
