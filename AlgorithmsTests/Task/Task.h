#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject {
  int priority;
  NSString *name;
}

- (instancetype)initWithPriority:(int)p andName:(NSString *)n;
- (NSComparisonResult)compare:(id)other;

@end

NS_ASSUME_NONNULL_END
