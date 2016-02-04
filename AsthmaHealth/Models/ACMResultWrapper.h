#import <CloudMine/CloudMine.h>
#import <ResearchKit/ResearchKit.h>

@interface ACMResultWrapper : CMObject

- (_Nonnull instancetype)initWithResult:(ORKResult *_Nonnull)result;
- (_Nonnull instancetype)initWithCoder:(NSCoder *_Nonnull)aDecoder;
- (ORKResult *_Nullable)wrappedResult;
+ (_Nonnull Class)wrapperClassForResultClass:(_Nonnull Class)resultClass;

@end
