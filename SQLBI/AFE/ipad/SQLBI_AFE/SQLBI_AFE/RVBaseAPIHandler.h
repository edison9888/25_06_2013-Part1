//
//  RVBaseAPIHandler.h
//  SQLandBI
//
//  Created by Runi Kovoor on 18/01/12.
//  Copyright (c) 2012 Rapid Value Solution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVURLHandler.h"
#import "RVBaseHttpHandler.h"
#import "JSON.h"
#import "RVAPIRequestInfo.h"


@protocol RVBaseAPIHandlerDelegate <NSObject>

- (void) rvAPIRequestCompletedSuccessfullyForRequest:(RVAPIRequestInfo*) requestInfoObj;
- (void) rvAPIRequestCompletedWithErrorForRequest:(RVAPIRequestInfo*) requestInfoObj;

@end

@interface RVBaseAPIHandler : NSObject <RVBaseHttpHandlerDelegate>
{
    //This is used to handle the case where the view controller creates an RVBaseAPIHandler
    //object and decides to make multiple API requests with the same RVBaseAPIHandler object.
    //So *baseHttpHandlersArray keeps track of all the http request it has made.
    NSMutableArray *baseHttpHandlersArray;
}

@property(nonatomic, assign) __unsafe_unretained id<RVBaseAPIHandlerDelegate> delegate;

//Override this method in subclasses to parse the response from server
-(void) didReceiveResponseFromServer:(NSString*) responseData forRequest:(RVAPIRequestInfo*) requestInfoObj;

- (RVAPIRequestInfo*) getStatusTypes;

#pragma mark - API request related methods

-(void) cancelAPIRequestWithRequestInfo:(RVAPIRequestInfo *) requestInfo;


@end
