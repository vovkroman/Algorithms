#import "CppPriorityQueue.h"
#include <algorithm>
#include <vector>
#include "Defines.h"

struct CBOQNode {
private:
    id obj;
public:
    unsigned priority;
    
    const id getObj() {
        return obj;
    }
    
    CBOQNode(id object, int priority) {
        this->obj = object;
        this->priority = priority;
    }
    
    ~CBOQNode() {}
};

CF_INLINE bool nodeLessThan(const CBOQNode &n1, const CBOQNode &n2){
    return n1.priority > n2.priority;
}

CF_INLINE bool nodeMoreThan(const CBOQNode &n1, const CBOQNode &n2){
    return n1.priority < n2.priority;
}

@implementation CppPriorityQueue {
    std::vector<CBOQNode> mObjs;
    BOOL mHeapified;
    bool (*sortFunc)(const CBOQNode &, const CBOQNode &);
}

#pragma mark - Initializer

- (instancetype)init:(ComparisonResult)comparationResult; {
    if(self = [super init]) {
        switch (comparationResult) {
            case OrderedAscending:
                sortFunc = nodeLessThan;
                break;
            case OrderedDescending:
                sortFunc = nodeMoreThan;
                break;
        }
    }
    return self;
}

#pragma mark - Build Heap

/*This function is used to convert a range in a container to a heap.*/
- (void)buildheap {
    std::make_heap(mObjs.begin(), mObjs.end(), sortFunc);
    mHeapified = YES;
}

#pragma mark -

- (size_t)count {
    return mObjs.size();
}

- (BOOL)isEmpty {
    return mObjs.empty();
}

/**
 * This fucntion enqueues
 *  object with specific unsigned priority
 **/
- (void)enqueue:(nullable id)obj value:(unsigned)val {
    let node = CBOQNode(obj, val);
    
    mObjs.push_back(node);
    
    if (mHeapified) std::push_heap(mObjs.begin(), mObjs.end(), sortFunc);
}

- (nullable id)dequeue; {
    if(!mHeapified) {
        [self buildheap];
    }
    std::pop_heap(mObjs.begin(), mObjs.end(), sortFunc);
    let obj = mObjs.front().getObj();
    mObjs.pop_back();
    
    return obj;
}

@end

