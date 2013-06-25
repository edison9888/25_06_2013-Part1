    //
//  SubCategoryPopOver.m
//  Torq361
//
//  Created by Nithin George on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubCategoryPopOver.h"
#import "Home.h"
#import "Torq361AppDelegate.h"
#import "PopOverCustomeCell.h"
#import "DatabaseManager.h"
#import "AppTmpData.h"
#import "CategoryDetails.h"


@implementation SubCategoryPopOver

@synthesize prevSelectedCategory;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
   
	[super viewDidLoad];
	//iTableDataSel=0;
	
	if(iTableDataSel==0){
		topTitle.text=@"Sub Category";
		selectedCategory=[[NSMutableArray alloc] init];
		
		[selectedCategory addObject:@"Select All"];
		
		//NSMutableArray *tmpArr1=[[DatabaseManager sharedManager]getCategory:[[AppTmpData sharedManager]getCurrentCategory]];

		Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
		
		NSMutableArray *tmpArr = [appDelegate.home.leftNavigationArray lastObject];
		
		for (int i=0; i<[tmpArr count]; i++) {
			//[selectedCategory addObject:[tmpArr objectAtIndex:i.name]];
			[selectedCategory addObject:((CategoryDetails *)[tmpArr objectAtIndex:i]).Name];
		}
		
		
    }
	

	
	[self selectAllBtnClicked];
    
    [self checkPreviouslySelectedItems];
	
}


#pragma mark -
#pragma mark Table Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    return 1;	
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [selectedCategory count];
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
	static NSString *CellIdentifier = @"PopOverCustomeCell";   	
	
	PopOverCustomeCell *cell = (PopOverCustomeCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil){
		bSelectAll = YES;
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PopOverCustomeCell" owner:self options:nil];
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (PopOverCustomeCell *) currentObject;
				[cell.popImage setImage:[UIImage imageNamed:@"NotSelected.png"]];
				break;
			}			
		}
	}
	
	[cell.popTitle setText:[selectedCategory objectAtIndex:indexPath.row]];	//setting the subcategory name
	
	NSNumber *selected = [selectedStatusArray objectAtIndex:indexPath.row];	//for checking whether the given row is selected or not
	
	if([selected boolValue] == YES){
	
		[cell.popImage setImage:[UIImage imageNamed:@"IsSelected.png"]];
	}
	else{
		
		[cell.popImage setImage:[UIImage imageNamed:@"NotSelected.png"]];
	}
	
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
   if (indexPath.row==0) {
	   
	   if (bSelectAll==NO) {
		   bSelectAll=YES;
		   [self selectNoneBtnClicked];
	   }
	   else {
		   bSelectAll=NO;
		   [self selectAllBtnClicked];
	   }
   }
	
   else{		
	   BOOL selection = [[selectedStatusArray objectAtIndex:[indexPath row]]boolValue];
	   
	   [selectedStatusArray replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithBool:!selection]];
	   
	   if(bSelectAll == YES && selection != NO){
		  
		   bSelectAll = NO;
		   [selectedStatusArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];			
	   }
   }
    BOOL selectAll=YES;
	for(int iIndex=1;iIndex<[selectedStatusArray count];iIndex++){
        
        selectAll = [[selectedStatusArray objectAtIndex:iIndex]boolValue];
        if(!selectAll)
            break;
    }
    if(selectAll){
        [selectedStatusArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
    }else{
        [selectedStatusArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:NO]];
    }
	[popTable reloadData];
	
}


#pragma mark -
#pragma mark Button Clicked

-(IBAction)DoneButtonClick:(id)sender{
	
	@try {
		
		NSMutableArray *tempArray1= [[NSMutableArray alloc]init];	//For finding which all are the category is selected or not
		
		for (int i=0;i<[selectedStatusArray count];i++) {
			
			BOOL selection = [[selectedStatusArray objectAtIndex:i]boolValue];
			
			if ((selection) && (i!=0)) {
				
				//[tempArray addObject:((CategoryDetails *)[tmpArr objectAtIndex:i]).idCategory];
				[tempArray1 addObject:[selectedCategory objectAtIndex:i]];
			}
		}
		
		if ([tempArray1 count]!=0) {
			
			Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
			
			[appDelegate.home ChangeProductDetailsArray:tempArray1];
			
			//[objHome ChangeProductDetailsArray:tempArray];
			
		}
		
		else {
			
			Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
			
			[appDelegate.home dismissPopoverController];
			
		}
		[tempArray1 release];
		
		tempArray1=nil;
		
	}
	@catch (NSException * e) {
		
		NSLog(@"catching %@ reason %@", [e name], [e reason]);//DebugLog
		NSLog(@"catchhhhhh");
	}
	
	@finally {
		
		NSLog(@"@finally");
	}
			
}

- (void)selectAllBtnClicked{
    if(selectedStatusArray){
        [selectedStatusArray release];
        selectedStatusArray=nil;
    }
	
	selectedStatusArray = [[NSMutableArray alloc] initWithCapacity:[selectedCategory count]];
	
	for (int i=0;i<[selectedCategory count];i++){
		
		[selectedStatusArray addObject:[NSNumber numberWithBool:YES]];
	}
}

-(void)selectNoneBtnClicked{
    
    if(selectedStatusArray){
        [selectedStatusArray release];
        selectedStatusArray=nil;
    }
	
	selectedStatusArray = [[NSMutableArray alloc] initWithCapacity:[selectedCategory count]];
	
	for (int i=0;i<[selectedCategory count];i++){
		
		[selectedStatusArray addObject:[NSNumber numberWithBool:NO]];
	}
}

-(void)checkPreviouslySelectedItems{
	NSString *selCategoryname;
    int iCategoryIndex=0;
    
    if([self.prevSelectedCategory count]<=0){
        return;
    }
    [self selectNoneBtnClicked];
    
    if([self.prevSelectedCategory count]==[selectedStatusArray count]-1){
        BOOL selected=YES;
        [selectedStatusArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:selected]];
    }
    
	for (selCategoryname in selectedCategory){
        
        for(int iIndex=0;iIndex<[self.prevSelectedCategory count];iIndex++){
            if(selCategoryname==[self.prevSelectedCategory objectAtIndex:iIndex]){
                BOOL selected=YES;
                [selectedStatusArray replaceObjectAtIndex:iCategoryIndex withObject:[NSNumber numberWithBool:selected]];
            }
        }
        iCategoryIndex++;
	}
}

	


#pragma mark -



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    self.prevSelectedCategory=nil;
    
    [selectedCategory release];
    selectedCategory=nil;
    
    [selectedStatusArray release];
    selectedStatusArray=nil;
    
	[topTitle release];
	[popTable release];
	[doneButton release];
    [super dealloc];
}


@end
