//
//  HomeListCustomCell.m
//  Torq361
//
//  Created by Binoy on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeListCustomCell.h"

#import "Torq361AppDelegate.h"
#import "Home.h"

@implementation HomeListCustomCell

@synthesize photoFrameImage1, thumbnailImage1, newBannerImage1, selectButton1, productName1, description1, activityIndicator1;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

#pragma mark -
#pragma mark Button Action

-(IBAction)productSelectionButtonClicked:(id)sender {
	
	UIButton *clickedButton = sender;
	
	Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
	
	[appDelegate.home selectedProductWithArrayIndex:clickedButton.tag];
}

#pragma mark -



- (void)dealloc {
	
	[photoFrameImage1 release];
	[thumbnailImage1 release];
	[newBannerImage1 release];
	[selectButton1 release];
	[productName1 release];
	[description1 release];
	[activityIndicator1 release];
	
    [super dealloc];
}


@end
