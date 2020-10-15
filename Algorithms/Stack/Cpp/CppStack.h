//
//  CppStack.h
//  Algorithms
//
//  Created by Roman Vovk on 14.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CppStack<__covariant ObjectType> : NSObject

- (BOOL)isEmpty;
- (size_t)size;
- (void)push:(ObjectType)obj;
- (void)pop;
- (nullable ObjectType)top;

@end

NS_ASSUME_NONNULL_END
