//
//  SubCategoryPopOver.h
//  Torq361
//
//  Created by Nithin George on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//**************************************************************

#import <UIKit/UIKit.h>
//#import "PopOverCustomeCell.h"

@interface SubCategoryPopOver : UIViewController {
	
	IBOutlet UILabel *topTitle;
	IBOutlet UITableView *popTable;
	IBOutlet UIButton *doneButton;
	
    NSMutableArray *selectedCategory;  //coping the content of the left navigation array to selectedcategory array

    NSMutableArray *selectedStatusArray;	

	NSMutableArray *tempArray;
    
    NSMutableArray *prevSelectedCategory;
	
    int iTableDataSel;

    BOOL bSelectAll;	//for knowing whether the all category is selected or not
}

@property (nonatomic,retain)NSMutableArray *prevSelectedCategory;

//method decleration for 'Done' Button

-(IBAction)DoneButtonClick:(id)sender;

- (void)selectAllBtnClicked;	//for setting the all array field as YES

-(void)selectNoneBtnClicked;	//for setting the all array field as NO

-(void)checkPreviouslySelectedItems;

@end
