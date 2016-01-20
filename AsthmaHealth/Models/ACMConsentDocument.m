#import "ACMConsentDocument.h"

static NSString *const ACMSignatureIdentifier = @"ACMConsentParticipantConsentSignature";

@implementation ACMConsentDocument

// TODO: Ponder, is a subclass actually neccessary?
- (instancetype)init
{
    self = [super init];
    if (nil == self) return nil;

    self.sections = ACMConsentDocument.sections;

    ORKConsentSignature *signature = [ORKConsentSignature signatureForPersonWithTitle:nil dateFormatString:nil identifier:ACMSignatureIdentifier];
    [self addSignature:signature];

    return self;
}

#pragma mark Static Private Helpers

+ (NSArray<ORKConsentSection *> *)sections
{
    return @[self.welcomeSection,
             self.testSection,
             self.dataSection];
}

+ (ORKConsentSection *)sectionWithType:(ORKConsentSectionType)type title:(NSString *)title summary:(NSString *)summary andContent:(NSString *)content
{
    ORKConsentSection *section = [[ORKConsentSection alloc] initWithType:type];
    section.summary = summary;
    section.content = content;
    if (nil != title) { section.title = title; }

    return section;
}

+ (ORKConsentSection *)welcomeSection
{
    return [self sectionWithType:ORKConsentSectionTypeOverview
                           title:nil
                          summary:NSLocalizedString(@"Mount Sinai is doing a research study about whether an asthma app on your iPhone will help you to monitor your asthma. This simple walkthrough will help you to understand the study, the impact it will have on your life, and will allow you to provide consent to participate.", nil)
                      andContent:NSLocalizedString(@"People with asthma do best if they actively manage their asthma. This app uses your mobile phone to help you do this. If you take daily asthma medicine, the app will help you remember to take it on schedule. There are links to learn more about asthma, how to use your medicine, what triggers your asthma, and how to recognize when your asthma is out of control. The information you put into the app will help you track how well your asthma is controlled and how you are doing compared to other app users with asthma. Although we will look at the data at different points during the study, we will not be looking at your asthma information each day. The app does not replace your usual medical care, so if your asthma is getting worse during the study, please reach out to your health care team", nil)];
}

+ (ORKConsentSection *)testSection
{
    return [self sectionWithType:ORKConsentSectionTypeCustom
                           title:NSLocalizedString(@"We'll Test Your Understanding", nil)
                         summary:NSLocalizedString(@"We’ll walk you through some information on our Asthma research study, and  provide a short quiz at the end to confirm your understanding.", nil)
                      andContent:NSLocalizedString(@"Before completing the enrollment and creating your study account, we will assess your understanding and eligibility to provide consent. It is important that you understand what the study is about and what is involved. You should not join the research study until all of your questions are answered. Feel free to contact the study sponsor with any questions.", nil)];
}

+ (ORKConsentSection *)dataSection
{
    return [self sectionWithType:ORKConsentSectionTypeDataGathering
                           title:nil
                         summary:NSLocalizedString(@"This study will gather location and sensor data from your phone and personal fitness devices (such as Apple Watch) with your permission. You can choose not to do this and still participate in the study.", nil)
                      andContent:NSLocalizedString(@"If you use a personal health device with your iPhone (such as a Apple Watch) and use iOS8 or later (which includes Apple HealthKit), you can choose to include the data from the device in the study. You can set our app to get all, some, or none of the data. You can choose not to do this and still participate in the study.\n\nYou will have the choice to use the asthma app to receive location-specific information such as weather and air quality in your area. If you choose to do so, the asthma app will use the location of your phone to send you information about your general area. The asthma app will record the location of your iPhone (in latitude/longitude coordinate form) as often as once per hour when the app is open in order to help identify location-specific triggers, such as point sources of industrial pollution that may make your asthma worse. You are free to turn off the asthma app's access to your location. If you do this, your location will not be recorded and you will not receive location-specific information about air quality.\n\nWe will NOT access your personal contacts, other applications, phone use habits, text messages, personal photos, or websites visited.", nil)];
}

@end
