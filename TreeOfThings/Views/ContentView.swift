//
//  SubtreeView.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 11/12/19.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import SwiftUI
import SwiftOrg

extension Content {
    func toUI() -> AnyView {
        switch self {
        case .paragraph(let paragraph):
            return AnyView(ParagraphView(paragraph: paragraph))
        case .list(let list):
            return AnyView(ListView(items: list.flatten()))
        }
    }
}

struct ParagraphView: View {
    let paragraph: Paragraph
    
    var body: some View {
        Text(paragraph.text)
            .font(.body)
            .multilineTextAlignment(.leading)
    }
}

struct ListView: View {
    let items: [IndentedItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(items, id: \.self) { IndentedItemView(item: $0) }
        }
    }
}

struct IndentedItemView: View {
    let item: IndentedItem
    
    var body: some View {
        HStack(alignment: .top) {
            Text("◦")
            Text(item.text)
                .font(.body)
                .multilineTextAlignment(.leading)
        }
        .padding(.leading, CGFloat(item.indentation * 10))
    }
}

struct ContentView: View {
    let heading: Heading
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(heading.content, id: \.self) { $0.toUI() }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
        .padding()
        .navigationBarTitle(heading.title)
    }
}

struct SubtreeView_Previews: PreviewProvider {
    static let p = paragraph(lines: ["The following is a barebone example on using Emacs org-mode for blogging. For a practically usable code, see the https://gitlab.com/sadiq/sadiq.gitlab.io for source of this website."])
    static let l = list([
        listItem("Create an org file with your favorite article, say no more"),
        listItem("Create a directory for saving your website source, say web src."),
        listItem("How are you?", subList: list(
            [listItem("Fine, and You?", subList: list([listItem("Great!")]))]
        )),
        listItem("Create a directory for saving your website source, say hello."),
    ])

    static var previews: some View {
        ContentView(heading: Heading("Hello", content: [.paragraph(p), .list(l)]))
    }
}
