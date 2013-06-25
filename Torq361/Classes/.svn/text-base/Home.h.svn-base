//
//  Home.h
//  Torq361
//
//  Created by Binoy on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadEngine.h"
#import "ProductDetails.h"
#import "ProductDetailView.h"
@class IntermediateView;
@class MainCategorySelectorView;
@class DataSyncManager;
@class ProductDetailsView;

@interface Home : UIViewController<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, ProductDetailViewDeligate,UIPopoverControllerDelegate> {
	
	UIView *hidingView;
	
	UIView *coveringView;
    
	IBOutlet UIImageView *dounloadImage;
    
    IBOutlet UIButton *dounloadButton;
    
	IBOutlet UIView *viewForHelpingRotation;
	
	IBOutlet UIImageView *newDownloadStatusImage;
    
    IBOutlet UIButton *subCatButton;
	
	UITableView *productTableView;
	
	ProductDetails *productDetails;
	
	DownloadEngine *downloadEngine;
	
	DataSyncManager *dataSyncManager;
	
	IntermediateView *intermediateView;
	
	MainCategorySelectorView *mainCategoryView;
	
	ProductDetailsView *productDetailsView;
	
	UINavigationController *leftNavigationController;
	
	UIPopoverController *popOverControllerView;	//For popovercontrollerview
	
	NSMutableArray *leftNavigationArray; // Array of arrays storing category details shown in left navigation controller.
	
	NSMutableArray *productDetailsArray; // Array containg product details of a selected category or sub category.
	
	BOOL leftTableShowingProducts; // YES if left table is displaying Products, NO if left table is displaying category
	
	BOOL currentOperationIsAPush;    // YES, if the current operation was a push opertion, No if it was apop operation
	
	BOOL popToRootView;    // YES, if the current operation was a popToRootViewController opertion, No otherwise

	BOOL productTableInListView; //YES, if product are shown as LIST, NO if products are shown in GRID view.
	
	UIButton *gridViewButton;
	
	UIButton *listViewButton;
	
	UILabel *titleName;
	
	int totalNavigationBackButtonClickCount;
	
	NSMutableArray *tempProductDetailsArray;	//Array of array which is stroring the product details,which will help for the product 
												//display while the user click on the leftnavigation bar back button
    
    NSMutableArray *selCategoryArray;
    
    
    ProductDetailView * productDetailsView1;
}

@property (nonatomic, retain)IBOutlet UIView *hidingView;
@property (nonatomic, retain)IBOutlet UIView *coveringView;
@property (nonatomic, retain)IBOutlet UITableView *productTableView;
@property (nonatomic, retain)NSMutableArray *leftNavigationArray;
@property (nonatomic, retain)NSMutableArray *productDetailsArray;
@property (nonatomic, retain)NSMutableArray *tempProductDetailsArray;
@property (nonatomic, retain)NSMutableArray *selCategoryArray;


 

-(void)showLogin;

-(void)onSuccessfulLogin;

-(void)loadHomebasedOnCategorySelected:(int)selectedCategoryId;

-(void)hideMainCategorySelection:(NSString*)selectedCategoryId;

-(void)loadLeftNavigationView;

-(void)pushATableView:(BOOL)animated;

-(void)selectedProductWithArrayIndex:(int)index;

-(void)onHidingNavigationView;

-(void)dismissPopoverController;

-(void)ChangeProductDetailsArray:(NSMutableArray *)temp;

- (void) homePageAnimation;

// Alloc Methods

-(void)syncDB:(BOOL)showBackground;

-(void)showIntermediateView;

-(void)showMainCategoryView:(BOOL)showBackground;

//-----
//Release Methods

-(void)hideDataSyncManager;

-(void)releaseIntermediateView;

-(void)releaseMainCategoryView;

-(void)releaseProductDetailsView;

//Button Actions

-(IBAction)logoButtonClicked:(id)sender;

-(IBAction)subCategoryButtonClicked:(id)sender;

-(IBAction)downloadButtonClicked:(id)sender;

-(IBAction)signoutButtonClicked:(id)sender;

-(IBAction)settingsButtonClicked:(id)sender;

-(IBAction)browseButtonClicked:(id)sender;

-(IBAction)NavigationViewMinimizeButtonClicked:(id)sender;

- (IBAction) navigationBackButtonClicked:(id)sender;

-(void)resetLeftNavigationViewForSubCategorySelection;

- (void)productDidSelectedWithProductID:(int)productId;


@end