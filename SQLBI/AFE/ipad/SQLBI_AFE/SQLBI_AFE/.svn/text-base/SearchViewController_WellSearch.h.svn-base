//
//  SearchViewController_WellSearch.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 14/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFEListView.h"
#import "WellSearchAPIHandler.h"
@protocol SearchViewControllerWellSearchDelegate <NSObject>

- (void)searchWithDataWellCompltnName:(NSString *)wellCompltnName withStatus:(NSString *)status withfromDate:(NSString*)startDate withTodate:(NSString *)endDate withPropertyID:(NSString*)protyID;

@end

@interface SearchViewController_WellSearch : UIViewController < AFEListViewDelegate,RVBaseAPIHandlerDelegate >

@property (nonatomic, assign)  id <SearchViewControllerWellSearchDelegate,WellSearchAPIHandlerDelegate> delegate;
-(IBAction)textFieldValueChanged:(UITextField *)sender;
-(IBAction)touchedBkrnd;

@end
