//
//  WellSearchAPIHandler.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVBaseAPIHandler.h"

@protocol WellSearchAPIHandlerDelegate <NSObject, RVBaseAPIHandlerDelegate>

@end


@interface WellSearchAPIHandler : RVBaseAPIHandler

- (RVAPIRequestInfo*)getWellNames:(NSString *)text numbrOfRecod:(int)numOfRecod status:(NSString *)status;
- (RVAPIRequestInfo*)getWellDetails :(NSString *)propertyID;
- (RVAPIRequestInfo*)getAfe:(NSString *)propertyID status:(NSString *)status startDate:(NSString *)fromDate endDate:(NSString *)toDate categoryType:(NSString *)category sortFieldType:(NSString *)sortFieldBy sortOrderBy:(NSString*)sortBy pageNum:(int)page limit:(int)lmt;

//- (RVAPIRequestInfo*)getwelDetails;
//- (RVAPIRequestInfo*)getWellNames;

@end
