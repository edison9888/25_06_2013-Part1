//
//  MainCategorySelectorView.m
//  Torq361
//
//  Created by Binoy on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainCategorySelectorView.h"
#import "Constants.h"
#import "CategoryDetails.h"
#import "DatabaseManager.h"
#import "AppTmpData.h"
#import "UserCredentials.h"
#import "TQCategory.h"

@interface MainCategorySelectorView (Private)
//will populate the available categories into the property m_MainCategories
- (void)populateCategories;

@end

@implementation MainCategorySelectorView

@synthesize categories;

int imageIncrement;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self populateCategories];
    self.view.frame = CGRectMake(0, 0, 768, 1004);
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(OrientationDidChange:)
												 name:UIDeviceOrientationDidChangeNotification
											   object:nil];
		
	if([[AppTmpData sharedManager] getDeviceOrientation]) {
		[self setPortrateView];
	}
	else {
		[self setLandscapeView];
	}
	[self setBackgroundImage];
}

//will populate the available categories into the property m_MainCategories
- (void)populateCategories {
    NSMutableArray *array=[[NSMutableArray alloc]init];
    self.categories = array;
    [array release];
    array=nil;
    
    NSMutableArray * availableCategories =[[DatabaseManager sharedManager]getCategoryByParentID:0];
    
    if ([availableCategories count] == 0) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"No Contents to Display" 
                                                      message:@"" 
                                                     delegate:nil 
                                            cancelButtonTitle:@"OK" 
                                            otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [m_objMainCategary setHidden:YES];
        [m_objTableBorderImageView setHidden:YES];
        
    }
    
    for (CategoryDetails * categoryDetails in availableCategories) {
        TQCategory *category = [[[TQCategory alloc] initWithCategoryDetails:categoryDetails] autorelease];
        [self.categories addObject:category];
    }

}


-(void)setPortrateView{
	
	
	self.view.frame=CGRectMake(0, 0, 768, 1004);
    /**********************/
    CGRect rect;
    rect = m_objMainCategary.frame;
    //rect.size.height =524;
    //rect.size.width = 678 ;
    rect.size.height =525;
    rect.size.width = 640 ;
    rect.origin.y=250;//250;
    rect.origin.x=65;//50;
    m_objMainCategary.frame = rect;			
    m_objTableBorderImageView.frame = CGRectMake(rect.origin.x - 30, rect.origin.y - 55, rect.size.width + 60, rect.size.height + 120);
    /**********************/
    
	[self setBackgroundImage];
}


-(void)setLandscapeView {
	
	self.view.frame=CGRectMake(0, 0, 1024, 748);	
	
    CGRect rect;
    rect = m_objMainCategary.frame;
    //rect.size.height =524;
    //rect.size.width = 678 ;
    rect.size.height =525;
    rect.size.width = 640 ;
    rect.origin.y=150;
    rect.origin.x=180;
    m_objMainCategary.frame = rect;			
    m_objTableBorderImageView.frame = CGRectMake(rect.origin.x - 30, rect.origin.y - 55, rect.size.width + 60, rect.size.height + 120);
	
	[self setBackgroundImage];
}



-(void)setBackgroundImage{
	
	
	if(bShowBGImage){
		
		UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"hiding_view_image" ofType:@"png"]];
		
		m_objMainCategoryViewBGImage.image = image;
		
		[image release];
		
		image = nil;
		
		
	}
	else {
		
		m_objMainCategoryViewBGImage.image=nil;
		
	}
	
	
}


-(void)ShowBackgroundImage:(BOOL)bFlag{
	bShowBGImage=bFlag;
}


#pragma mark Table View delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSLog(@"self retain in table row %d",[self retainCount]);

	if([self.categories count]>4) {
		
		return ( ([self.categories count]/4) + (([self.categories count]%4)> 0 ? 1 : 0) );
		
	}
	
	else {
		
		return 1;
		
	}

}

