//
//  Home.m
//  Torq361
//
//  Created by Binoy on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Home.h"
#import "ConnectivityCheck.h"
#import "LoginViewController.h"
#import "IntermediateView.h"
#import "MainCategorySelectorView.h"  	
#import "DataSyncManager.h"
#import "Constants.h"
#import "AppTmpData.h"
#import "DatabaseManager.h"
#import "CategoryDetails.h"
#import "ProductDetails.h"
#import "LeftTableCategoryCell.h"
#import "LeftTableProductCell.h"
#import "DownloadCategoryThumbnails.h"
#import "HomeListCustomCell.h"
#import "HomeGridCustomCell.h"
#import "ProductDetailsView.h"
#import "UserCredentials.h"
#import "SubCategoryPopOver.h"	//For showing the pop up view
#import "UserSetting.h"			//For UserSetting
#import "FileManager.h"
#import "ProductDetailView.h"
#import "Torq361AppDelegate.h"
@implementation UINavigationBar (CustomImage)


-(void)drawRect:(CGRect)rect {
	
    
	UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"navigation_bar_bg" ofType:@"png"]];
	[image drawInRect:rect];
	[image release];
	image = nil;

}

@end

@implementation UIToolbar (CustomImage)

-(void)drawRect:(CGRect)rect {
	
	UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"navigation_bar_bg" ofType:@"png"]];
	[image drawInRect:rect];
	[image release];
	image = nil;

}

@end

@implementation Home

@synthesize hidingView, productTableView, coveringView,leftNavigationArray,productDetailsArray,tempProductDetailsArray,selCategoryArray;
 
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
    
    tempProductDetailsArray = [[NSMutableArray alloc] init];
	
	newDownloadStatusImage.hidden = YES;
    
    dounloadImage.hidden          = YES;
    
    dounloadButton.hidden         = YES;
	
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
		
		[[AppTmpData sharedManager] setDeviceOrientation:NO]; // orientation set as LANDSCAPE
		
	} 
	else {
		
		[[AppTmpData sharedManager] setDeviceOrientation:YES]; // orientation set as PORTRAIT
		
	}
	
	self.view.frame = CGRectMake(0, 20, 768, 1004);
	
	//productDetailsArray = [[NSMutableArray alloc]init];
	
	productTableView.autoresizingMask = UIViewAutoresizingNone;
	
	productTableView.frame = CGRectMake(50, 84, 700, 920);
	 
	productTableView.dataSource = self;
	
	[[AppTmpData sharedManager]allocAppImages];
	
	//[self loadLeftNavigationView];

	
}

-(void)showLogin {	
	
	//NSLog(@"AuthToken111 : %@",[[UserCredentials sharedManager]getAuthToken]);
	
	
	[hidingView setHidden:NO];
	
	[self.view bringSubviewToFront:hidingView];
	
	if ([[AppTmpData sharedManager]getDeviceOrientation]) {
	
		hidingView.frame = CGRectMake(0, 0, 768, 1004);
		
	}
	else {
	
		hidingView.frame = CGRectMake(0, 0, 1024, 748);
		
	}
	
	LoginViewController *loginViewController=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];	
	
	navController.modalPresentationStyle=UIModalPresentationFormSheet;
	
	[self presentModalViewController:navController animated:YES];	
	
	[loginViewController release];
	
}


-(void)onSuccessfulLogin {
    
    /***************code for unzip***************************
 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];	
    NSString *companyid = @"1";// [[UserCredentials sharedManager]getCompanyID];
    NSString *companyIDPath=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/CompanyId%@",companyid]];		
       NSString *dataBasePath=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/Torq361.db"]];

    
    if ([[NSFileManager defaultManager]fileExistsAtPath:companyIDPath]) {
        
                NSLog(@"Hiiiii");
    }
    
    else {
         FileManager *fileManager=[[FileManager alloc]init];
        [fileManager installDataStore:@"CompanyId1.zip"];
        [fileManager release];
        fileManager=nil;
    }
    
      
        FileManager *fileManager=[[FileManager alloc]init];
        [fileManager installDataStore:@"Torq361.db.zip"];
        [fileManager release];
        fileManager=nil;
    
   
  
	[[UserCredentials sharedManager] setCompanyID:@"1"];
	
	[self showMainCategoryView:YES];
     //********************************************************/
	
	ConnectivityCheck *connectivityCheck=[[ConnectivityCheck alloc] init];
	
	if([connectivityCheck isHostReachable]) {
		
		//do sync here
		
		[self syncDB:YES];
		
	}
	
	[connectivityCheck release];
	
	
	//[hidingView setHidden:YES];
	
	//[self showMainCategoryView:YES];
	
	//[self showIntermediateView];
	
	
	
	//NSLog(@"First Name : %@",[[UserCredentials sharedManager]getFirstName]);
	
}

-(void)resetLeftNavigationViewForSubCategorySelection{
    if(leftTableShowingProducts){
        [self navigationBackButtonClicked:nil];
    }
}


