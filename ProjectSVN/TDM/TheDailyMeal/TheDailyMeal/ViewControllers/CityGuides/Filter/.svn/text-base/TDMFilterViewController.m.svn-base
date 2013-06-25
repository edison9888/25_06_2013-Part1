//
//  TDMFilterViewController.m
//  TheDailyMeal
//
//  Created by user on 13/01/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMFilterViewController.h"
#import "TDMFilterShared.h"

@implementation TDMFilterViewController
@synthesize backgroundImage;
@synthesize filterTable;
@synthesize CriteriaSearchView;
@synthesize isFilterByRestaurant;
@synthesize lastIndex;
@synthesize guideName;
@synthesize filterDelegate;


#define TOP_RESTAURANT          @"Top Restaurants"
#define TOP_BAR                 @"Best Bars"
#define ONE_NOT_ONE_RESTAURANT  @"101 Best Restaurants"
#define ONE_NOT_ONE_BAR         @"Best Dive Bars"
#define HOT_LIST                @"Hot List"
#define DRINK_HOT_LIST          @"Drink Hot List"
#define CRITERIA_SEARCH         @"Criteria Search"

#define kARRAY_OF_RESTAURANT_FILTER_NAMES [NSArray arrayWithObjects:TOP_RESTAURANT,HOT_LIST,ONE_NOT_ONE_RESTAURANT,CRITERIA_SEARCH,nil]
#define kARRAY_OF_BAR_FILTER_NAMES [NSArray arrayWithObjects:TOP_BAR,DRINK_HOT_LIST,ONE_NOT_ONE_BAR,CRITERIA_SEARCH,nil]

@interface TDMFilterViewController (Private)

- (void)addDataToTheContentArray;
- (void)addCriteriaSearchArray;

@end


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setupNavigationBar
{

    [self.navigationItem hidesBackButton];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Done" forState:UIControlStateNormal];
    //[button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    REMOVE_FROM_MEMORY(item);
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self addCriteriaSearchArray];
    [TDMFilterShared sharedFilterDetails].criteriaCountry =[searchArray objectAtIndex:0];
}

- (void)viewDidUnload
{
    [self setBackgroundImage:nil];
    [self setFilterTable:nil];
    [self setCriteriaSearchView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{

    self.CriteriaSearchView .hidden  = YES;
}


#pragma mark-
- (void)addCriteriaSearchArray
{
    searchArray = [[NSMutableArray alloc] init];
    [searchArray addObject:@"African Restaurant"];
    [searchArray addObject:@"American Restaurant"];
    [searchArray addObject:@"Asian Restaurant"];
    [searchArray addObject:@"Indian Restaurant"];
    [searchArray addObject:@"Autralian Restaurant"];
    
    [self.CriteriaSearchView selectRow:1 inComponent:0 animated:NO];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int rowCount;
    if(isFilterByRestaurant)
    {
        [TDMFilterShared sharedFilterDetails].isARestaurant = YES;
        rowCount = [kARRAY_OF_RESTAURANT_FILTER_NAMES count]-1;
                
    }
    else
    {
        [TDMFilterShared sharedFilterDetails].isARestaurant = NO;
        rowCount = [kARRAY_OF_BAR_FILTER_NAMES count]-1;
    }
    return rowCount + 1;   
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = @"";
    if(isFilterByRestaurant)
    {
        cell.textLabel.text = [kARRAY_OF_RESTAURANT_FILTER_NAMES objectAtIndex:indexPath.row];
        
    }
    else
    {
        cell.textLabel.text = [kARRAY_OF_BAR_FILTER_NAMES objectAtIndex:indexPath.row];

    }
        
    
    return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    



}

- (void)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    
	int presentRow=[indexPath row];
	int oldRow= (self.lastIndex != nil) ? [self.lastIndex row] : -1; //[self.lastIndex row];
	
	if(presentRow!=oldRow)
	{
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndex]; 
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        self.lastIndex = indexPath;	
        NSLog(@"filter text is %@",newCell.textLabel.text);
        guideName = newCell.textLabel.text;
        TDMFilterShared *filterObject = [[TDMFilterShared alloc]init];
        [filterObject initializeFilter:newCell.textLabel.text];
        [filterObject release];
	}
	

    
    if(indexPath.row == [kARRAY_OF_BAR_FILTER_NAMES count] - 1)
    {
        [CriteriaSearchView selectRow:0 inComponent:0 animated:0];
        [TDMFilterShared sharedFilterDetails].isCriteriaSearch =YES;
        self.CriteriaSearchView .hidden  = NO;
    }
    else
    {
        [TDMFilterShared sharedFilterDetails].isCriteriaSearch = NO;
       self.CriteriaSearchView .hidden  = YES;
    }
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark- PickerView Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [TDMFilterShared sharedFilterDetails].criteriaCountry = [searchArray objectAtIndex:row];
    NSLog(@"Criteria for search in filter %@",[TDMFilterShared sharedFilterDetails].criteriaCountry);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [searchArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [searchArray objectAtIndex:row];
}


#pragma mark-


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark- Button Actions


- (void)doneButtonClicked:(id)sender
{
    if(CriteriaSearchView.hidden && ![guideName isEqualToString:@""])
    {
        NSLog(@"API here");
    }
    else
    {
        NSLog(@"Criteria search");
    }
    [[self navigationController] dismissModalViewControllerAnimated:YES];
    [filterDelegate toGetFilterText];
    [self.filterDelegate toGetFilterText];
    if (self.filterDelegate && [self.filterDelegate respondsToSelector:@selector(toGetFilterText)]) 
    {
        NSLog(@"function identified");
    }
}

- (void)dealloc {
    [backgroundImage release];
    [filterTable release];
    [CriteriaSearchView release];
    REMOVE_FROM_MEMORY(searchArray);
    [super dealloc];
}
@end
