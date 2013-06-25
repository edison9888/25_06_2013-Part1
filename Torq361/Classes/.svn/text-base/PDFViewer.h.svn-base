//
//  PDFViewer.h
//  Torq361
//
//  Created by Nithin George on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomScrollView.h"
#import "ThumbCustomeCell.h"
#import "ThumbCustomeCellL.h"
#import "PrintHandler.h"
//#import "UIPopoverController.h"

@class PDFImageCreater;

@interface PDFViewer : UIViewController<UIScrollViewDelegate> {
	
	NSString *pdfPath;
	
	int pdfCount;
	
	int offset;
	
	int page;
	
	BOOL bBottomViewVisible;
	BOOL bCompressImageInProgress;
	BOOL bButtonClicked;
	
	PDFImageCreater *pdfImageCreater;
	
	IBOutlet UIView *tableView;
	IBOutlet UIView *indexView;
	
	IBOutlet UILabel *pageLabel;
	IBOutlet UIButton *forWordButton;
	IBOutlet UIButton *backWordButton;
	IBOutlet UIButton *backButton;
	IBOutlet UIButton *printButton;
	
	IBOutlet UIView *viewForEnteringPDFPageNumber;
	IBOutlet UIImageView *enterPageNumberImageView;
	IBOutlet UIButton *showPDFPageEnterScreen;
	IBOutlet UIButton *goToButton;
	IBOutlet UITextField *enterPageNumberField;
	
	UIPopoverController *popOverControllerView;	//For popovercontrollerview

	//IBOutlet UITableView *indexTable;
	
	UIImage *img;
	CustomScrollView *pdfScrollView;
	NSMutableArray *viewControllers;
	NSTimer *tableReloadTimer;
	NSOperationQueue *operationQueue;
	
	ThumbCustomeCell *cell;						//for the table for landscape $ portrite of the pdf thumb
	ThumbCustomeCellL *cellL;
	
	PrintHandler *printHandlerInstance;
    
    UIPopoverController *popoverController;
	

}
@property (nonatomic,retain)UIPopoverController *popoverController;
@property (nonatomic,retain)NSString *pdfPath;
@property (nonatomic)int pdfCount;
@property (nonatomic)int offset;

-(void)setPortraitView;
-(void)setLandscapeView;
-(void)adjustPortrate;
-(void)adjustLandscape;

-(void)backButtonClicked:(id)sender;
-(void)forWordButtonClicked:(id)sender;
-(void)backWordButtonClicked:(id)sender;

-(IBAction)showPDFPageEnterScreenButtonClicked:(id)sender;
-(IBAction)goCorrectPageButtonClicked:(id)sender;
- (IBAction)printButtonClicked:(id)sender;
- (void)goPDFCorrectPage:(NSInteger)GoToPageNumber;    //method for selecting the correct pdf page
-(void)indexButtonClicked:(id)sender;	//For thumb creater
-(void)performTransition;
-(void)beginCreatingThumb;
-(void)compressImage;
-(void)invalidateTableViewReloadTimer;
-(void)reloadTableViewThumb;
-(IBAction)selectPageClick:(id)sender;//while clicking the thumb image of the pdf file	

-(void)populateImages;
-(void)loadScrollViewWithPage:(int)ipage;
-(void)initializeView;
-(void)bottombarAnimation:(CGRect)frame;
-(void)singleTap;

-(void)OrientationDidChange:(UIDeviceOrientation)orientation;	//For catching the rotation

@end
