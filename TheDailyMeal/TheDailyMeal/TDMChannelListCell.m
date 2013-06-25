//
//  TDMChannelListCell.m
//  TheDailyMeal
//
//  Created by Nithin George on 11/01/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMChannelListCell.h"
#import "TDMAsyncImage.h"
#import "TDMChannelDetails.h"

@implementation TDMChannelListCell
@synthesize channelListCellView;


#define CHANNEL_IMAGE_FRAME CGRectMake(2,1,80,85)
#define DEFAULT_THUMBNAIL_IMAGE @"business1.png"
#define ASYNC_IMAGE_TAG 9999
#define DEFAULT_IMAGE_TAG 888

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect tzvFrame     = CGRectMake(0.0, 0.0, 
                                         self.contentView.bounds.size.width,
                                         self.contentView.bounds.size.height-1);
        channelListCellView  = [[TDMChannelListCellView alloc] initWithFrame:tzvFrame];
        channelListCellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        channelListCellView.backgroundColor = [UIColor clearColor];

        [self addSubview:channelListCellView];
        
        [channelListCellView release];

        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // for cell click effect.
        backgroundImageView         = [[UIImageView alloc] initWithImage:nil];
        backgroundImageView.frame   = CGRectMake(0.0, 0.0, 
                                                 self.contentView.bounds.size.width,
                                                 90);
        [self addSubview:backgroundImageView];
        
                
    }
    return self;
}

-(void)showImageFromURL:(TDMChannelDetails *)channelDetails {

    
    TDMAsyncImage * asyncImageView = (TDMAsyncImage *)[self viewWithTag:ASYNC_IMAGE_TAG];
    if(!asyncImageView){
        asyncImageView = [[[TDMAsyncImage alloc] init] autorelease];
        asyncImageView.tag=ASYNC_IMAGE_TAG;
        asyncImageView.frame=CHANNEL_IMAGE_FRAME;
        
        [self addSubview:asyncImageView]; 
                
    }
    
    if (!channelDetails.channelIcon)
    {
        NSString *urlpath = channelDetails.channelImageURL;
        if (!([urlpath isKindOfClass:[NSNull class]] )) {
            if(urlpath) {
                NSURL *url = [[NSURL alloc] initWithString:urlpath];
                [asyncImageView loadImageFromURL:url isFromHome:YES];
                [asyncImageView setChannelDetail:channelDetails];
                [url release];
                url = nil;
            }
        }
        else
            NSLog(@"NULL VALUE");
    }
    else
    {
        [asyncImageView loadExistingImage:channelDetails.channelIcon];
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // for cell click effect.
    if (selected) {
        [backgroundImageView setBackgroundColor:[UIColor lightGrayColor]];
        [backgroundImageView setAlpha:0.5];
    }
    else    {
        [backgroundImageView setBackgroundColor:[UIColor clearColor]];
    }
}

#pragma mark cell dispay


- (void)displayCellItems:(id)item
{
    TDMAsyncImage * asyncImageView = (TDMAsyncImage *)[self viewWithTag:ASYNC_IMAGE_TAG];
    if(asyncImageView){
        
        [asyncImageView removeFromSuperview];
    }
      
    TDMChannelDetails *channelDetails   = (TDMChannelDetails *)item;
    
    [self showImageFromURL:channelDetails];
       
    [channelListCellView displayCellItems:item];

}

-(void)showDefaultImage {
    
    UIImageView *imageThumbnail=[[UIImageView alloc]init];
    imageThumbnail.frame=CHANNEL_IMAGE_FRAME;
    imageThumbnail.backgroundColor=[UIColor clearColor];
    imageThumbnail.image=[UIImage imageNamed:DEFAULT_THUMBNAIL_IMAGE]; 
    [imageThumbnail setContentMode:UIViewContentModeScaleAspectFit];
    imageThumbnail.tag  = DEFAULT_IMAGE_TAG;
    [channelListCellView addSubview:imageThumbnail];
    [imageThumbnail release];
    imageThumbnail=nil;
}

- (void)dealloc
{
    [backgroundImageView release];
    [super dealloc];
}

@end
