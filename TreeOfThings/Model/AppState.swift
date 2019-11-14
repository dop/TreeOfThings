//
//  AppState.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 11/12/19.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import Foundation

final class AppState: ObservableObject {
    @Published var documents: Resource<[Document]> = .uninitialized
}

final class Document: Equatable, ObservableObject, CustomStringConvertible {
    static func == (lhs: Document, rhs: Document) -> Bool {
        return lhs.title == rhs.title && lhs.toc == rhs.toc
    }

    @Published var id: UUID = UUID()
    @Published var title: String = "Untitled"
    @Published var toc: [Tree<Heading>] = []
    let date: String?
    
    init(_ title: String, toc: [Tree<Heading>] = [], date: String? = nil,  id: UUID = UUID()) {
        self.id = id
        self.title = title
        self.toc = toc
        self.date = date
    }
    
    var headingList: [Heading] {
        get {
            var headings: [Heading] = []
            var queue: [Tree<Heading>] = toc
            while !queue.isEmpty {
                let top = queue.removeFirst()
                queue.insert(contentsOf: top.children, at: 0)
                headings.append(top.node)
            }
            return headings
        }
    }

    var description: String {
        return "Document(\(title), toc: \(toc))"
    }
}

final class Tree<T>: Equatable, CustomStringConvertible where T: Equatable {
    static func == (lhs: Tree<T>, rhs: Tree<T>) -> Bool {
        return lhs.node == rhs.node && lhs.children == rhs.children
    }

    var node: T
    var children: [Tree<T>]
    
    init(_ node: T, children: [Tree<T>] = []) {
        self.node = node
        self.children = children
    }

    var description: String {
        return "Tree(\(node), \(children))"
    }
}

enum HeadingType: Equatable {
    case simple
    case todo(HeadingTodoType)
    case checkbox(Bool)
}

enum HeadingTodoType: Equatable {
    case todo
    case done
}

final class Heading: ObservableObject, Equatable, Hashable, Identifiable, CustomStringConvertible {
    static func == (lhs: Heading, rhs: Heading) -> Bool {
        return lhs.title == rhs.title && lhs.level == rhs.level && lhs.type == rhs.type && lhs.content == rhs.content
    }
    
    @Published var isDone: Bool = false {
        didSet {
            switch type {
                case .checkbox(_):
                    self.type = .checkbox(isDone)
                case .todo(_):
                    self.type = .todo(isDone ? .done : .todo)
                default:
                    break
            }
        }
    }

    let id: UUID
    let title: String
    let level: Int
    var type: HeadingType
    let content: [Content]

    init(_ title: String, level: Int = 1, type: HeadingType = .simple, content: [Content] = [], id: UUID = UUID()) {
        self.id = id
        self.title = title
        self.level = level
        self.type = type
        self.content = content
        self.isDone = isToggle() && isChecked()
    }

    func isToggle() -> Bool {
        switch (type) {
            case .checkbox(_), .todo(_):
                return true
            default:
                return false
        }
    }

    func isChecked() -> Bool {
        switch type {
            case .checkbox(let checked):
                return checked
            case .todo(let type):
                switch type {
                    case .done:
                        return true
                    case .todo:
                        return false
                }
            default:
                return false
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(level)
    }

    var description: String {
        return "Heading(\(level) \(type) \(title) \(content))"
    }
}
