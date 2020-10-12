//
//  Shared.swift
//  Algorithms
//
//  Created by Roman Vovk on 12.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

import Foundation

public protocol Keyable {
    associatedtype KeyType: Comparable
    var key: KeyType { get }
}