-(void)ChangeProductDetailsArray:(NSMutableArray *)Arr{
	
	NSMutableArray *proArray = [[NSMutableArray alloc]initWithCapacity:[Arr count]];

	for (int i=0;i<[Arr count];i++) {
		
		[proArray addObject:[[DatabaseManager sharedManager]getCategoryIDWithCategoryName:[Arr objectAtIndex:i]]];
		
	}
    self.selCategoryArray=Arr; 
	
	NSMutableArray *tmpArray = [[DatabaseManager sharedManager]getProductByCategoryID:proArray];
	
	[[AppTmpData sharedManager]setProductDetailsArray:tmpArray];
	
	self.productDetailsArray = [[AppTmpData sharedManager]getProductDetailsArray];
	
	[self.tempProductDetailsArray addObject:self.productDetailsArray];
	
	[self dismissPopoverController];
	
	[productTableView reloadData];
    
    if ([[AppTmpData sharedManager]getDeviceOrientation]) {
        
        
        leftNavigationController.view.frame = CGRectMake(-320, 84, 320, 960);
        
        [self onHidingNavigationView];
    }
    [self resetLeftNavigationViewForSubCategorySelection];
    
    [proArray release];
    proArray=nil;
	
}

-(void)loadHomebasedOnCategorySelected:(int)selectedCategoryId {
	

   // NSMutableString *temp = [[NSMutableArray alloc] initWithCapacity:0];
	//[[AppTmpData sharedManager]setProductDetailsArray:temp];
	//productDetailsArray = [[AppTmpData sharedManager]getProductDetailsArray];

    NSLog(@"PRoduct Array Count Is %d",[self.productDetailsArray count]);
    
    self.selCategoryArray=nil;
    
    if(tempProductDetailsArray){
        [tempProductDetailsArray release];
        tempProductDetailsArray=nil;
    }
	tempProductDetailsArray = [[NSMutableArray alloc]init];
    
    
	//For Keepning the selected maincategoryid and name which we are selected from maincategory page
	[[AppTmpData sharedManager]setSelectedMainCategoryID:selectedCategoryId name:[[DatabaseManager sharedManager]getCategoryNameWithID:selectedCategoryId]];
	
	[[AppTmpData sharedManager]setSelectedSubCategoryID:selectedCategoryId name:[[AppTmpData sharedManager]getSelectedMainCategoryName]];
	
	NSMutableArray *idArray = [[NSMutableArray alloc]init];	
	
	[idArray addObject:[NSNumber numberWithInt:selectedCategoryId]];	//For passing as an Array
	
	//NSLog(@"array=%d",idArray);
	
	NSMutableArray *tmpArray = [[DatabaseManager sharedManager]getProductByCategoryID:idArray];
	
	[idArray release];
    idArray = nil;
	
	[[AppTmpData sharedManager]setProductDetailsArray:tmpArray];
	
	self.productDetailsArray = [[AppTmpData sharedManager]getProductDetailsArray];
	
	[self.tempProductDetailsArray addObject:self.productDetailsArray];
    
    //tempProductDetailsArray=self.productDetailsArray;
    //[tempProductDetailsArray retain];
	[productTableView reloadData];
//    [productTableView reloadData]; 
	[productTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
	
	//***************** Upadate Left Navigation View *********************//


	
	NSMutableArray *subCategories = [[DatabaseManager sharedManager]getCategoryByParentID:selectedCategoryId];
	
	if ([subCategories count] == 0) {
		
		// No sub categories under this category, check for contents
		
		// check for products under this category
		
		if ([self.productDetailsArray count] != 0) {
			
            /*///////Commnted for removing product listing in left table view///////////////
             

			leftTableShowingProducts = YES;
			
			[self pushATableView:NO];
             
            ///////////////////////////////////////////////////////////////////////////////*/
			
			
		}
		
		else {
			
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Torq361" 
														  message:@"Category is empty" 
														 delegate:nil 
												cancelButtonTitle:@"OK" 
												otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}

	}
	
	else {
        
        if ([self.productDetailsArray count] == 0){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Torq361" 
														  message:@"No products for this category, Please check the sub categories" 
														 delegate:nil 
												cancelButtonTitle:@"OK" 
												otherButtonTitles:nil];
			[alert show];
			[alert release];
        }
		
       /* NSMutableArray *array = [[NSMutableArray alloc]init];
        self.leftNavigationArray = array;
        [array release];
        array=nil;*/
        
		[self.leftNavigationArray addObject:subCategories];
		
        //[leftNavigationController popToRootViewControllerAnimated:NO];
		[self pushATableView:NO];
		
	
	}
    //[subCategories release];
    //subCategories=nil;
	
	//***************** Upadate Left Navigation View *********************//
    

    
  

}


-(void)hideMainCategorySelection:(NSString*)selectedCategoryId {
    
	
	[self releaseMainCategoryView];
	
	// show home based on the main category selected
	
	[self loadHomebasedOnCategorySelected:[selectedCategoryId intValue]];
	
	
}


