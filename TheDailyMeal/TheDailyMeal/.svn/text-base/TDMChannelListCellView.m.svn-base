//
//  TDMChannelListCellView.m
//  TheDailyMeal
//
//  Created by Nithin George on 11/01/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMChannelListCellView.h"
#import "TDMChannelDetails.h"

#define CHANNEL_IMAGE_FRAME CGRectMake(2,1,80,85)

@implementation TDMChannelListCellView

@synthesize content;
@synthesize editing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        
    }
    return self;
}

-(void)displayChannelThumbImage:(NSString *)channelImageURL
{
    
    UIImage *thumbImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:channelImageURL]]];
    CGRect rect = CHANNEL_IMAGE_FRAME;
    [thumbImage drawInRect:rect];
    
}

#pragma mark - display View methods

- (void)drawRect:(CGRect)rect {

    
    TDMChannelDetails *channelDetails   = (TDMChannelDetails *)content;
    NSString *channelTitle           = channelDetails.channelTitle;
    NSString *channelDescription     = channelDetails.channelDescription;

    NSArray* channelDate = [channelDetails.channelPubDate componentsSeparatedByString:@"EST"];
    NSString *channelPubDate         = [channelDate objectAtIndex:0];
    [[UIColor blackColor] set];
    [channelTitle drawAtPoint:CGPointMake(90, 5) 
                        forWidth:210 
                        withFont:kGET_BOLD_FONT_WITH_SIZE(15.0f) 
                     minFontSize:15 
                  actualFontSize:NULL 
                   lineBreakMode:UILineBreakModeWordWrap 
              baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    

    //description
    rect = CGRectMake(90, 25,210 
                      , 40);
    [channelDescription drawInRect:rect
                   withFont:kGET_REGULAR_FONT_WITH_SIZE(12.0f)];
    
    
    //PubDate
    [channelPubDate drawAtPoint:CGPointMake(90, 60) 
                            forWidth:300 
                            withFont:kGET_REGULAR_FONT_WITH_SIZE(12.0f) 
                            minFontSize:12 
                            actualFontSize:NULL 
                            lineBreakMode:UILineBreakModeWordWrap 
                            baselineAdjustment:UIBaselineAdjustmentAlignBaselines];

}

- (void)displayCellItems:(id)item{
    
    [content release];
    content = [item retain];
    
    [self setNeedsDisplay];
}


- (void)dealloc
{
    self.content=nil;
    [super dealloc];

}

@end
