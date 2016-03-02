#import <UIKit/UIKit.h>
#import <ResearchKit/ResearchKit.h>
#import <CMHealth/CMHealth.h>

static NSString *_Nullable const ACMSurveyDataNotification = @"ACMSurveyDataFetched";

@interface ACMMainPanelViewController : UITabBarController

@property (nonatomic, nullable, readonly) ORKTaskResult *consentResult;
@property (nonatomic, nullable, readonly) NSArray <ORKTaskResult *> *surveyResults;
@property (nonatomic, nullable, readonly) CMHConsent *consent;

- (void)refreshData;
- (void)uploadResult:(ORKResult *_Nonnull)surveyResult;

- (NSInteger)countOfSurveyResultsWithIdentifier:(NSString *_Nonnull)identifier;
- (NSInteger)countOfSurveyResultsWithIdentifier:(NSString *_Nonnull)identifier onCalendarDay:(NSDate *_Nonnull)day;

@end