-(void)loadLeftNavigationView {
	
	NSMutableArray *topLevelCategories = [[DatabaseManager sharedManager]getCategoryByParentID:0];
	
    NSMutableArray *array = [[NSMutableArray alloc]init];
	self.leftNavigationArray = array;
    [array release];
    array=nil;
	
	[self.leftNavigationArray addObject:topLevelCategories]; // top level categories stored in index 0.
	
	UITableViewController *tableViewController = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
	
	tableViewController.tableView.frame = CGRectMake(0, 0, 320, 960);
	
	tableViewController.tableView.delegate = self;
	
	tableViewController.tableView.dataSource = self;
	
	currentOperationIsAPush = YES; 
	
	
	leftNavigationController = [[UINavigationController alloc]initWithRootViewController:tableViewController];
	
	tableViewController.navigationItem.hidesBackButton = YES;
	
	leftNavigationController.view.autoresizingMask = UIViewAutoresizingNone;
	
	leftNavigationController.delegate = self;
	
	if ([[AppTmpData sharedManager]getDeviceOrientation]) {
		
		leftNavigationController.view.frame = CGRectMake(-320, 84, 320, 960);
	}
	else {
		
		leftNavigationController.view.frame = CGRectMake(0, 84, 320, 664);
	}
	
	[self.view addSubview:leftNavigationController.view];
	
	
	
	//Added Label and Buttons to navigation bar
	
	
	UIToolbar *objToolBar = [[UIToolbar alloc] init];
    
  //  objToolBar.translucent=YES;
  //  objToolBar.barStyle=UIBarStyleBlack;
	
    
	objToolBar.frame=CGRectMake(70,0,250,44);
	objToolBar.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin);
    objToolBar.backgroundColor=[UIColor clearColor];
	
	gridViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
	gridViewButton.frame = CGRectMake(0, 9, 26, 26);
	[gridViewButton addTarget:self action:@selector(gridViewButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	
	
	listViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listViewButton.frame = CGRectMake(64, 9, 26, 26);
	[listViewButton addTarget:self action:@selector(listViewButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	
	titleName = [[UILabel alloc]initWithFrame:CGRectMake(0, 9, 140, 26)];
	titleName.backgroundColor = [UIColor clearColor];
	titleName.textAlignment = UITextAlignmentCenter;
	titleName.textColor = [UIColor whiteColor];
	[titleName setFont:[UIFont fontWithName:@"Arial" size:18]];
	
	
	
	// Setting Image for button
	
	UIImage *image;
	
	image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"GridViewSelected" ofType:@"png"]];
	
	[gridViewButton setBackgroundImage:image forState:UIControlStateNormal];
	
	[image release];
	image = nil;
	
	image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ListView" ofType:@"png"]];
	
	[listViewButton setBackgroundImage:image forState:UIControlStateNormal];
    
	[image release];
	image = nil;
	
	UIBarButtonItem *gridBarButton = [[UIBarButtonItem alloc] initWithCustomView:gridViewButton];
										  
	
	
	UIBarButtonItem *listBarButton = [[UIBarButtonItem alloc] initWithCustomView:listViewButton];
	
	UIBarButtonItem *titleBarButton = [[UIBarButtonItem alloc] initWithCustomView:titleName];
    
	//bar button flexible space  
	UIBarButtonItem *flexibleSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace                                                                                            target:nil
																						action:nil];
	
	[objToolBar setItems:[NSArray arrayWithObjects:titleBarButton,
						  flexibleSpace,
						  gridBarButton,
						  flexibleSpace,
						  listBarButton,
						  nil]];
    
	[tableViewController.navigationController.navigationBar addSubview:objToolBar];
	
	[listBarButton release];
	[gridBarButton release];
	[titleBarButton release];
	[flexibleSpace release];
	[objToolBar release];
	 
	[tableViewController release];
	
}


