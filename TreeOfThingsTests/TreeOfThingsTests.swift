//
//  TreeOfThingsTests.swift
//  TreeOfThingsTests
//
//  Created by Donatas Petrauskas on 2019-11-11.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import XCTest
@testable import TreeOfThings

class TreeOfThingsTests: XCTestCase {
    private let documentService = DocumentService()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParsingEmptyDocument() {
        XCTAssertEqual(try getDocument(""), Document("Untitled"))
    }

    func testParsingDocumentWithTitleOnly() {
        XCTAssertEqual(try getDocument("#+TITLE: A"), Document("A"))
    }

    func testParsingDocumentWithSingleHeading() {
        let doc = try! getDocument("* Hello World");
        let expected = Document("Untitled", toc: [Tree(Heading("Hello World"))])
        XCTAssertEqual(doc, expected)
    }

    private func getDocument(_ content: String) throws -> Document {
        return try documentService
            .parse(content: content)
            .mapLoaded({ $0.toDocument() })
            .get()
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
