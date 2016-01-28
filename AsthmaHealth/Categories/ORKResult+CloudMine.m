#import "ORKResult+CloudMine.h"
#import <objc/runtime.h>
#import "ACMResultWrapper.h"

@implementation ORKResult (CloudMine)

- (void)cm_saveWithCompletion:(_Nullable ACMSaveCompletion)block
{
    Class resultWrapperClass = [ACMResultWrapper wrapperClassForResultClass:[self class]];
    
    NSAssert([[resultWrapperClass class] isSubclassOfClass:[ACMResultWrapper class]],
             @"Fatal Error: Result wrapper class not a result of ACMResultWrapper");

    ACMResultWrapper *resultWrapper = [[resultWrapperClass alloc] initWithResult:self];
    
    [resultWrapper saveWithUser:[CMStore defaultStore].user callback:^(CMObjectUploadResponse *response) {
        if (nil == block) {
            return;
        }

        if (nil != response.error) {
            block(nil, response.error);
            return;
        }

        // Thought: as we expand the functionality of the SDK, would it make sense to return the objectId to the
        // the caller so they could later fetch the same results? This would esepcially make sense if we eventually
        // want to support serializing and uploading things other than results, such as in-progress-ORKTasks that might
        // be continued by the user later
        if (nil == response.uploadStatuses || nil == [response.uploadStatuses objectForKey:resultWrapper.objectId]) {
            NSError *nullStatusError = [ORKResult errorWithMessage:@"CloudMine upload status not returned" andCode:100];
            block(nil, nullStatusError);
            return;
        }

        NSString *resultUploadStatus = [response.uploadStatuses objectForKey:resultWrapper.objectId];
        if(![@"created" isEqualToString:resultUploadStatus] && ![@"updated" isEqualToString:resultUploadStatus]) {
            NSString *message = [NSString localizedStringWithFormat:@"CloudMine invalid upload status returned: %@", resultUploadStatus];
            NSError *invalidStatusError = [ORKResult errorWithMessage:message andCode:101];
            block(nil, invalidStatusError);
            return;
        }

        block(resultUploadStatus, nil);
    }];
}

# pragma mark Private

+ (NSError * _Nullable)errorWithMessage:(NSString * _Nonnull)message andCode:(NSInteger)code
{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: message };
    NSError *error = [NSError errorWithDomain:@"ACMResultSaveError" code:code userInfo:userInfo];
    return error;
}

@end

@implementation ORKConsentSignature (CloudMine)
@end

@implementation UIImage (CloudMine)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(encodeWithCoder:);
        SEL swizzledSelector = @selector(acm_encodeWithCoder:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)acm_encodeWithCoder:(NSCoder *)aCoder
{
    if ([aCoder isKindOfClass:[CMObjectEncoder class]]) {
        NSLog(@"ENCODING UIImage HAS BEEN SWIZZLED");
        return;
    }

    [self acm_encodeWithCoder:aCoder];
}

@end

@implementation NSUUID (CloudMine)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(encodeWithCoder:);
        SEL swizzledSelector = @selector(acm_encodeWithCoder:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)acm_encodeWithCoder:(NSCoder *)aCoder
{
    if ([aCoder isKindOfClass:[CMObjectEncoder class]]) {
        [aCoder encodeObject:self.UUIDString forKey:@"UUIDString"];
        return;
    }

    [self acm_encodeWithCoder:aCoder];
}

// TODO: Swizzle decodeWithCoder

@end