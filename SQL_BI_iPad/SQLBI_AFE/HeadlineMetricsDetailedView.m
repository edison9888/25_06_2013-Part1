//
//  HeadlineMetricsDetailedView.m
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HeadlineMetricsDetailedView.h"

@interface HeadlineMetricsDetailedView()
{
    KPIModel *kpiObject;
    NSDate *startDate;
    NSDate *endDate;
}

@property(nonatomic, strong) HeadlineMetricsSummaryView *summaryView;

@end

@implementation HeadlineMetricsDetailedView
@synthesize summaryView;

- (id)initWithFrame:(CGRect)frame
{
    self = (HeadlineMetricsDetailedView*) [[[NSBundle mainBundle] loadNibNamed:@"HeadlineMetricsDetailedView" owner:self options:nil] lastObject];
    if (self) {
        // Initialization code
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.x, self.frame.size.width, self.frame.size.height);
    }
    return self;
}


-(void) refreshDataWithKPIModel:(KPIModel*) kpiModelToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end
{
    kpiObject = kpiModelToUse;
    startDate = start;
    endDate = end;
    
    if(self.summaryView)
        [self.summaryView refreshDataWithKPIModel:kpiObject andStartDate:start andEndDate:end];
}



-(void) dealloc
{
    kpiObject = nil;

}

@end
