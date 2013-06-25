//
//  SectionViewController.h
//  PE
//
//  Created by God bless you... on 26/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionViewController : UIViewController {
    
    NSMutableArray *sectionItems;
    
    //For storing the home selection buttonID
    int sectionID;
    
    NSString *selectedCasinosName;
    
    IBOutlet UITableView *listView;
}

@property(nonatomic) int sectionID; 


- (void)createCustomNavigationBackButton;

- (void)backButtonClicked:(id)sender;

- (void)createCustomNavigationLeftButton;

//For reading sub section items
- (NSMutableArray *)readSubSectionItems:(int)index;

@end
