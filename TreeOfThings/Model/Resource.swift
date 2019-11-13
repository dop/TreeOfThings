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
    case ok(T)
    case failed(Error)
    
    func ifLoaded(_ f: (T) -> Void) -> Void {
        let _ = self.mapLoaded({ f($0) })
    }

    func mapLoaded<X>(_ f: (T) -> X) -> Resource<X> {
        switch self {
            case .ok(let resource):
                return .ok(f(resource))
            default:
                return self as! Resource<X>
        }
    }
    
    func get() throws -> T {
        switch self {
            case .ok(let value):
                return value
            default:
                fatalError("Resource (\(self)) is not loaded")
        }
    }
}