-(void)pushATableView:(BOOL)animated {
	
	
    
    currentOperationIsAPush = YES;
	
	UITableViewController *tableViewController = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
	
	tableViewController.tableView.frame = CGRectMake(0, 0, 320, 960);
	
	tableViewController.tableView.delegate = self;
	
	tableViewController.tableView.dataSource = self;
	
	[leftNavigationController pushViewController:tableViewController animated:animated];
	
	
	
	// Setting Navigation Title to the Selected category Name
	
	titleName.text = [[AppTmpData sharedManager]getSelectedSubCategoryName];
	
	tableViewController.navigationItem.hidesBackButton = YES;
	

	UIImage *buttonImage = [UIImage imageNamed:@"NavigationBackButton.png"];
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
	[backButton setFrame:CGRectMake(0.0, 0.0, buttonImage.size.width-10, buttonImage.size.height)];
	[backButton setImage:buttonImage forState:UIControlStateNormal];
	[backButton addTarget:self.navigationController action:@selector(navigationBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
		
	tableViewController.navigationItem.leftBarButtonItem = backButtonItem;
	
	totalNavigationBackButtonClickCount += 1;
		
	NSLog(@"navigationBar BackButton count====%d",totalNavigationBackButtonClickCount);
	
	[tableViewController release];
	
	tableViewController = nil;


}

//============================

- (IBAction) navigationBackButtonClicked:(id)sender {
    
    self.selCategoryArray=nil;
	
	NSLog(@"tempProductDetailsArray  count====== %d",[self.tempProductDetailsArray count]);
	
	//self.productDetailsArray = [tempProductDetailsArray objectAtIndex:totalNavigationBackButtonClickCount-1];
	self.productDetailsArray=[self.tempProductDetailsArray objectAtIndex:[self.tempProductDetailsArray count]-1];
	[productTableView reloadData];
	
	[self.tempProductDetailsArray removeLastObject];
    
    [[AppTmpData sharedManager]setProductDetailsArray:self.productDetailsArray];
	
	NSLog(@"tempProductDetailsArray  count====== %d",[self.tempProductDetailsArray count]);
	[leftNavigationController popViewControllerAnimated:YES];
	
	totalNavigationBackButtonClickCount -= 1;
}


#pragma mark -
#pragma mark Method for selecting the product details

- (void)productDidSelectedWithProductID:(int)productId {
    viewForHelpingRotation.hidden = YES;
    productDetailsView1 = [[ProductDetailView alloc]initWithNibName:@"ProductDetailView"
                                                             bundle:nil];
    productDetailsView1.productId = productId;
    [[DownloadEngine sharedManager] StartManualDownload:productId];
    viewForHelpingRotation.hidden = NO;
    productDetailsView1.deligate=self;
    productDetailsView1.modalTransitionStyle= UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:productDetailsView1 animated:YES];
    [productDetailsView1 release];
    productDetailsView1=nil;


}

- (void)selectedProductWithArrayIndex:(int)index {
    
    ProductDetails * product = [self.productDetailsArray objectAtIndex:index];
    [self productDidSelectedWithProductID:[product.idProduct intValue]];
}

-(void)productDetailViewClosed{

    //[self.productDetailsView1.view removeFromSuperview];
    
     //NSLog(@"productDetailsView1 retain %d" , [productDetailsView1 retainCount]);
  //  [[productDetailsView1.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
   // [productDetailsView1 release];
     productDetailsView1=nil;
    
    [productTableView reloadData];
    
}
#pragma mark -
#pragma mark alloc methods

-(void)syncDB:(BOOL)showBackground {
	
	if (dataSyncManager) {
        [dataSyncManager.view removeFromSuperview];
		
		[dataSyncManager release];
		
		dataSyncManager = nil;

    }
    dataSyncManager =[[DataSyncManager alloc]initWithNibName:@"DataSyncManager" bundle:nil];
    [dataSyncManager setBackgroundImageStatus:showBackground];
    [self.view addSubview:dataSyncManager.view];

	

}

-(void)showIntermediateView {
	
	[self releaseIntermediateView];
	
	intermediateView = [[IntermediateView alloc]initWithNibName:@"IntermediateView" bundle:nil];
	
    NSLog(@"RETAIN COUNT OF INTERMEDIATE PAGE IS:- %d", [self retainCount]);
    
	[self.view addSubview:intermediateView.view];
    

	
}

-(void)showMainCategoryView:(BOOL)showBackground {
    
	
	[self releaseIntermediateView];
	
	mainCategoryView = [[MainCategorySelectorView alloc]initWithNibName:@"MainCategorySelectorView" bundle:nil];
	
	[mainCategoryView ShowBackgroundImage:showBackground];
    
   // NSLog(@"RETAIN COUNT OF INTERMEDIATE PAGE IS:- %d", [self retainCount]);
    

	
    [self.view addSubview:mainCategoryView.view];
    
    //NSLog(@"RETAIN COUNT OF INTERMEDIATE PAGE IS:- %d", [self retainCount]);
    //[mainCategoryView release];
    //mainCategoryView = nil;
	
	
	
}


#pragma mark -
#pragma mark release methods

-(void)hideDataSyncManager {

	if (dataSyncManager) {
		
		[dataSyncManager.view removeFromSuperview];
		
		[dataSyncManager release];
		
		dataSyncManager = nil;
	}
	
	[hidingView setHidden:YES];
    
    [self loadLeftNavigationView];
	
	[self showMainCategoryView:YES];
    
    
}


-(void)releaseIntermediateView {
	
	if (intermediateView) {
		
		[intermediateView.view removeFromSuperview];
		
		[intermediateView release];
		
		intermediateView = nil;
	}
	
	
}

-(void)releaseMainCategoryView {
	
	if (mainCategoryView) {
		
		[mainCategoryView.view removeFromSuperview];
		
		[mainCategoryView release];
		
		mainCategoryView = nil;
	}
	
	
}

-(void)releaseProductDetailsView {

    
      
	if (productDetailsView) {
		NSLog(@"@retain count Is:001- %d",[productDetailsView retainCount]);
		[productDetailsView.view removeFromSuperview];
		NSLog(@"@retain count Is:002- %d",[productDetailsView retainCount]);
		[productDetailsView release];
		//NSLog(@"@retain count Is:003- %d",[productDetailsView retainCount]);
		productDetailsView = nil;
		
		[viewForHelpingRotation removeFromSuperview];
        
        
	}

	//[self.view removeFromSuperview];
}

#pragma mark -

#pragma mark Button Actions

-(IBAction)logoButtonClicked:(id)sender {
	
    totalNavigationBackButtonClickCount = 0;
    
	if ([self.leftNavigationArray count] > 1) {
		
		//[leftNavigationController popToViewController:[[leftNavigationController viewControllers]objectAtIndex:1] animated:YES];
		
		popToRootView = YES;
	
		[leftNavigationController popToRootViewControllerAnimated:NO];
		
		for (int i = 1; i<=[self.leftNavigationArray count]; i++) {
			
			[self.leftNavigationArray removeLastObject];
		}
		
		currentOperationIsAPush = NO;
		
		leftTableShowingProducts = NO;
		
	}else if([[leftNavigationController viewControllers]count]>1){
        
        popToRootView = YES;
        
        [leftNavigationController popToRootViewControllerAnimated:NO];
        
        currentOperationIsAPush = NO;
        
		leftTableShowingProducts = NO;

    }
	NSLog(@"leftNavigationController view controllers count : %d",[[leftNavigationController viewControllers]count]);
	[self showMainCategoryView:NO];
    
    //For closing the left navigation view
    if ([[AppTmpData sharedManager]getDeviceOrientation]) {
        
        
        leftNavigationController.view.frame = CGRectMake(-320, 84, 320, 960);
        
        [self onHidingNavigationView];
    }
    
	
}

-(IBAction)subCategoryButtonClicked:(id)sender {
	
	[self dismissPopoverController];
	
	SubCategoryPopOver *subCategoryPopOverView=[[SubCategoryPopOver alloc]initWithNibName:@"SubCategoryPopOver" bundle:nil];
    
    if(self.selCategoryArray){
        subCategoryPopOverView.prevSelectedCategory= self.selCategoryArray;
    }
	
	popOverControllerView=[[UIPopoverController alloc] initWithContentViewController:subCategoryPopOverView];
	popOverControllerView.delegate=self;
	
	if([[AppTmpData sharedManager]getDeviceOrientation]){
		
		[popOverControllerView presentPopoverFromRect:CGRectMake(450, 20, 50, 50) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	else {
		[popOverControllerView presentPopoverFromRect:CGRectMake(700, 20, 50, 50) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    [popOverControllerView  setPopoverContentSize:CGSizeMake(250,300) animated:NO];	
	
	[subCategoryPopOverView release];
	
}



-(IBAction)downloadButtonClicked:(id)sender {
	
/*	[self dismissPopoverController];
	
	SubCategoryPopOver *subCategoryPopOverView=[[SubCategoryPopOver alloc]initWithNibName:@"SubCategoryPopOver" bundle:nil];
	
	popOverControllerView=[[UIPopoverController alloc] initWithContentViewController:subCategoryPopOverView];
	popOverControllerView.delegate=self;
	
	if([[AppTmpData sharedManager]getDeviceOrientation]){
		
		[popOverControllerView presentPopoverFromRect:CGRectMake(300, 20, 50, 50) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	else {
		[popOverControllerView presentPopoverFromRect:CGRectMake(550, 20, 50, 50) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    [popOverControllerView  setPopoverContentSize:CGSizeMake(250,300) animated:NO];	
	
	[subCategoryPopOverView release];
*/	
}


-(IBAction)signoutButtonClicked:(id)sender {
	
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Torq361" message:@" Are you sure you want to Sign Out?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    [alert show];
    [alert release];
    alert=nil;
	
	
	
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kLoginStatus];
        
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kUserCredentials];
        
        [[NSUserDefaults standardUserDefaults]  setValue:nil forKey:kAuthToken];
        
        
        //NSString *authToken = [[NSUserDefaults standardUserDefaults]  valueForKey:kAuthToken];
        //NSLog(@"AuthToken : %@",authToken);
        
        //NSInteger temp1 = [[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatus];
        
        [self showLogin];
    }
}

-(IBAction)settingsButtonClicked:(id)sender {
	
	
	UserSetting *userSetting=[[UserSetting alloc] initWithNibName:@"UserSetting" bundle:nil];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:userSetting];
	
	navController.modalPresentationStyle=UIModalPresentationFormSheet;
    navController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
	
	[self presentModalViewController:navController animated:YES];	
	
	[userSetting release];
    [navController release];
	
}

-(IBAction)browseButtonClicked:(id)sender {
	
	[coveringView setHidden:NO];
	coveringView.frame = CGRectMake(0, 84, 768, 920);
	[self.view bringSubviewToFront:coveringView];
	
	[self.view bringSubviewToFront:leftNavigationController.view];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];	
	[UIView setAnimationDelegate:self];
	[UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:leftNavigationController.view cache:YES];
	
	leftNavigationController.view.frame = CGRectMake(0, 84, 320, 960);
	
	[UIView commitAnimations];
	
}

