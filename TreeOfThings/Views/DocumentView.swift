//
//  DocumentView.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 11/14/19.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import SwiftUI

struct DocumentView: View {
    @State var overview: Bool = true
    let document: Document

    var body: some View {
        if overview {
            return AnyView(DocumentOverview(document).navigationBarItems(trailing: fullViewButton))
        } else {
            return AnyView(DocumentFullView(document).navigationBarItems(trailing: overviewButton))
        }
    }

    var fullViewButton: some View {
        Button(action: { self.overview = false }) {
            Image(systemName: "text.justify")
        }
    }

    var overviewButton: some View {
        Button(action: { self.overview = true }) {
            Image(systemName: "list.bullet.indent")
        }
    }
}

struct DocumentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentView(document: try! parseExample("Example"))
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
