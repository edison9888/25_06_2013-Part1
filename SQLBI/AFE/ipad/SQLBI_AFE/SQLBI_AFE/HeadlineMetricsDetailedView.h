//
//  HeadlineMetricsDetailedView.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadlineMetricsSummaryView.h"
#import "KPIModel.h"

@interface HeadlineMetricsDetailedView : UIView


-(void) refreshDataWithKPIModel:(KPIModel*) kpiModelToUse andStartDate:(NSDate*) start andEndDate:(NSDate*) end;

@end
