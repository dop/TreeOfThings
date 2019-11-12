//
//  DocumentReaderTests.swift
//  TreeOfThingsTests
//
//  Created by Donatas Petrauskas on 2019-11-11.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import XCTest
@testable import TreeOfThings

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

class DocumentReaderTests: XCTestCase {
    func testTOC() {
        let singleton = try! parse("* Hi")
        XCTAssertEqual(singleton.tableOfContents(), [Heading(id: 0, level: 0, title: "Hi")])
        
        let couple = try! parse("* Hi\n* Hey")
        XCTAssertEqual(couple.tableOfContents(), [Heading(id: 0, level: 0, title: "Hi"), Heading(id: 1, level: 0, title: "Hey")])
        
        let nested = try! parse("* Hi\n** Hey\n*** Oi\n* Ai")
        XCTAssertEqual(
            nested.tableOfContents(),
            [ Heading(id: 0, level: 0, title: "Hi"),
              Heading(id: 1, level: 1, title: "Hey"),
              Heading(id: 2, level: 2, title: "Oi"),
              Heading(id: 3, level: 0, title: "Ai"),
            ]
        )
    }
    
    func testTitle() {
        XCTAssertEqual(try! parse("").title(), "Untitled")
        XCTAssertEqual(try! parse("#+TITLE: World").title(), "World")
    }

    private func parse(_ content: String) throws -> DocumentReader {
        switch (DocumentService().parse(content: content)) {
        case .ok(let org):
            return DocumentReader(org)
        default:
            fatalError("Failed parsing \"\(content)\".")
        }
    }
}
