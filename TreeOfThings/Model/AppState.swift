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

final class Document: ObservableObject {
    @Published var id: UUID = UUID()
    @Published var title: String = "Untitled"
    @Published var toc: [Tree<Heading>] = []
    @Published var sections: [Int:Content] = [:]
    
    init(_ title: String, toc: [Tree<Heading>] = [], id: UUID = UUID()) {
        self.id = id
        self.title = title
        self.toc = toc
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
}

final class Tree<T> {
    var node: T
    var children: [Tree<T>]
    
    init(_ node: T, children: [Tree<T>] = []) {
        self.node = node
        self.children = children
    }
}

final class Content: ObservableObject {
    let id: UUID
    let value: String
    
    init (_ id: UUID, _ value: String) {
        self.id = id
        self.value = value
    }
}

final class Heading: ObservableObject, Equatable, Hashable, Identifiable {
    static func == (lhs: Heading, rhs: Heading) -> Bool {
        return lhs.title == rhs.title && lhs.level == rhs.level
    }
    
    let id: UUID
    let level: Int
    private let rawTitle: String
    @Published var done: Bool = false
    
    var title: String {
        get {
            return isToggle() ? String(self.rawTitle.dropFirst(4)) : self.rawTitle
        }
    }
    
    init(_ title: String, level: Int = 0, id: UUID = UUID()) {
        self.id = id
        self.rawTitle = title
        self.level = level
        self.done = isOn()
    }
    
    func isToggle() -> Bool {
        return isOn() || isOff()
    }
    
    func isOn() -> Bool {
        return self.rawTitle.starts(with: "[X] ")
    }
    
    func isOff() -> Bool {
        return self.rawTitle.starts(with: "[ ] ")
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(level)
    }
}
