#import "CppStack.h"
#import "Defines.h"
#include <stack>
#include <vector>

@implementation CppStack {
    std::stack<id> _stackContainer;
}

- (BOOL)isEmpty {
    return _stackContainer.empty();
}
- (size_t)size {
    return _stackContainer.size();
}

- (void)push:(id)obj {
    _stackContainer.push(obj);
}

- (void)pop {
    _stackContainer.pop();
}

- (nullable id)top {
    let object = _stackContainer.top();
    return object;
}

@end
