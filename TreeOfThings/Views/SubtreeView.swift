//
//  SubtreeView.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 11/12/19.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import SwiftUI

struct SubtreeView: View {
    let heading: Heading
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(heading.content, id: \.self) { item in
                    Text(item.text)
                        .multilineTextAlignment(.leading)
                        .padding()
                }
            }
        }
        .navigationBarTitle(heading.title)
    }
}

struct SubtreeView_Previews: PreviewProvider {
    static var previews: some View {
        SubtreeView(heading: Heading("Hello"))
    }
}