// ugly
-(NSArray*)categoriesForIndexPath:(NSIndexPath*)_indexPath {
    
    int index = (_indexPath.row*4);
    int maxIndex = (_indexPath.row*4+3);
        
    if(maxIndex < [self.categories count]) {
        
        return [NSArray arrayWithObjects:[self.categories objectAtIndex:index],
                [self.categories objectAtIndex:index+1],
                [self.categories objectAtIndex:index+2],
                [self.categories objectAtIndex:index+3],
                nil];
    }
    
    else if(maxIndex-1 < [self.categories count]) {
        
        return [NSArray arrayWithObjects:[self.categories objectAtIndex:index],
                [self.categories objectAtIndex:index+1],
                [self.categories objectAtIndex:index+2],
                nil];
    }
    
    else if(maxIndex-2 < [self.categories count]) {
        
        return [NSArray arrayWithObjects:[self.categories objectAtIndex:index],
                [self.categories objectAtIndex:index+1],
                nil];
    }
    
    else if(maxIndex-3 < [self.categories count]) {
        
        return [NSArray arrayWithObject:[self.categories objectAtIndex:index]];
    }
    
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    CategoryCustomCell *cell = (CategoryCustomCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {		        
        cell = [[[CategoryCustomCell alloc] initWithCategories:[self categoriesForIndexPath:indexPath] reuseIdentifier:CellIdentifier] autorelease];
    }	
    else 
    {		
        [cell setCategories:[self categoriesForIndexPath:indexPath]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark -


	
#pragma mark Button action

-(IBAction)btnClicked:(id)sender{

}
	

-(void)CategoryCustomCellSelected:(int)tag Title:(NSString *)str_Title{
	
	NSLog(@"self retain select %d",[self retainCount]);
	[self mainCategorySelectionAnimation:0 :tag ];
	
}

	 
	 
-(void)mainCategorySelectionAnimation:(int)iChoice :(int)iCategory{		
/*
 
		BrightonAppDelegate *objBrightonAppDelegate=(BrightonAppDelegate *)[UIApplication sharedApplication].delegate;
		 if(iChoice==0){
			 self.view.alpha = 1.0f;		
			 [UIView beginAnimations:nil context:nil];	
			 [UIView setAnimationDuration:1.0];	
			 [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];		
			 //m_objMainCategorySelectionView.hidden=YES;
			 if (bLandscape) {
				 self.view.frame=CGRectMake(35, 35, 0, 0);	
				 //m_objMainCategoryViewBGImage.frame=CGRectMake(35, 35, 0, 0);	
			 }
			 else if (bPortrate) {
				 self.view.frame=CGRectMake(50,50, 0, 0);	
				 //m_objMainCategoryViewBGImage.frame=CGRectMake(50, 50, 0, 0);	
			 }
			 [UIView commitAnimations];
			 [objBrightonAppDelegate hideMainCategorySelection:iCategory];
		 }
		 else {		
			 [UIView beginAnimations:nil context:nil];	
			 [UIView setAnimationDuration:1.0];	
			 [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];			
			 
			 [self.view bringSubviewToFront:self.view];
			 if (bLandscape) {
				 self.view.frame=CGRectMake(0, 0, 1024, 768);
				 //m_objMainCategoryViewBGImage.frame=CGRectMake(0, 0, 1024, 768);
				 //m_objMainCategorySelectionView.frame=CGRectMake(142, 303, 702, 162);
			 }
			 else if (bPortrate) {
				 self.view.frame=CGRectMake(0, 0, 768, 1024);
				 //m_objMainCategoryViewBGImage.frame=CGRectMake(0, 0, 768, 1024);
				 //m_objMainCategorySelectionView.frame=CGRectMake(24, 431, 720, 162);
			 }			
			 
			 [UIView commitAnimations];			
		 }
		
 */
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return TRUE;
}


-(void)OrientationDidChange:(UIDeviceOrientation)orientation{
	
	if ([[AppTmpData sharedManager]getDeviceOrientation]) {
		
        [self setPortrateView];
        //[self setLandscapeView];
	}
	else {
		//[self setPortrateView];
        [self setLandscapeView];
		
	}
	
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

	 

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIDeviceOrientationDidChangeNotification 
                                                  object:nil]; 
	
	[m_objMainCategoryViewBGImage release];
	
	self.categories = nil;
	[m_objMainCategary release];
	categories = nil;
	
	//m_objTableBorderImageView.image = nil;
	//[m_objTableBorderImageView release];
	//m_objTableBorderImageView = nil;

	m_objMainCategary = nil;		
	
	
    [super dealloc];
}


@end
