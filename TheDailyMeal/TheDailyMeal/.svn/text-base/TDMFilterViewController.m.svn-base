//
//  TDMFilterViewController.m
//  TheDailyMeal
//
//  Created by user on 13/01/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMFilterViewController.h"
#import "AppDelegate.h"
#import "TDMDataStore.h"


@implementation TDMFilterViewController
@synthesize backgroundImage;
@synthesize filterTable;
@synthesize CriteriaSearchView;
@synthesize isFilterByRestaurant;
@synthesize lastIndex;
@synthesize guideName;
@synthesize filterDelegate;
@synthesize lastIndexAfterDone;
@synthesize criteriaSearch;


#define TOP_RESTAURANT          @"Top Restaurants"
#define ONE_NOT_ONE_RESTAURANT  @"101 Best Restaurants"
#define CHEAP_EATS              @"Cheap Eats"
#define TOP_BAR                 @"Best Bars"
#define ONE_NOT_ONE_BAR         @"Best Dive Bars"
#define DRINK_HOT_LIST          @"Drink Hot List"
#define HOT_LIST                @"Hot List"
#define CRITERIA_SEARCH         @"Criteria Search"
#define FILTER_ARRAY [NSArray arrayWithObjects: TOP_RESTAURANT,ONE_NOT_ONE_RESTAURANT,CHEAP_EATS,TOP_BAR,ONE_NOT_ONE_BAR,DRINK_HOT_LIST,HOT_LIST,CRITERIA_SEARCH,nil]

@interface TDMFilterViewController (Private)

- (void)addDataToTheContentArray;
- (void)addCriteriaSearchArray;

@end


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTDMIconImage];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)setupNavigationBar {
    
    [self.navigationItem setTDMIconImage];
    [self.navigationItem hidesBackButton];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 60, 30);
//    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
//    [button setTitle:@"Done" forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"accountButtonImage.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = item;
//    REMOVE_FROM_MEMORY(item);
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.filterTable.backgroundColor = [UIColor clearColor];
    [self createNavigationBarButtonOfType:kBACK_BAR_BUTTON_TYPE];
    [self setupNavigationBar];
    [self addCriteriaSearchArray];
    [self createAdView];
    guide = @"Top Restaurants";
    sectionCount =1;
}

- (void)viewDidUnload {
    [self setBackgroundImage:nil];
    [self setFilterTable:nil];
    [self setCriteriaSearchView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if(!self.lastIndex) {
        self.lastIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    if(!self.lastIndexAfterDone) {
        self.lastIndexAfterDone = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    if(self.lastIndexAfterDone.section == 0) {
        sectionCount=1;
    }
    else {
            sectionCount =2;
    }
    self.CriteriaSearchView .hidden  = YES;
    self.criteriaSearch = NO;
    [self.filterTable reloadData];
}

#pragma mark-
- (void)addCriteriaSearchArray {
    searchArray = [[NSMutableArray alloc] init];
    
    [searchArray addObject:@"African Restaurant"];
    [searchArray addObject:@"American Restaurant"];
    [searchArray addObject:@"Asian Restaurant"];
    [searchArray addObject:@"Indian Restaurant"];
    [searchArray addObject:@"Australian Restaurant"];
    
    [self.CriteriaSearchView selectRow:1 inComponent:0 animated:NO];
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       
    if(section == 0) {
        
     return [FILTER_ARRAY count];
    }
    else {
        
        return [searchArray count];
    }

}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    for(UIView *cellView in [cell.contentView subviews])
    {
        [cellView removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    if(indexPath.section==0) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 10.0, 200, 21)];
        label.textColor = [UIColor colorWithRed:0.468 green:0.468 blue:0.468 alpha:1.0];
        label.font = [UIFont fontWithName:kFONT_BOLD size:18.0];
        label.text = [FILTER_ARRAY objectAtIndex:indexPath.row];
        [cell.contentView addSubview:label];
        [label release];
    }
    else if(indexPath.section == 1) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 10.0, 200, 21)];
        label.textColor = [UIColor colorWithRed:0.468 green:0.468 blue:0.468 alpha:1.0];
        label.font = [UIFont fontWithName:kFONT_BOLD size:18.0];
        label.text = [searchArray objectAtIndex:indexPath.row];
        [cell.contentView addSubview:label];
        [label release];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if([self.lastIndex isEqual:indexPath])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.backgroundColor=[UIColor whiteColor];    
        return cell; 
}

- (void)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    self.criteriaSearch = NO;
    if(indexPath.section==0) {       

        if(sectionCount == 2)
        {
            sectionCount = 1;
            [self.filterTable reloadData];
        }
        sectionCount=1;
        if(indexPath.row != [FILTER_ARRAY count]-1) {
            guide = [FILTER_ARRAY objectAtIndex:indexPath.row];
            [TDMDataStore sharedStore].isCriteriaSearch  =NO;
        }
        else {
            sectionCount =2;
            [self.filterTable reloadData];
            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:3 inSection:1];
            [self.filterTable scrollToRowAtIndexPath:indexpath 
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:YES];
            indexpath=[NSIndexPath indexPathForRow:0 inSection:1];
        }
        if(indexPath.row == [FILTER_ARRAY count]-1)
        {
            guide = [TDMDataStore sharedStore].guideType;
            self.criteriaSearch = YES;
        }
    }
    else if(indexPath.section==1) {
        
        guide =[searchArray objectAtIndex:indexPath.row];
        [TDMDataStore sharedStore].isCriteriaSearch = YES;
    }
    if(!([self.lastIndex isEqual:indexPath])) {
        
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
         
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndex];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.lastIndex = indexPath;
    
    if(!self.criteriaSearch)
    {
        if(guide) {
            [TDMDataStore sharedStore].guideType = guide;
        }
        else {
            [TDMDataStore sharedStore].guideType = @"Top Restaurants";
        }
        self.lastIndexAfterDone = self.lastIndex;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate selectTabItem:4];
    }
    
    
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];    
    
}

#pragma mark-

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark- Button Actions

//- (void)doneButtonClicked:(id)sender
//{
//    if(!self.criteriaSearch)
//    {
//        if(guide) {
//            [TDMDataStore sharedStore].guideType = guide;
//        }
//        else {
//            [TDMDataStore sharedStore].guideType = @"Top Restaurants";
//        }
//        self.lastIndexAfterDone = self.lastIndex;
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [appDelegate selectTabItem:4];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:TDM_TITLE message:@"Please Select Your Search Criteria" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//        alert = nil;
//    }
//}
- (void)navBarButtonClicked:(id)sender  {
    if(self.lastIndexAfterDone) {
        self.lastIndex = self.lastIndexAfterDone;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    
    [backgroundImage release];
    [filterTable release];
    [CriteriaSearchView release];
    REMOVE_FROM_MEMORY(searchArray);
    [super dealloc];
}
@end
