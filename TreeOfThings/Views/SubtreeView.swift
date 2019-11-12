//
//  SubtreeView.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 11/12/19.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import SwiftUI

struct SubtreeView: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("some content")
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .navigationBarTitle(title)
    }
}

struct SubtreeView_Previews: PreviewProvider {
    static var previews: some View {
        SubtreeView(title: "Hello")
    }
}
