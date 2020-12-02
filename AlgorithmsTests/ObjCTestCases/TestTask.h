//
//  TestTask.h
//  AlgorithmsTests
//
//  Created by Roman Vovk on 20.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Algorithms/CFPriorityQueue.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestTask: NSObject <CFComparableProtocol>

@property(copy, nonatomic, readonly) NSString* message;

- (void)update:(NSString *)message;

// MARK: - Initializers
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)init:(NSString *)message andPriority:(NSUInteger)priority;

@end

NS_ASSUME_NONNULL_END
