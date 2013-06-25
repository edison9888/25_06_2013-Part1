//
//  TDMFavoritesCustomCell.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 23/02/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMFavoritesCustomCell.h"
#import "TDMAsyncImage.h"

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
    TDMAsyncImage * asyncImageView = [[[TDMAsyncImage alloc]initWithFrame:CGRectMake(9, 4, 64, 64)] autorelease];
    [self addSubview:asyncImageView]; 
    asyncImageView.tag = 10;     
    NSString *urlpath = [info objectForKey:@"image"];
    if (!([urlpath isKindOfClass:[NSNull class]])) 
    {
        if(urlpath) {
            
            NSURL *url = [[NSURL alloc] initWithString:urlpath];
            [asyncImageView loadImageFromURL:url isFromHome:YES];
            [url release];
            url = nil;
        }
    }

    
}
@end
