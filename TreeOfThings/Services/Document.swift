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

struct DocumentService {
    let parser = OrgParser()
    
    func empty() -> DocumentState {
        return DocumentState.empty;
    }
    
    func parse(resource: String) -> DocumentState {
        let path = Bundle.main.path(forResource: resource, ofType: "org")
        do {
            return self.parse(content: try String(contentsOfFile: path!, encoding: .utf8));
        } catch {
            print(error)
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
