//
//  AppTmpData.m
//  Torq361
//
//  Created by Binoy on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppTmpData.h"


@implementation AppTmpData

static AppTmpData *appTmpData;

static NSString *deviceToken;

static BOOL deviceOrientation;

static int mainCategoryID;

static int iPdfMode;	//For PDF Reader

static NSString *mainCategoryName;

static int subCategoryID;

static NSString *subCategoryName;

static NSMutableArray *productDetailsArray;

// App Images

static UIImage *photoFrame;  
static UIImage *smallPhotoFrame;
static UIImage *PdfSymbolImage;
static UIImage *VideoSymbolImage;
static UIImage *NewBannerImage;
static UIImage *TickImage; 
static UIImage *categoryTableBG;
static UIImage *productTableBG;
static UIImage *productCellBG;
static UIImage *categoryCellBG;

//App Images


+(AppTmpData*)sharedManager{
	
	if (!appTmpData) {
		
		appTmpData=[[AppTmpData alloc] init];
		
	}
	
	return appTmpData;
}

#pragma mark -
#pragma mark Device Token

-(void)setDeviceTocken:(NSString*)token {

	deviceToken = token;
	
	[deviceToken retain];
}

-(NSString*)getDeviceTocken {
	
	return deviceToken;
	
}

#pragma mark -
#pragma mark Hepling for PDF Reading

- (int)getPDFMode {
	return iPdfMode;
}


#pragma mark -
#pragma mark Device Orientation

// deviceOrientation = YES for Portrait , deviceOrientation = NO for Landscape

-(void)setDeviceOrientation:(BOOL)orientation {
	
	deviceOrientation = orientation;
	
}

-(BOOL)getDeviceOrientation {
	
	return deviceOrientation;
	
}

#pragma mark -

#pragma mark Selected Category And Product

-(void)setSelectedMainCategoryID:(int)categoryID name:(NSString *)categoryName {
	
	mainCategoryID = categoryID;
	
	mainCategoryName = categoryName;
	
	[mainCategoryName retain];
	
}

-(int)getSelectedMainCategoryID {
	
	return mainCategoryID;
}

-(NSString *)getSelectedMainCategoryName {

	return mainCategoryName;
}

-(void)setSelectedSubCategoryID:(int)categoryID name:(NSString *)categoryName {
	
	subCategoryID = categoryID;
	
	subCategoryName = categoryName;
	
	[subCategoryName retain];
}

-(int)getSelectedSubCategoryID {
	
	return subCategoryID;
	
}

-(NSString *)getSelectedSubCategoryName {
	
	return subCategoryName;
	
}

#pragma mark -
#pragma mark Products Details Array

-(void)setProductDetailsArray:(NSMutableArray *)Arr {
	
	if (productDetailsArray) {
		[productDetailsArray release];
		productDetailsArray=nil;
	}
		
	productDetailsArray=[Arr mutableCopy];
	//[productDetailsArray retain];	
	
}


-(NSMutableArray*)getProductDetailsArray {
	
	return productDetailsArray;
}

#pragma mark -

#pragma mark AppImages

-(void)allocAppImages {
	
	
	photoFrame      = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PhotoFrame" ofType:@"png"]];
	smallPhotoFrame = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SmallPhotoFrame" ofType:@"png"]];
	PdfSymbolImage  = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Clip" ofType:@"png"]];
	VideoSymbolImage= [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Video" ofType:@"png"]];
	NewBannerImage  = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NewBanner" ofType:@"png"]];
	TickImage       = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tick_icon" ofType:@"png"]];
	categoryTableBG = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"categoryTable_bg" ofType:@"png"]];
	productTableBG  = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"productTable_bg" ofType:@"png"]];
	
	categoryCellBG  = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"categoryCell_bg" ofType:@"png"]];

	productCellBG   = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"productCell_bg" ofType:@"png"]];
}

-(void)clearAppImages {
		
	if (photoFrame) {
		
		[photoFrame release];
		photoFrame = nil;
	}
	if (smallPhotoFrame) {
		
		[smallPhotoFrame release];
		smallPhotoFrame = nil;
		
	}
	if (PdfSymbolImage) {
		
		[PdfSymbolImage release];
		PdfSymbolImage = nil;
		
	}
	if (VideoSymbolImage) {
		
		[VideoSymbolImage release];
		VideoSymbolImage = nil;
	}
	if (TickImage) {
		
		[TickImage release];
		TickImage = nil;
		
	}
	if (NewBannerImage) {
		
		[NewBannerImage release];
		NewBannerImage = nil;
		
	}
	if (categoryTableBG) {
		
		[categoryTableBG release];
		categoryTableBG = nil;
		
	}
	if (productTableBG) {
		
		[productTableBG release];
		productTableBG = nil;
	}
	
	if (productCellBG) {
		
		[productCellBG release];
		productCellBG = nil;
	}
	
	if (categoryTableBG) {
		
		[categoryTableBG release];
		categoryTableBG = nil;
	}
	
}


-(UIImage *)getImageByName:(NSString *)name {
	
	if ([name isEqualToString:@"Clip"]) {
		return PdfSymbolImage;
	}
	else if ([name isEqualToString:@"Video"]) {
		return VideoSymbolImage;
	}
	else if ([name isEqualToString:@"PhotoFrame"]) {
		return photoFrame;
	}
	else if ([name isEqualToString:@"SmallPhotoFrame"]) {
		return smallPhotoFrame;
	}
	else if ([name isEqualToString:@"NewBanner"]) {
		return NewBannerImage;
	}
	else if ([name isEqualToString:@"tick_icon"]) {
		return TickImage;
	}
	else if ([name isEqualToString:@"CategoryTableBG"]) {
		return categoryTableBG;
	}
	else if ([name isEqualToString:@"ProductTableBG"]) {
		return productTableBG;
	}
	else if ([name isEqualToString:@"ProductCellBG"]) {
		return productCellBG;
	}
	else if ([name isEqualToString:@"CategoryCellBG"]) {
		return categoryCellBG;
	}
	
	return nil;
}

#pragma mark -


@end
