//
//  Resource.swift
//  TreeOfThings
//
//  Created by Donatas Petrauskas on 2019-11-13.
//  Copyright © 2019 Donatas Petrauskas. All rights reserved.
//

import Foundation

enum Resource<T> {
    case uninitialized
    case loading
    case loaded(T)
    case failed(Error)
    
    func ifLoaded(_ f: (T) -> Void) -> Void {
        return self.withLoaded({ f($0) })
    }

    func mapLoaded<X>(_ f: (T) -> X) -> Resource<X> {
        return self.withLoaded({ .loaded(f($0)) })
    }
    
    func withLoaded<X>(_ f: (T) -> X) -> X {
        switch self {
        case .loaded(let resource):
            return f(resource)
        default:
            return self as! X
        }
    }
}
