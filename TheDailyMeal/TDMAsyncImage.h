//
//  RBAsyncImage.h
//  Red Beacon
//
//  Created by sudeep on 06/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMChannelDetails.h"

@interface TDMAsyncImage : UIView {
    
    
	NSURLConnection* connection;
	NSMutableData* data;
	SEL onReady;
	id target;
	
    TDMChannelDetails *channelDetail;
}

@property (assign) SEL onReady;
@property (assign) id target;

@property (nonatomic, retain) TDMChannelDetails *channelDetail;

-(void)showVideoIcon;
- (void)loadImageFromURL:(NSURL*)url isFromHome:(BOOL)isHome;
-(void)loadExistingImage:(UIImage *)image;
@end
