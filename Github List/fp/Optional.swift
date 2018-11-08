//
//  Optional.swift
//  Github List
//
//  Created by Joe Maher on 7/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation

public extension Optional {

    func forEach(_ f: (Wrapped) -> ()) {
        if let x = self {
            f(x)
        }
    }
}
