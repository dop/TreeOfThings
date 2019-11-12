//
//  AppCommander.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 11/12/19.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import Foundation

class AppCommander {
    let state: AppState
    let repository: DocumentRepository

    init(_ state: AppState, repository: DocumentRepository) {
        self.state = state
        self.repository = repository
    }

    func loadDocuments() {
        DispatchQueue.main.async(execute: {
            self.state.documents = Resource.loaded(self.repository.getExamples())
        })
    }

    func removeFiles(at offsets: IndexSet) {
        switch (state.documents) {
            case .loaded(var documents):
                documents.remove(atOffsets: offsets)
                state.documents = Resource.loaded(documents)
            default:
                break
        }
    }
}
