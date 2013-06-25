//
//  HomeViewController.h
//  PE
//
//  Created by Nithin George on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController {// <XMLParserDelegate1> {
    
    IBOutlet UITableView *gridView;
    
    NSMutableArray *homeSectionItems;
}

//@property(nonatomic,retain)NSMutableArray *homeSectionItems;

- (void)createCustomNavigationLeftButton;
- (void)loadHomeisplayArray;

//Reading data from the main table for displaying the home items
- (NSMutableArray *)readHomeSectionItems:(int)index;

@end
