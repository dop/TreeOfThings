//
//  HeadingView.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 2019-11-12.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import SwiftUI

struct HeadingView: View {
    let rawTitle: String;
    let padding: Int
    let prefix: String
    @State var done: Bool = false

    var title: String {
        get {
            return isToggle() ? String(self.rawTitle.dropFirst(4)) : self.rawTitle
        }
    }

    init(_ title: String, padding: Int = 0) {
        self.rawTitle = title
        self.padding = padding
        self.prefix = String(repeating: "*", count: self.padding + 1)
    }
    
    var body: some View {
        if isToggle() {
            return AnyView(Toggle(isOn: $done) { heading })
        } else {
            return AnyView(heading)
        }
    }

    private var heading: some View {
        Text(title)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(.leading, CGFloat(HeadingView.PADDING_STEP * (padding + 1)))
            .font(fontSize(forPadding: padding))
    }

    private static let PADDING_STEP = 15
    
    private static let FONT_SIZES = [
        Font.largeTitle,
        Font.title,
        Font.headline,
        Font.body,
        Font.subheadline,
    ]
    
    private func fontSize(forPadding: Int) -> Font {
        if (forPadding < HeadingView.FONT_SIZES.count) {
            return HeadingView.FONT_SIZES[forPadding]
        }
        return HeadingView.FONT_SIZES.last ?? Font.body
    }

    private func isToggle() -> Bool {
       return isOn() || isOff()
    }

    private func isOn() -> Bool {
        return rawTitle.starts(with: "[X] ")
    }

    private func isOff() -> Bool {
        return rawTitle.starts(with: "[ ] ")
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
