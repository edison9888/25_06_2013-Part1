//
//  SearchViewController_AFE.h
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFEListView.h"
#import "AFESearchAPIHandler.h"

@protocol SearchViewControllerAFEDelegate <NSObject>

- (void)searchWithDataAFEID:(NSString *)afeID;

@end

@interface SearchViewController_AFE : UIViewController<AFEListViewDelegate , AFESearchAPIHandlerDelegate>

@property (nonatomic, assign) __unsafe_unretained id <SearchViewControllerAFEDelegate> delegate;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITextField *afenumberField;
@property (strong, nonatomic) IBOutlet UITextField *afenameField;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *orLabel;

- (IBAction)searchButtonClicked:(id)sender;
- (IBAction)textFieldValueChanged :(UITextField*)sender;
-(IBAction)touchedBkrgnd;

@end
