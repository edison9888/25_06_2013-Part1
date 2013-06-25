//
//  AFEsTableViewController.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 05/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFEsTableViewController : UIView<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView* afeTableView;
    IBOutlet UILabel* afeNameHeaderLabel;
    IBOutlet UILabel* afeClassHeaderLabel;
    IBOutlet UILabel* afeBudgetHeaderLabel;
    IBOutlet UILabel* afeFieldEstimateHeaderLabel;
    IBOutlet UILabel* afeActualsHeaderLabel;
}

@property(nonatomic, strong) NSArray *afeArray;

//-(id) initWithAFEArray:(NSArray*) afeArrayToBeUsed;

-(void) refreshDataWithAFEArray:(NSArray*) afeArrayToUse;

@end
