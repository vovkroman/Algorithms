//
//  ParkBenchTimer.swift
//  AlgorithmsTests
//
//  Created by Roman Vovk on 12.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

import Foundation
import CoreFoundation

public class ParkBenchTimer {
    
    public let startTime:CFAbsoluteTime
    public var endTime:CFAbsoluteTime?
    
    public init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    public func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        
        return duration!
    }
    
    public var duration:CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}
