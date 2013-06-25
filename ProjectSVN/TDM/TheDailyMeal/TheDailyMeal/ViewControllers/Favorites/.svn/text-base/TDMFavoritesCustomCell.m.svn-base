//
//  TDMFavoritesCustomCell.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 23/02/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMFavoritesCustomCell.h"

@implementation TDMFavoritesCustomCell
@synthesize titleText;
@synthesize favImage;
@synthesize descriptionText;
@synthesize categoryDetails;

#pragma mark - Memory Management

- (void)dealloc 
{
    [titleText release];
    [favImage release];
    [descriptionText release];
    [categoryDetails release];
    [super dealloc];
}

#pragma mark - View Lifecycles

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

#pragma mark -Populate Information

- (void)populateInformation:(NSMutableDictionary *)info
{
  
    titleText.text = [info objectForKey:@"name"];
    descriptionText.text = [info objectForKey:@"address"];
    categoryDetails.text = [info objectForKey:@"category"];
}
@end
