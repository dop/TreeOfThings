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
                ForEach(documents, id: \.self.id) { document in
                    NavigationLink(destination: DocumentView(document: document)) {
                        VStack(alignment: .leading) {
                            Text(document.title)
                            if document.date != nil {
                                Text(document.date ?? "")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: onFilesDelete)
            }
            .navigationBarTitle("Org Files")
            .navigationBarItems(trailing: EditButton())
        }
    }
}
