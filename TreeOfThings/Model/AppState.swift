//
//  AppState.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 11/12/19.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import Foundation

enum Resource<T> {
    case uninitialized
    case loading
    case loaded(T)
}

final class AppState: ObservableObject {
    @Published var documents: Resource<[Document]> = .uninitialized
}
