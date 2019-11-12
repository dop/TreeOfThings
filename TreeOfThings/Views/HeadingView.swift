//
//  HeadingView.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 2019-11-12.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import SwiftUI

struct HeadingView: View {
    let title: String
    let padding: Int
    let prefix: String

    init(_ title: String, padding: Int = 0) {
        self.title = title
        self.padding = padding
        self.prefix = String(repeating: "*", count: self.padding + 1)
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.leading, CGFloat(15 + padding * 15))
                .font(.title)
        }
    }
}

struct HeadingView_Previews: PreviewProvider {
    static let headings = (0..<6).map({ level in
        Heading(
            id: level,
            level: level,
            title: "Example Heading of Level \(level)"
        )
    })
    
    static var previews: some View {
        List(headings) { heading in
            HeadingView(heading.title, padding: heading.level)
        }
    }
}