-(IBAction)NavigationViewMinimizeButtonClicked:(id)sender {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];	
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(onHidingNavigationView)];
	[UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:leftNavigationController.view cache:YES];
	
	leftNavigationController.view.frame = CGRectMake(-320, 84, 320, 960);
	
	[UIView commitAnimations];
	
}

-(void)onHidingNavigationView {
	
	coveringView.frame = CGRectMake(-1000, 84, 768, 920);
	[coveringView setHidden:YES];
	
}

- (void)gridViewButtonClicked {
    
    //For closing the left navigation view
    if ([[AppTmpData sharedManager]getDeviceOrientation]) {
        
        
        leftNavigationController.view.frame = CGRectMake(-320, 84, 320, 960);
        
        [self onHidingNavigationView];
    }
	
    //animation
    
    [self homePageAnimation];
    
    if (productTableInListView) {
		
		productTableInListView = NO;
        
		// Set Images for buttons
		
		UIImage *image;
		
		image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"GridViewSelected" ofType:@"png"]];
		
		[gridViewButton setBackgroundImage:image forState:UIControlStateNormal];
		
		[image release];
		image = nil;
		
		image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ListView" ofType:@"png"]];
		
		[listViewButton setBackgroundImage:image forState:UIControlStateNormal];
		
		[image release];
		image = nil;
		
		
        //animation
        
        [self homePageAnimation];	
		
		// Reload Product Table
		
		[productTableView reloadData];
		
	}
	
	
}


- (void)listViewButtonClicked {
    
    
    //For closing the left navigation view
    if ([[AppTmpData sharedManager]getDeviceOrientation]) {
        
        
        leftNavigationController.view.frame = CGRectMake(-320, 84, 320, 960);
        
        [self onHidingNavigationView];
    }
    
    //animation
    
    [self homePageAnimation];
    
	
	if (!productTableInListView) {
		
		productTableInListView = YES;
		
		// Set Images for buttons
		
		UIImage *image;
		
		image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"GridView" ofType:@"png"]];
		
		[gridViewButton setBackgroundImage:image forState:UIControlStateNormal];
		
		[image release];
		image = nil;
		
		image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ListViewSelected" ofType:@"png"]];
		
		[listViewButton setBackgroundImage:image forState:UIControlStateNormal];
		
		[image release];
		image = nil;
		
		//animation
        
        [self homePageAnimation];

		// Reload Product Table
		
		[productTableView reloadData];
		
	}
	
		
}

