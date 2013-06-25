    //
//  SecondViewController.m
//  PlistTutorial2
//
//  Created by Kent Franks on 7/18/11.
//  Copyright 2011 TheAppCodeBlog. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

@synthesize tableView;

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	// get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
	
	//array = [[NSMutableArray arrayWithContentsOfFile:plistPath] retain];
	
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    array = [[NSMutableArray alloc]init];
    NSString *name = [temp valueForKey:@"name"];
    [array addObject:name];
    [array addObject:[temp valueForKey:@"last name"]];
    [array addObject:[temp valueForKey:@"address"]];
	[tableView reloadData];
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    return [array count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	
    
    // Configure the cell...
	
	cell.textLabel.text	= [array objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
    [super dealloc];
}


@end
