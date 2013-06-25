//
//  TDMChannelsViewController.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/3/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMOverlayView.h"

@interface TDMChannelsViewController : TDMBaseViewController<parseData>{
    
    NSMutableArray *channelDetails;
    
      
    TDMOverlayView * overlayView;
    
}



@property (nonatomic, retain) IBOutlet UITableView *channelTable;
@property (nonatomic, retain) IBOutlet UIImageView *backgroungImage;
@property (retain, nonatomic) IBOutlet UILabel *channelsName;


- (void)refreshView;

#pragma mark  -  Overlay View Management
- (void)showOverlayView;
- (void)removeOverlayView;

@end