#pragma -
#pragma mark Animation method

- (void) homePageAnimation {
    
    // Animation
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8];	
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    [UIView commitAnimations];
    
}


#pragma mark -

-(void)dismissPopoverController{
	
	if (popOverControllerView) {
		[popOverControllerView dismissPopoverAnimated:NO];
		popOverControllerView=nil;
	}
    
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [popoverController release];
    popoverController=nil;
    popOverControllerView=nil;
}


#pragma mark -
#pragma mark TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

	return 1;
	
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section {
	
	myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	if (myTableView == productTableView) {   // Main Table
		
		if (productTableInListView) {
			
			productTableView.rowHeight = 188;
			
			return [self.productDetailsArray count];
		}
		
		else {
			
			productTableView.rowHeight = 260;
						
			return ([self.productDetailsArray count]/3 + (([self.productDetailsArray count]%3 > 0) ? 1: 0));
		}

		
		
	}
	else {    // Left Navigation Table
		
		if (leftTableShowingProducts) {
			
			myTableView.rowHeight = 105;
			
			myTableView.backgroundColor = [UIColor colorWithPatternImage:[[AppTmpData sharedManager]getImageByName:@"ProductTableBG"]];
			
			return [self.productDetailsArray count];
			
		}
		else {
			
			myTableView.rowHeight = 50;
			
			myTableView.backgroundColor = [UIColor colorWithPatternImage:[[AppTmpData sharedManager]getImageByName:@"CategoryTableBG"]];
			
			
			return [[self.leftNavigationArray lastObject] count];
		}
		
	}
}

