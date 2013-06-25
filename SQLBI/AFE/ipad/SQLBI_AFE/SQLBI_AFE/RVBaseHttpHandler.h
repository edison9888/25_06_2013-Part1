//
//  RVBaseHttpHandler.h
//  SQLandBI
//
//  Created by Runi Kovoor on 18/01/12.
//  Copyright (c) 2012 Rapid Value Solution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVUrlHandler.h"
#import "RVAPIRequestInfo.h"


@protocol RVBaseHttpHandlerDelegate <NSObject>
@required

- (void)requestCompletedSuccessfully:(NSString*) responseData forRequest:(RVAPIRequestInfo*) requestInfoObj;
- (void)requestFailedWithError:(RVAPIResponseStatusCode) errorCode message:(NSString*) errMessage  forRequestType:(RVAPIRequestInfo*) requestInfoObj;

@end



@interface RVBaseHttpHandler : NSObject
{
    NSMutableData *mResponseData;
    NSURLConnection *mURLConnection;
    NSURL * currentRequestURL;
    NSString *dataToPost;
    
}

#pragma mark - Properties

@property (assign, nonatomic) __unsafe_unretained id<RVBaseHttpHandlerDelegate> delegate;
@property (nonatomic, strong, readonly) RVAPIRequestInfo* requestinfo; 

-(id)init;

#pragma Mark - Methods
- (void)getRequest:(NSString*)strAPIName withParams:(NSDictionary *)params  withRequestInfo:(RVAPIRequestInfo*)requestInfoObj;

- (void)getRequest:(NSString*)strAPIName withParamString:(NSString *)param  withRequestInfo:(RVAPIRequestInfo*)requestInfoObj;

- (void)postRequest:(NSString*)strAPIName withParamString:(NSString *)param  withRequestInfo:(RVAPIRequestInfo*)requestInfoObj;

-(void) cancelHttpRequest;



@end
