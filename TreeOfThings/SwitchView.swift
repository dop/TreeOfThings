//
//  SwitchView.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 2019-11-11.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import SwiftUI

struct SwitchView<T>: View {
    let value: T;
    let constructor: (_ value: T) -> Optional<AnyView>;
    
    init(_ value: T, container: @escaping (_ value: T) -> Optional<AnyView>) {
        self.value = value;
        self.constructor = container;
    }
    
    var body: some View {
        constructor(value)
    }
}
