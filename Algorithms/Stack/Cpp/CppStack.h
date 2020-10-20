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
