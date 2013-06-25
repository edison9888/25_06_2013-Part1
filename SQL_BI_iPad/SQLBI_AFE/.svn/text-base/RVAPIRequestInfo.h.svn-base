//
//  RVAPIRequestInfo.h
//  SQLandBI
//
//  Created by Runi Kovoor on 18/01/12.
//  Copyright (c) 2012 Rapid Value Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RVBaseAPIHandler;

@interface RVAPIRequestInfo : NSObject
{
    RVAPIRequestType requestType;
    RVAPIResponseStatusCode statusCode;
    NSString *errorMessage;
    id resultObject;
    RVBaseAPIHandler *gvAPIHandler;
}

@property(nonatomic, strong) RVBaseAPIHandler *gvAPIHandler;
@property(nonatomic, assign) RVAPIRequestType requestType;
@property(nonatomic, assign) RVAPIResponseStatusCode statusCode;
@property(nonatomic, strong) NSString *statusMessage;
@property(nonatomic, strong) id resultObject;
@property(nonatomic, assign) __unsafe_unretained id tag;

-(void) cancelAPIRequest;

@end
