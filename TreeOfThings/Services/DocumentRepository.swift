//
//  DocumentsRepository.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 11/12/19.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import Foundation

class DocumentRepository {
    let documentService: DocumentService;

    init(_ documentService: DocumentService) {
        self.documentService = documentService;
    }
    
    func getExamples() -> [Document] {
        var documents: [Document] = []
        
        for path in Bundle.main.paths(forResourcesOfType: "org", inDirectory: nil) {
            switch (documentService.parse(path: path)) {
            case .ok(let doc):
                documents.append(doc)
            default:
                break
            }
        }
        
        return documents
    }
}
