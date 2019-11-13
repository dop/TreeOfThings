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

extension String {
    func isCheckboxTitle() -> Bool {
        return self.isCheckboxOn() || self.isCheckboxOff()
    }

    func getCheckboxTitle() -> String {
        return self.isCheckboxTitle() ? String(self.dropFirst(4)) : self
    }

    func isCheckboxOn() -> Bool {
        return self.starts(with: "[X] ")
    }

    func isCheckboxOff() -> Bool {
        return self.starts(with: "[ ] ")
    }
}

extension Array where Array.Element == Node {
    func toContent() -> [Content] {
        return self.compactMap({
            $0 is Paragraph ? ($0 as! Paragraph).toContent() : nil
        })
    }

    func toHeadingTree() -> [Tree<Heading>] {
        return self.compactMap({
            $0 is Section ? ($0 as! Section).toHeadingTree() : nil
        })
    }
}

extension Section {
    func toHeadingTree() -> Optional<Tree<Heading>> {
        let title = self.title ?? "Untitled Section"
        var type = HeadingType.simple
        if (self.keyword == "TODO") {
            type = HeadingType.todo(.todo)
        } else if (self.keyword == "DONE") {
            type = HeadingType.todo(.done)
        } else if (title.isCheckboxTitle()) {
            type = HeadingType.checkbox(title.isCheckboxOn())
        }
        return Tree(
            Heading(
                title.getCheckboxTitle(),
                level: self.stars,
                type: type,
                content: self.content.toContent()
            ),
            children: self.content.toHeadingTree()
        )
    }
}

extension Paragraph {
    func toContent() -> Optional<Content> {
        return Content(self.text)
    }
}

extension OrgDocument {
    func toDocument() -> Document {
        return Document(
            self.title ?? "Untitled",
            toc: self.content.toHeadingTree()
        )
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
            return .ok(try parser.parse(content: content));
        } catch {
            return .failed(error)
        }
    }
}
