//
//  TDMChannelDetals.h
//  TheDailyMeal
//
//  Created by Nithin George on 06/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDMChannelDetals : NSObject

{
    NSString * channelTitle;
    NSString * channelLink;
    NSString * channelImageURL;
    NSString * channelDescription;
    NSString * channelPubDate;
}


@property (nonatomic, retain) NSString * channelTitle;
@property (nonatomic, retain) NSString * channelLink;
@property (nonatomic, retain) NSString * channelImageURL;
@property (nonatomic, retain) NSString * channelDescription;
@property (nonatomic, retain) NSString * channelPubDate;


@end
