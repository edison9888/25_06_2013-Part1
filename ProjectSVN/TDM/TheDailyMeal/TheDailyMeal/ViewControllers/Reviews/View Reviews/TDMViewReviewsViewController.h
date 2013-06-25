//
//  TDMViewReviewsViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/13/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMBaseViewController.h"
#import "TDMViewReviewCustomCell.h"

@interface TDMViewReviewsViewController : TDMBaseViewController
{
    NSMutableDictionary *dict;
    
}
@property (retain, nonatomic) IBOutlet TDMViewReviewCustomCell *viewReviewCell;

- (void)initialize;
@end
