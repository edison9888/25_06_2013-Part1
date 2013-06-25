//
//  AFEUpdatesAPIHandler.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 19/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVBaseAPIHandler.h"

@protocol AFEUpdatesAPIHandlerDelegate<NSObject, RVBaseAPIHandlerDelegate>

@end


@interface AFEUpdatesAPIHandler : RVBaseAPIHandler

-(RVAPIRequestInfo*) getLatestAppVersionForApplicaitonKey:(NSString*) appKey;

@end
