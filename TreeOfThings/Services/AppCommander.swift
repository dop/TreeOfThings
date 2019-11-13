//
//  AppCommander.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 11/12/19.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import Foundation

extension Array {
    func drop(at index: Int) -> [Array.Element] {
        var tmp = self
        tmp.remove(at: index)
        return tmp
    }
    
    func drop(at offsets: IndexSet) -> [Array.Element] {
        var tmp = self
        var offset = 0
        for index in offsets {
            tmp.remove(at: index - offset)
            offset += 1
        }
        return tmp
    }
}

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
        state.documents = state.documents.mapLoaded({ $0.drop(at: offsets) })
    }
}
