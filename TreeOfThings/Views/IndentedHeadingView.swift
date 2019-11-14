//
//  HeadingView.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 2019-11-12.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import SwiftUI

struct IndentedHeadingView: View {
    @ObservedObject var heading: Heading

    init(_ heading: Heading) {
        self.heading = heading
    }
    
    var body: some View {
        HeadingView(heading)
            .padding(.leading, CGFloat(IndentedHeadingView.PADDING_STEP * (heading.level + 1)))
    }

    private static let PADDING_STEP = 15
}

struct IndentedHeadingView_Previews: PreviewProvider {
    static let headings = (0..<6).map({ level in
        Heading(
            "Example Heading of Level \(level)",
            level: level
        )
    })
    
    static var previews: some View {
        VStack {
            List(headings) { heading in
                IndentedHeadingView(heading)
            }
            IndentedHeadingView(Heading("[ ] Not Marked"))
            IndentedHeadingView(Heading("[X] Marked"))
        }
    }
}
