//
//  Document.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 2019-11-11.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import Foundation
import SwiftOrg

enum DocumentError: Error {
    case notfound(String)
}

extension Array where Array.Element == Node {
    func toHeadingTree() -> [Tree<Heading>] {
        return self
            .filter({ $0 is Section })
            .map({ ($0 as! Section).toHeadingTree() })
    }
}

extension Section {
    func toHeadingTree() -> Tree<Heading> {
        return Tree(Heading(self.title ?? "Untitled Section", level: self.stars), children: self.content.toHeadingTree())
    }
}

extension OrgDocument {
    func toDocument() -> Document {
        return Document(self.title ?? "Untitled", toc: self.content.toHeadingTree())
    }
}

class DocumentService {
    let parser = OrgParser()
    
    func parse(resource: String) -> Resource<OrgDocument> {
        guard let path = Bundle.main.path(forResource: resource, ofType: "org") else {
            return .failed(DocumentError.notfound(resource))
        }
        return self.parse(path: path)
    }
    
    func parse(path: String) -> Resource<OrgDocument> {
        do {
            return self.parse(content: try String(contentsOfFile: path, encoding: .utf8));
        } catch {
            return .failed(error)
        }
    }
    
    func parse(content: String) -> Resource<OrgDocument> {
        do {
            return .loaded(try parser.parse(content: content));
        } catch {
            return .failed(error)
        }
    }
}
