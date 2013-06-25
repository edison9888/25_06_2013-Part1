//
//  JsonParser.h
//  Brighton
//
//  Created by Timmi on 08/06/10.
//  Copyright 2010 RVS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@class JsonParser;
@protocol JsonParserDelegate<NSObject>

-(void)didfinishedparsing:(JsonParser *)objJsonParser;
-(void)didfailedwitherror:(JsonParser *)objJsonParser;

@end



@interface JsonParser : NSObject {

	id<JsonParserDelegate>delegate;
	
	BOOL m_bIsSuccess;	
	NSString *m_strResponseString;
	int m_iAcceptType;	
	NSURLConnection *obj_URLConnection;
	NSMutableData *m_objResponseData;
	NSMutableURLRequest *m_objRequest;
	NSMutableDictionary *objResult;
}

@property(nonatomic,retain) id<JsonParserDelegate>delegate;
@property(nonatomic,retain) NSMutableDictionary *objResult;
-(void)parseJSONResponseofAPI:(NSString *)strAPIName JSONRequest:(id)objJSONRequestData;

@end
