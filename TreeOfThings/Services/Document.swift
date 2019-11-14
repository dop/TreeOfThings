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

enum Content: Equatable, Hashable {
    case paragraph(Paragraph)
    case list(List)
}

extension Paragraph: Equatable, Hashable {
    public static func == (lhs: Paragraph, rhs: Paragraph) -> Bool {
        return lhs.text == rhs.text
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.text)
    }
}

func paragraph(lines: [String]) -> Paragraph {
    return Paragraph(lines: lines)
}

extension ListItem: Equatable, Hashable {
    public static func == (lhs: ListItem, rhs: ListItem) -> Bool {
        return lhs.text == rhs.text && lhs.checked == rhs.checked && lhs.subList == rhs.subList
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.text)
        hasher.combine(self.checked)
        hasher.combine(self.subList)
    }
}

struct IndentedItem: Equatable, Hashable {
    let item: ListItem;
    var indentation: Int = 1
    var text: String {
        get {
            return item.text ?? ""
        }
    }
}

extension List: Equatable, Hashable {
    public static func == (lhs: List, rhs: List) -> Bool {
        return lhs.items == rhs.items && lhs.ordered == rhs.ordered
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.items)
        hasher.combine(self.ordered)
    }
    
    func flatten() -> [IndentedItem] {
        var result: [IndentedItem] = []
        var queue = self.items.map({ IndentedItem(item: $0) })
        while !queue.isEmpty {
            let top = queue.removeFirst()
            result.append(top)
            if let subList = top.item.subList {
                queue.insert(
                    contentsOf: subList.items.map({ IndentedItem(item: $0, indentation: top.indentation + 1) }),
                    at: 0
                )
            }
        }
        return result
    }
}

func list(_ items: [ListItem], ordered: Bool = false) -> List {
    return List(ordered: ordered, items: items)
}

func listItem(_ text: String, subList: List? = nil, checked: Bool = false) -> ListItem {
    return ListItem(text: text, checked: checked, list: subList)
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
        return self.compactMap({ node in
            if (node is Paragraph) {
                return .paragraph(node as! Paragraph)
            } else if (node is List) {
                return .list(node as! List)
            }
            return nil
        })
    }

    func toHeadingTree() -> [Tree<Heading>] {
        return self.compactMap({
            $0 is Section ? ($0 as! Section).toHeadingTree() : nil
        })
    }
}

extension Section {
    func toHeadingTree() -> Tree<Heading> {
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

extension OrgDocument {
    func toDocument() -> Document {
        return Document(
            self.title ?? "Untitled",
            toc: self.content.toHeadingTree(),
            date: self.settings["DATE"]
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
