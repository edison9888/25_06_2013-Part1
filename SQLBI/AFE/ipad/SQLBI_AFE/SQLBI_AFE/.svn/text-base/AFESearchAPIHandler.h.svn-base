//
//  AFESearchAPIHandler.h
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 24/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVBaseAPIHandler.h"

@protocol AFESearchAPIHandlerDelegate<NSObject, RVBaseAPIHandlerDelegate>

@end

@interface AFESearchAPIHandler : RVBaseAPIHandler

-(RVAPIRequestInfo*)getAllAFEs:(NSString *)searchValue withSearchField:(NSString *)nameOrNumber withTopNumberOfRows:(int)topNoOfRows;

-(RVAPIRequestInfo*) getAFEDetailsWithID:(NSString *)afeID;

-(RVAPIRequestInfo*) getAFEBurnDownWithID:(NSString *)afeID;

-(RVAPIRequestInfo*) getAFEBillingCategoryWithID:(NSString *)afeID andSortBy:(NSString *)sortBy withSortOrder:(NSString *) sortingOrder withPageNumber:(int) pageNumber andLimit:(int) limit;

-(RVAPIRequestInfo*) getAFEInvoiceWithBillingCategoryID:(NSString *)billingCategoryID andWithAFEID:(NSString *)afeID andSortBy:(NSString *)sortBy withSortOrder:(NSString *) sortingOrder withPageNumber:(int) pageNumber andLimit:(int) limit;

@end