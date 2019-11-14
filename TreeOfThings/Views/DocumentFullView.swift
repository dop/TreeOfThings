//
//  DocumentFullView.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 11/14/19.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import SwiftUI

struct DocumentFullView: View {
    let document: Document

    init(_ doc: Document) {
        self.document = doc
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(document.headingList) { heading in
                    HeadingView(heading)
                    ContentListView(content: heading.content)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
        .padding()
        .navigationBarTitle(document.title)
    }
}

struct DocumentFullView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentFullView(try! parseExample("Example"))
    }

    private static func parseExample(_ resource: String) throws -> Document {
        switch (DocumentService().parse(resource: resource)) {
        case .ok(let org):
            return org.toDocument()
        default:
            fatalError("Failed to parse resource \"\(resource)\".")
        }
    }
}
