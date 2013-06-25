//
//  ListViewController.h
//  PE
//
//  Created by Nithin George on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface ListViewController : UIViewController <UISearchBarDelegate,UITableViewDelegate,GADBannerViewDelegate,UITableViewDataSource> {
    
    int homeSelectionID; //For storing the parentid of menu table
    int selectedButtonID;//For storing the parentid of list table
    int selectedIndex;   //for identifing the tab bar selection from aminity list or from tabbar
    
    NSMutableArray *listItems;///will be storing all the data(For storing the list details)
    NSMutableArray *tableData; //will be storing data that will be displayed in table
    
    UITableView *listView;
    UISearchBar *searchBar;//search bar
    
    
    NSString *selectedCasinosName;
    NSString *selectedAminityName;
    
    GADBannerView *bannerView_;//For displaying admob
    UILabel *emptySearchResult;
}

@property(nonatomic)int homeSelectionID;
@property(nonatomic)int selectedButtonID;

@property(nonatomic,retain)NSString *selectedCasinosName;

- (void)getSearchBArDisplayText;
- (void)addNoSearchResultLabel;
- (void)addSearchBar;
- (void)loadDisplayContentArray;
- (void)showTabBarView;
- (void)playAdmob;
- (void)createCustomNavigationLeftButton;

- (void)manualDownload:(int)index;
- (void)startSync;

//Reading the list array
- (NSMutableArray *)readListViewItems:(int)index;
@end
