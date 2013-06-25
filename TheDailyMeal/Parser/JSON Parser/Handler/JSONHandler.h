//
//  JSONHandler.h
//  MDMagazine
//
//  Created by BittuD on 12/8/10.
//  Copyright 2010 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSON.h"

#define DEVICE_IDENTIFIER [[UIDevice currentDevice] uniqueIdentifier];

@class JSONHandler;
@protocol JsonParserDelegate<NSObject>
@optional
-(void)didfinishedparsing:(JSONHandler *)objJsonHandler;
-(void)didfailedwitherror:(JSONHandler *)objJsonHandler;

@end


@interface JSONHandler : NSObject {
	
	id<JsonParserDelegate>delegate;
	
	NSMutableData		*receivedData;
	NSMutableURLRequest	*theRequest;
	NSURLConnection		*theConnection;

	NSMutableDictionary *objDictionary;
}

@property (nonatomic,retain) NSMutableDictionary *objDictionary;
@property (nonatomic,retain) id<JsonParserDelegate>delegate;

#pragma mark JSON handles
-(void)sendJSONRequest:(NSMutableDictionary *)requestBody RequestUrl:(NSString *)requestUrl;

@end
