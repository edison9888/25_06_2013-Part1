//
//  JSONHandler.m
//  MDMagazine
//
//  Created by BittuD on 12/8/10.
//  Copyright 2010 Rapid Value Solutions. All rights reserved.
//

#import "JSONHandler.h"


@implementation JSONHandler

@synthesize delegate;
@synthesize objDictionary;

-(void)sendJSONRequest:(NSMutableDictionary *)requestBody RequestUrl:(NSString *)requestUrl	{
	
	NSLog(@"sendJSONRequest %@",requestBody);
	
	REMOVE_FROM_MEMORY(theRequest)
    theRequest   = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
	
	NSString *strRequestBody=[NSString stringWithFormat:@"data=%@",[requestBody JSONRepresentation]];
	
	NSLog(@"%@",strRequestBody);

    REMOVE_FROM_MEMORY(requestUrl)
	
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPBody:[strRequestBody dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    	
    REMOVE_FROM_MEMORY(theConnection)
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
        
		// receivedData is declared as a method instance elsewhere
		receivedData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
		NSLog(@"Connection Could Not be made");
	}
}

#pragma mark -
#pragma mark connection delegates

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response	{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    //[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	// append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error	{
	
    // release the connection, and the data object
    REMOVE_FROM_MEMORY(theConnection)
    // release the receivedData 
    REMOVE_FROM_MEMORY(receivedData)
	// release the request
    REMOVE_FROM_MEMORY(theRequest)
    
    // inform the user
    NSLog(@"Request Connection failed! Error - %@", [error localizedDescription]);
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection	{
    // do something with the data
	NSLog(@"Request Connection Finish loading...");
	
	NSString *responseString = [[NSString alloc] initWithData:receivedData 
													 encoding:NSASCIIStringEncoding];
	NSLog(@"the responseString:%@",responseString);
	objDictionary =[responseString JSONValue];
	REMOVE_FROM_MEMORY(responseString)
	
	// release the connection, and the data object
    REMOVE_FROM_MEMORY(theConnection)
    REMOVE_FROM_MEMORY(receivedData)
    REMOVE_FROM_MEMORY(theRequest)
    	
	if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didfinishedparsing:)])
		[self.delegate didfinishedparsing:self];
	
}	

@end
