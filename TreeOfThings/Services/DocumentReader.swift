//
//  DocumentReader.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 2019-11-11.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import Foundation
import SwiftOrg

struct Heading: Equatable, Hashable, Identifiable {
    let id: Int
    let level: Int
    let title: String
}

class DocumentReader: Identifiable {
    let nr: Int = Int.random(in: 1..<10000000)
    let doc: Document

    var id: String {
        get {
            return doc.title ?? "Untitled \(nr)"
        }
    }
    
    init(_ doc: Document) {
        self.doc = doc
    }
    
    func title() -> String {
        return self.id
    }
    
    func tableOfContents() -> [Heading] {
        var count = 0
        var headings: [Heading] = []
        var queue: [Node] = doc.content
        while !queue.isEmpty {
            let top = queue.removeFirst()
            if top is Section {
                let section = top as! Section
                queue.insert(contentsOf: section.content, at: 0)
                if let title = section.title {
                    headings.append(Heading(id: count, level: section.stars - 1, title: title))
                    count += 1
                }
            }
        }
        return headings
    }
}
