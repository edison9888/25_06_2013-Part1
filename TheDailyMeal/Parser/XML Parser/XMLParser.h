//
//  XMLParser.h
//  TheDailyMeal
//
//  Created by Nithin George on 06/01/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "TDMChannelDetails.h"

@protocol parseData <NSObject>

-(void) didFinished:(NSMutableArray *)channels;
-(void) didFailedWithError;


@end

@interface XMLParser : NSObject <NSXMLParserDelegate> {
    
    TDMChannelDetails *channelDetails;
    
    id <parseData> myDelegate;
    
    NSMutableArray *stories;
    
    NSXMLParser * rssParser;
    
    NSString * currentElement;
	NSMutableString * currentTitle, * currentLink, * currentDescription, * currentPubDate;
    
}

@property (nonatomic, retain) id <parseData> myDelegate;

@property (nonatomic,retain) TDMChannelDetails *channelDetails;


- (void)parseXMLFileAtURL:(NSString *)URL;

@end
