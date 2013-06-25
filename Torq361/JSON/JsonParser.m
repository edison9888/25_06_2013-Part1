//
//  JsonParser.m
//  Brighton
//
//  Created by Timmi on 08/06/10.
//  Copyright 2010 RVS. All rights reserved.
//

#import "JsonParser.h"


@implementation JsonParser
@synthesize delegate;
@synthesize objResult;

-(void)parseJSONResponseofAPI:(NSString *)strAPIName JSONRequest:(id)objJSONRequestData{	
		
	NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strAPIName]];
	
	NSString* jsonString = [objJSONRequestData JSONRepresentation];
	
	[request setHTTPMethod:@"POST"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];	
	[request setTimeoutInterval:60];
	[request setHTTPBody:[jsonString dataUsingEncoding:NSASCIIStringEncoding]];
	
	
	obj_URLConnection= [[NSURLConnection alloc]initWithRequest:request delegate:self];
	
	[request release];
	if (obj_URLConnection) {
		m_objResponseData = [[NSMutableData data] retain];  
	}	
		
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[m_objResponseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[m_objResponseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	@try {
		
		m_bIsSuccess=NO;
		[m_objResponseData release];
		m_objResponseData=nil;
		[m_objRequest release];
		m_objRequest=nil;
		[connection release];
		
		if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didfailedwitherror:)])
			[self.delegate didfailedwitherror:self];
	}
	@catch (NSException * e) {
		
	}
	@finally {
		
	}
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {		
	
	@try {
		
		[connection release];
		[m_objRequest release];
		m_objRequest=nil;
		
		m_strResponseString = [[NSString alloc] initWithData:m_objResponseData encoding:NSUTF8StringEncoding];
		[m_objResponseData release];
		m_objResponseData=nil;			
		
		NSError *error;
		SBJSON *objSBJSON = [[SBJSON alloc] init];
		objResult = [objSBJSON objectWithString:m_strResponseString error:&error];
		[m_strResponseString release];	
		
		if (objResult == nil){			
			m_bIsSuccess=NO;
		}
		else {				
			m_bIsSuccess=YES;			
		}
		[objSBJSON release];
		objSBJSON=nil;		
			
		
		if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didfinishedparsing:)])
			[self.delegate didfinishedparsing:self];
	}
	@catch (NSException * e) {
		NSLog(@"%@", e);

		
	}
	@finally {
		
	}
}



-(void)dealloc{
	//[obj_URLConnection release];
	[super dealloc];
}
@end
