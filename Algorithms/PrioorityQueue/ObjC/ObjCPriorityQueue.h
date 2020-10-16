//
//  ObjCPriorityQueue.h
//  Algorithms
//
//  Created by Roman Vovk on 16.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjCPriorityQueue<__covariant ObjectType> : NSObject

- (void)enqueue:(ObjectType)object;
- (nullable ObjectType)dequeue;
- (CFIndex)count;
- (BOOL)contains:(ObjectType)object;

#pragma mark - Initialization
- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
