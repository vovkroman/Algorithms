//
//  TestTask.m
//  AlgorithmsTests
//
//  Created by Roman Vovk on 20.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

#import "TestTask.h"

@interface TestTask ()

@property(copy, nonatomic) NSString* message;

@end

@implementation TestTask {
    NSUInteger _priority;
}

// MARK: - Initializers

- (instancetype)init:(NSString *)message andPriority:(NSUInteger)priority {
    if (self = [super init]) {
        self.message = [NSString stringWithFormat:@"%@ with priority %@", message, @(priority)];
        _priority = priority;
    }
    return self;
}

- (void)update:(NSString *)message {
    self.message = message;
}

/**
 * Please note according to current implemention
 * Priority queue will deque element in ascending order
 */
- (CFComparisonResult)compare:(TestTask *)otherObject {
    if (_priority == otherObject->_priority)
        return kCFCompareEqualTo;
    else if (_priority < otherObject->_priority)
        return kCFCompareLessThan;
    else
        return kCFCompareGreaterThan;
}

@end
