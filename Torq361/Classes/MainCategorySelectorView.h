//
//  MainCategorySelectorView.h
//  Torq361
//
//  Created by Binoy on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CategoryCustomCell.h"

@interface MainCategorySelectorView : UIViewController {
	
	BOOL bShowBGImage;
	
	NSMutableArray * categories;
	
	IBOutlet UITableView *m_objMainCategary;		
	IBOutlet UIImageView *m_objMainCategoryViewBGImage;
	IBOutlet UIImageView *m_objTableBorderImageView;
	
	
}
@property(nonatomic, retain) NSMutableArray * categories;

-(void)mainCategorySelectionAnimation:(int)iChoice :(int)iCategory;
-(void)ShowBackgroundImage:(BOOL)bFlag;
-(void)setPortrateView;
-(void)setLandscapeView;
-(void)setBackgroundImage;

@end
