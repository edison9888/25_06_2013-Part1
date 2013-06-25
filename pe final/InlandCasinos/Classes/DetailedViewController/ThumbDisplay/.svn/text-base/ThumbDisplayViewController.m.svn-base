//
//  ThumbDisplayViewController.m
//  PE
//
//  Created by Nithin George on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThumbDisplayViewController.h"
#import "ThumbGridCell.h"
#import "MWPhotoBrowser.h"


@implementation ThumbDisplayViewController

@synthesize imagePaths;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Story of Photos";
    // Do any additional setup after loading the view from its nib.
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath	{
	// Return the height of rows in the section.
	return 110;//125;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([imagePaths count]%THUMB_COL_COUNT==0) {
        
        return ([imagePaths count]/THUMB_COL_COUNT);
    }
    
    else {
        
        return ([imagePaths count]/THUMB_COL_COUNT)+1;
    }
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    ThumbGridCell *cell = (ThumbGridCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[ThumbGridCell alloc] init] autorelease];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell displayCellItems:[self readHomeSectionItems:indexPath.row*THUMB_COL_COUNT]];
	// Configure the cell.
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic may go here. Create and push another view controller.	
	
}

#pragma mark -
#pragma mark Home Section Items

- (NSMutableArray *)readHomeSectionItems:(int)index {
    
    NSMutableArray *secions = nil;
    
    if ([imagePaths count] > 0) {
        
        secions=[[[NSMutableArray alloc]init] autorelease];
        for(int item=index ,col=0;item<[imagePaths count];item++,col++){
            if (col<THUMB_COL_COUNT) 
                [secions addObject:[imagePaths  objectAtIndex:item]];
            else
                break;
        }
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YOur Message" message:@"In home screen array count is zero"
                                                       delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        [alert release];
        //[self loadHomeisplayArray];
        //[gridView reloadData];
    }
    return secions;
}


#pragma mark - Button Events

- (void)sectionButtonPresssed:(UIButton *)section {
    
    UIButton *button = (UIButton *)section;
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    [photos addObject:[imagePaths objectAtIndex:button.tag]];
    
    for (int startvalue = 0; startvalue<[imagePaths count]; startvalue++) {
        
        if (startvalue != button.tag) {
            
          [photos addObject:[imagePaths objectAtIndex:startvalue]];  
        }
    }
    
    //self.navigationItem.title = IMAGE_DISPLAY_NAV_BACK_TITTLE;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
    [self.navigationController pushViewController:browser animated:YES];
    [browser release];
    [photos release];
}

- (void)dealloc
{
    [super dealloc];
    [self.imagePaths release];
    self.imagePaths = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
