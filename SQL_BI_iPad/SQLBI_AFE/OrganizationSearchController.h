//
//  OrgSearchController.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFEListView.h"
#import "OrganizationSearchAPIHandler.h"

@class OrganizationSearchController;

@protocol OrganizationSearchControllerDelegate <NSObject>

-(void) searchWithDataOrganizationType:(NSString *)orgType organizationID:(NSString *)orgID status:(NSString *)orgStatus begingDate:(NSString *)beginDate endDate:(NSString *)endDate;

-(void) didFailAutoSearchOnSearchController:(OrganizationSearchController*) controller;

@end

@interface OrganizationSearchController : UIViewController<AFEListViewDelegate, OrganizationSearchAPIHandlerDelegate>
{
    IBOutlet UILabel *staticOrgType;
    IBOutlet UILabel *staticOrgName;
    IBOutlet UILabel *staticOrgStatus;
    IBOutlet UILabel *staticOrgBeginDate;
    IBOutlet UILabel *staticOrgEndDate;

}

@property(nonatomic, assign) __unsafe_unretained id <OrganizationSearchControllerDelegate> delegate;
- (IBAction)searchButtonClicked:(id)sender;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *searchButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *organizationButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *organizationNameButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *statusButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *beginDateButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *endDateButton;
@property (nonatomic, readonly, assign) BOOL isAutoSearchRunning;

-(void) autoSearchWithDefaultValues;

@end
