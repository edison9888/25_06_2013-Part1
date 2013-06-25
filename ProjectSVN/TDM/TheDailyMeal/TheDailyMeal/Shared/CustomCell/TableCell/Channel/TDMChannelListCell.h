//
//  TDMChannelListCell.h
//  TheDailyMeal
//
//  Created by Nithin George on 11/01/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMChannelListCellView.h"

@interface TDMChannelListCell : UITableViewCell

{
    TDMChannelListCellView *channelListCellView;
    UIImageView *backgroundImageView;
}

@property(nonatomic, retain) TDMChannelListCellView *channelListCellView;


- (void)displayCellItems:(id)item;
- (void) showDefaultImage;

@end
