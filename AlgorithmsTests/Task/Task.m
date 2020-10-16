#import "Task.h"

@implementation Task

- (instancetype)initWithPriority:(int)p andName:(NSString *)n {
  if ((self = [super init])) {
    priority = p;
    name = [n copy];
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%d, %@", priority, name];
}

- (NSComparisonResult)compare:(Task *)other {
  if (priority == other->priority)
    return NSOrderedSame;
  else if (priority > other->priority)
    return NSOrderedAscending;
  else
    return NSOrderedDescending;
}

@end
