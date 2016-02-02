#import "ACMValidators.h"

@implementation ACMValidators

+ (NSString *_Nullable)localizedValidationErrorMessageForEmail:(NSString *_Nullable)emailAddress
{
    if (![self isValidEmail:emailAddress]) {
        return NSLocalizedString(@"Please enter a valid email address", nil);
    }

    return nil;
}

#pragma mark Private
+ (BOOL)isValidEmail:(NSString *_Nullable)possibleEmail
{
    if (nil == possibleEmail || possibleEmail.length < 5) {
        return NO;
    }

    NSRange atRange = [possibleEmail rangeOfString:@"@"];
    if (atRange.location == NSNotFound || atRange.location == 0 || atRange.location == possibleEmail.length - 1) {
        return NO;
    }

    NSString *domainString = [possibleEmail componentsSeparatedByString:@"@"].lastObject;
    NSRange dotRange = [domainString rangeOfString:@"."];

    if (dotRange.location == NSNotFound || dotRange.location == 0 || dotRange.location == domainString.length - 1) {
        return NO;
    }

    if ([domainString characterAtIndex:domainString.length - 1] == '.') {
        return NO;
    }

    return YES;
}

@end