// ugly but better than older method
- (NSArray*)productsInGridViewAtIndexPath:(NSIndexPath*)_indexPath {
    
    int index = (_indexPath.row*3);
    int maxIndex = (_indexPath.row*3+2);
        
    if(maxIndex < [self.productDetailsArray count]) {
        
        return [NSArray arrayWithObjects:[self.productDetailsArray objectAtIndex:index],
                [self.productDetailsArray objectAtIndex:index+1],
                [self.productDetailsArray objectAtIndex:index+2],
                nil];
    }
    
    else if(maxIndex-1 < [self.productDetailsArray count]) {
        
        return [NSArray arrayWithObjects:[self.productDetailsArray objectAtIndex:index],
                [self.productDetailsArray objectAtIndex:index+1],
                nil];
    }
    
    else if(maxIndex-2 < [self.productDetailsArray count]) {
        
        return [NSArray arrayWithObject:[self.productDetailsArray objectAtIndex:index]];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//NSLog(@"self retain in Navigation table  %d",[self retainCount]);
	
    NSLog(@"INside the cellfor rowwwwwww");
	if (myTableView == productTableView) {
		
		if (productTableInListView) {	// LIST View
			
			static NSString *CellIdentifier = @"HomeListCustomCell";
			
			HomeListCustomCell *cell = (HomeListCustomCell *) [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];		
			
			if (cell == nil) {
				
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HomeListCustomCell" owner:self options:nil];
				for (id currentObject in topLevelObjects){
					
					if ([currentObject isKindOfClass:[UITableViewCell class]]){
						cell =  (HomeListCustomCell*) currentObject;					
						break;
						
					}
				}					
			}				
			
			ProductDetails *prodDetails;	
			
			int ielement=indexPath.row*1;
			
			//Finding the corresponding product thumb path
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentPath = [paths objectAtIndex:0]; ///Users/rinishrvs/Library/Application Support/iPhone Simulator/4.2/Applications/BCA8AB2A-1ABE-4907-A4BC-803637928FE0/Documents
			NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
			NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductThumb",@"CompanyId",companyid]];///Users/rinishrvs/Library/Application Support/iPhone Simulator/4.2/Applications/BCA8AB2A-1ABE-4907-A4BC-803637928FE0/Documents/CompanyId1/CatagoryThumb
			
			
			
			NSArray *objExtension = [((CategoryDetails *)[self.productDetailsArray objectAtIndex:ielement]).ThumbNailImgPath componentsSeparatedByString:@"/"];
			
			//imageIncrement ++;
			NSString *strDownloadDestiantionPath=[NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
			
			
			
			
			
			prodDetails=[self.productDetailsArray objectAtIndex:indexPath.row];
			
			cell.photoFrameImage1.image = [[AppTmpData sharedManager]getImageByName:@"PhotoFrame"];
		
            UIImage *thumbImg=[[UIImage alloc]initWithContentsOfFile:strDownloadDestiantionPath];
            
            
            
			cell.thumbnailImage1.image =thumbImg; //[NSString stringWithFormat:@"%@/@",documentFolder,productDetails.ThumbNailImgPath]] autorelease];
            
            if(cell.thumbnailImage1.image){
                cell.activityIndicator1.hidden = YES;
            }else{
                NSString *path=[NSString stringWithFormat:@"%@nil",prodDetails.ThumbNailImgPath];
                if([path isEqualToString:@"nil"]){
                    cell.thumbnailImage1.image=[UIImage imageNamed:@"default_image.png"];
                    cell.activityIndicator1.hidden = YES;
                }else{
                    cell.activityIndicator1.hidden = NO;
                }
            }
            
			[thumbImg release];
            thumbImg=nil;
			// Setting NewBanner
			
		/*	if ([prodDetails.newStatus isEqualToString:@"Y"]) {
				
				cell.newBannerImage1.image = [[AppTmpData sharedManager]getImageByName:@"NewBanner"];
				
			}
			
			else {
				
				cell.newBannerImage1.image = [[AppTmpData sharedManager]getImageByName:@"tick_icon"];				
			}	*/		
			
			// Showing Activity Indicator
			
			/*if ([prodDetails.downloadStatus isEqualToString:@"Y"]) {
				
				cell.activityIndicator1.hidden = NO;
				
			}
			
			else {
				
				cell.activityIndicator1.hidden = YES;
				
			}*/
            
			
			cell.description1.text = prodDetails.Description;
			
			cell.productName1.text = prodDetails.Name;
			
			cell.selectButton1.tag = indexPath.row;
			
			cell.selectButton1.enabled = YES;
			
			cell.selectionStyle=UITableViewCellSelectionStyleNone;
						
			return cell;
			
			
			
		}
      else {
          
          // GRID View  (Each row displays 3 products in grid view)
          static NSString *cellIdentifier = @"HomeGridCustomCell";
          
          HomeGridCustomCell *cell = (HomeGridCustomCell*)[myTableView dequeueReusableCellWithIdentifier:cellIdentifier];
          
          if (cell == nil) 
          {		        
              cell = [[HomeGridCustomCell alloc] initWithProductDetails:[self productsInGridViewAtIndexPath:indexPath] 
                                                        reuseIdentifier:cellIdentifier];
              [cell autorelease];
          }	
          else 
          {		
              [cell setProducts:[self productsInGridViewAtIndexPath:indexPath]];
          }
          
          [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
          
          return cell;
          
      }
		
	}
	
	else {    // Left Table in Navigation View
		
		if (leftTableShowingProducts) {  // left table showing products
			
			static NSString *CellIdentifier = @"LeftTableProductCell";
			
			LeftTableProductCell *cell = (LeftTableProductCell *) [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];		
			
			if (cell == nil) {
				
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LeftTableProductCell" owner:self options:nil];
				for (id currentObject in topLevelObjects){
					if ([currentObject isKindOfClass:[UITableViewCell class]]){
						cell =  (LeftTableProductCell*) currentObject;				
						break;
					}
				}
			}
			
			
			int ielement=indexPath.row*1;
			
			//Finding the corresponding product thumb path
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentPath = [paths objectAtIndex:0]; ///Users/rinishrvs/Library/Application Support/iPhone Simulator/4.2/Applications/BCA8AB2A-1ABE-4907-A4BC-803637928FE0/Documents
			NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
			NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductThumb",@"CompanyId",companyid]];///Users/rinishrvs/Library/Application Support/iPhone Simulator/4.2/Applications/BCA8AB2A-1ABE-4907-A4BC-803637928FE0/Documents/CompanyId1/CatagoryThumb
			
			
			
			NSArray *objExtension = [((CategoryDetails *)[self.productDetailsArray objectAtIndex:ielement]).ThumbNailImgPath componentsSeparatedByString:@"/"];
			
			//imageIncrement ++;
			NSString *strDownloadDestiantionPath=[NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
			
			
         
			
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
			cell.backgroundImage.image=[[AppTmpData sharedManager]getImageByName:@"ProductCellBG"];
			
			cell.photoframeImage.image=[[AppTmpData sharedManager]getImageByName:@"SmallPhotoFrame"];
			
            UIImage *img=[[UIImage alloc]initWithContentsOfFile:strDownloadDestiantionPath];
			cell.thumbnailImage.image=img;//[[NSBundle mainBundle]pathForResource:@"SmallPhotoFrame" ofType:@"png"]] autorelease];
            if(cell.thumbnailImage.image==nil){
                    cell.thumbnailImage.image=[UIImage imageNamed:@"default_image.png"];
            }
            [img release];
            img=nil;
            
            ProductDetails *prodDetails=[self.productDetailsArray objectAtIndex:indexPath.row];
			if(prodDetails){
                
                if(prodDetails.Name)
                    cell.productName.text = (NSString*)prodDetails.Name;
			
                if(prodDetails.Description)
                    cell.description.text = (NSString*)prodDetails.Description;
			}
			return cell;
		}
		
		else {  // left table showing categories
			
			static NSString *CellIdentifier = @"LeftTableCategoryCell";
			
			NSMutableArray *currentArray = [self.leftNavigationArray lastObject];
			
			LeftTableCategoryCell *cell = (LeftTableCategoryCell *) [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
			
			if (cell == nil) {
				
				NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LeftTableCategoryCell" owner:self options:nil];
				for (id currentObject in topLevelObjects){
					if ([currentObject isKindOfClass:[UITableViewCell class]]){
						cell =  (LeftTableCategoryCell*) currentObject;					
						break;
					}
				}
			}
			
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
			cell.backgroundImage.image=[[AppTmpData sharedManager]getImageByName:@"CategoryCellBG"];
			
			cell.categoryName.text = ((CategoryDetails *)[currentArray objectAtIndex:indexPath.row]).Name;
			
			return cell;
		}
		
		
		
	}
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView != productTableView) {
		
		if (leftTableShowingProducts) {  // user selected a product
			
			
			[self selectedProductWithArrayIndex:indexPath.row];
			
		}
		
		else {  // user selected a category			
			
			
			int categoryId = [((CategoryDetails *)[[self.leftNavigationArray lastObject] objectAtIndex:indexPath.row]).idCategory intValue];
			
			NSString *categoryName = ((CategoryDetails *)[[self.leftNavigationArray lastObject] objectAtIndex:indexPath.row]).Name;
			
			// Set selected Category Name and ID
			
			[[AppTmpData sharedManager]setSelectedSubCategoryID:categoryId name:categoryName];
			
			if ([self.leftNavigationArray count] == 1) {
				
				[[AppTmpData sharedManager]setSelectedMainCategoryID:categoryId name:categoryName];
			}
			 
			
			NSMutableArray *subCategories = [[DatabaseManager sharedManager]getCategoryByParentID:categoryId];
			
			
			// Get products under selected category
			
			NSMutableArray *idArray = [[NSMutableArray alloc]init];
			
			[idArray addObject:[NSNumber numberWithInt:categoryId]];	//For passing as an Array
			
			NSMutableArray *tmpArray = [[DatabaseManager sharedManager]getProductByCategoryID:idArray];
			
			[idArray release];
			
			[[AppTmpData sharedManager]setProductDetailsArray:tmpArray];
			
			self.productDetailsArray = [[AppTmpData sharedManager]getProductDetailsArray];
			
			[self.tempProductDetailsArray addObject:self.productDetailsArray];
			
			if ([subCategories count] == 0) {
				
				// No sub categories under this category, check for contents
				
				// check for products under this category
				
				
				if ([self.productDetailsArray count] != 0) {
                    
                    /*///////Commnted for removing product listing in left table view///////////////
					
					leftTableShowingProducts = YES;
					
					[self pushATableView:YES];
                    
                    //////////////////////////////////////////////////////////////////////////////*/
					
					//[productTableView reloadData];
					
					
				}
				
				else {
					
					UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Torq361" 
																  message:@"Category is empty" 
																 delegate:nil 
														cancelButtonTitle:@"OK" 
														otherButtonTitles:nil];
					[alert show];
					[alert release];
                    
				}			
                [productTableView reloadData];
				
				
			}
			
			else {
				
				[self.leftNavigationArray addObject:subCategories];
				
				[self pushATableView:YES];
				
				[productTableView reloadData];				
				
			}
			//[subCategories release];
            //subCategories=nil;
			
		}
		
		
	}
	
}

#pragma mark -
#pragma mark NavigationContoller Delegates

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	
	// Maintaining the details shown in Navigation view
	
	// leftNavigationArray maintains the chain of category and sub categories.
	
	// If its a pop operation, the last item of leftNavigationArray needs to be removed. (Last item should be the one which is currently viewing)
	
  //  int	lastOperation = leftNavigationController._navigationControllerFlags.lastOperation;
	
	if (!popToRootView) {
		
		if (!currentOperationIsAPush) {
			
			if (leftTableShowingProducts) {
				
				// This is a pop operation, but Products are shown currently. So no need to remove the last item from leftNavigationArray
				
				leftTableShowingProducts = NO;
			}
			
			else {
				
				[self.leftNavigationArray removeLastObject];
			}
		}
		
		
	}
	
	popToRootView = NO;
	
	
	currentOperationIsAPush = NO;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	

	
}




#pragma mark -
#pragma mark Orientation Delegates

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

	if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
		[[AppTmpData sharedManager]setDeviceOrientation:YES]; // YES for portrait
		
	//	self.view.frame = CGRectMake(0, 20, 768, 1004);
		
		leftNavigationController.view.frame = CGRectMake(-320, 84, 320, 960);
		
		productTableView.frame = CGRectMake(50, 84, 700, 920);
		
		// orientation of MainCategorySelector and Intermediate View are maintained through IB by setting AutoResizing mask
		
		if (dataSyncManager) {
			
			[dataSyncManager setPortrateView];
		}
		
		if (productDetailsView) {
			
			[productDetailsView setPortraitView];
		}
		
		
	}
	
	else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		
		[[AppTmpData sharedManager]setDeviceOrientation:NO]; // NO for Landscape
		
	//	self.view.frame = CGRectMake(0, 20, 1024, 748);
		
		[coveringView setHidden:YES];
		coveringView.frame = CGRectMake(-1000, 84, 768, 920);	

		leftNavigationController.view.frame = CGRectMake(0, 84, 320, 664);
		
		productTableView.frame = CGRectMake(322, 84, 700, 664);
		
		// orientation of MainCategorySelector and Intermediate View are maintained through IB by setting AutoResizing mask
		
		if (dataSyncManager) {
		
			[dataSyncManager setLandscapeView];
			
		}
		
		if (productDetailsView) {
			
			[productDetailsView setLandscapeView];
		}
		
		
	}
	
	
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if([popOverControllerView isPopoverVisible]){
        [self dismissPopoverController ];
        [self subCategoryButtonClicked:subCatButton];
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {

    self.productDetailsArray=nil;
    [tempProductDetailsArray release];
    self.tempProductDetailsArray=nil;
	
	[gridViewButton release];
	
	[listViewButton release];
	
	[titleName release];
	
    [super dealloc];
}

@end
