//
//  Document.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 2019-11-11.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import Foundation
import SwiftOrg

typealias Document = OrgDocument

enum DocumentState {
    case empty
    case ok(Document)
    case fail(Error)
}

enum DocumentError: Error {
    case notfound(String)
}

class DocumentService {
    let parser = OrgParser()
    
    func parse(resource: String) -> DocumentState {
        guard let path = Bundle.main.path(forResource: resource, ofType: "org") else {
            return .fail(DocumentError.notfound(resource))
        }
        return self.parse(path: path)
    }
    
    func parse(path: String) -> DocumentState {
        do {
            return self.parse(content: try String(contentsOfFile: path, encoding: .utf8));
        } catch {
            return .fail(error)
        }
    }
    
    func parse(content: String) -> DocumentState {
        do {
            return .ok(try parser.parse(content: content));
        } catch {
            return .fail(error)
        }
    }
}
