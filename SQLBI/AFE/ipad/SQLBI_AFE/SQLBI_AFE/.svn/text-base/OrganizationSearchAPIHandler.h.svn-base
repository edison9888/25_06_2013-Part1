//
//  OrganizationSearchAPIHandler.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVBaseAPIHandler.h"

@protocol OrganizationSearchAPIHandlerDelegate <NSObject, RVBaseAPIHandlerDelegate>

@end

@interface OrganizationSearchAPIHandler : RVBaseAPIHandler

- (RVAPIRequestInfo*) getOrganisationTypes;

-(RVAPIRequestInfo*) getOrganisationsForOrgType:(NSString*) orgType;

-(RVAPIRequestInfo*) getHeadlineMetricOfOrganisation:(NSString*) orgID withAFEClassID:(NSString*) afeClassID withStatus:(NSString*) status fromStartDate:(NSString*) startDate toEndDate:(NSString*) endDate;

-(RVAPIRequestInfo*) getAFEClassesOfOrganisation:(NSString*) orgID withStatus:(NSString*) status fromStartDate:(NSString*) startDate toEndDate:(NSString*) endDate sortedBy:(NSString*) sortByField withSortDirection:(AFESortDirection) sortDirection atPageNumber:(int) pageNumber recordLimitPerPage:(int) limit;

-(RVAPIRequestInfo*) getAFEsOfOrganisation:(NSString*) orgID withAFEClass:(NSString*) afeClassID withStatus:(NSString*) status fromStartDate:(NSString*) startDate toEndDate:(NSString*) endDate sortedBy:(NSString*) sortByField withSortDirection:(AFESortDirection) sortDirection atPageNumber:(int) pageNumber recordLimitPerPage:(int) limit;

-(RVAPIRequestInfo*) getAFEsOfOrganisation:(NSString*) orgID withStatus:(NSString*) status fromStartDate:(NSString*) startDate toEndDate:(NSString*) endDate sortedBy:(NSString*) sortByField withSortDirection:(AFESortDirection) sortDirection atPageNumber:(int) pageNumber recordLimitPerPage:(int) limit;


@end
