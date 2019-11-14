//
//  HeadingView.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 11/14/19.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import SwiftUI

struct HeadingView: View {
    @ObservedObject var heading: Heading

     init(_ heading: Heading) {
         self.heading = heading
     }

     var body: some View {
         if heading.isToggle() {
             return AnyView(Toggle(isOn: $heading.isDone) { headingView })
         } else {
             return AnyView(headingView)
         }
     }

     private var headingView: some View {
         Text(heading.title)
             .lineLimit(1)
             .truncationMode(.tail)
             // .padding(.leading, CGFloat(HeadingView.PADDING_STEP * (heading.level + 1)))
             .font(fontSize(forPadding: heading.level))
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
}
