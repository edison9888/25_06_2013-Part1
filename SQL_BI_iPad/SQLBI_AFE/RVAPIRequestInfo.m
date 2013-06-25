//
//  RVAPIRequestInfo.m
//  SQLandBI
//
//  Created by Runi Kovoor on 18/01/12.
//  Copyright (c) 2012 Rapid Value Solution. All rights reserved.
//

#import "RVAPIRequestInfo.h"
#import "RVBaseAPIHandler.h"

@implementation RVAPIRequestInfo

@synthesize requestType, statusCode, statusMessage, gvAPIHandler, resultObject, tag;

-(void)cancelAPIRequest
{
    if(self.gvAPIHandler)
    {
        if([self.gvAPIHandler respondsToSelector:@selector(cancelAPIRequestWithRequestInfo:)])
        {
            [self.gvAPIHandler cancelAPIRequestWithRequestInfo:self];
        }
    }
       
}

-(void) dealloc
{
    resultObject = nil;
    gvAPIHandler = nil;
    statusMessage = nil;
    
}

@end
