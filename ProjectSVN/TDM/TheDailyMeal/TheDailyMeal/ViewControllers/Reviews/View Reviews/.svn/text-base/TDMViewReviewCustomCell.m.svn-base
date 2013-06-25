//
//  TDMViewReviewCustomCell.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 21/02/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMViewReviewCustomCell.h"

@implementation TDMViewReviewCustomCell
@synthesize reviewImage;
@synthesize reviewTitle;
@synthesize reviewDescription;

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

    // Configure the view for the selected state
}

- (void)dealloc 
{
    [reviewImage release];
    [reviewTitle release];
    [reviewDescription release];
    [super dealloc];
}

- (void)populateInformation:(NSMutableDictionary *)info
{
    reviewImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[info objectForKey:@"image"] ofType:@"png"]];
    reviewTitle.text = [info objectForKey:@"title"];
    reviewDescription.text = [info objectForKey:@"description"];
}
@end
