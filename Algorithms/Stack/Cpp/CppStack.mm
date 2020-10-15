//
//  CppStack.m
//  Algorithms
//
//  Created by Roman Vovk on 14.10.2020.
//  Copyright © 2020 Roman Vovk. All rights reserved.
//

#import "CppStack.h"
#import "Defines.h"
#include <stack>
#include <vector>

@implementation CppStack {
    std::stack<id> stackContainer;
}

- (BOOL)isEmpty {
    return stackContainer.empty();
}
- (size_t)size {
    return stackContainer.size();
}

- (void)push:(id)obj {
    stackContainer.push(obj);
}

- (void)pop {
    stackContainer.pop();
}

- (nullable id)top {
    let object = stackContainer.top();
    return object;
}

@end
