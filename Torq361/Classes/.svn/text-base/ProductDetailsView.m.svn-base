    //
//  ProductDetailsView.m
//  Torq361
//
//  Created by Nithin George on 19/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailsView.h"

#import "ProductDetails.h"
#import "AppTmpData.h"
#import "Torq361AppDelegate.h"
#import "Home.h"
#import "AppTmpData.h"
#import "DatabaseManager.h"
#import "ImageViewer.h"
#import "PDFViewer.h"
#import "VideoViewer.h"
#import "FaceBook_iPad.h"


#import "UserCredentials.h"
#import "CategoryDetails.h"

@implementation ProductDetailsView

@synthesize productIndex, productName, descriptionButtonImage, textView, textBackgroundView, thumbnailScrollView, contentScrollView, selectionButtonView, thumbnailSelectionImage;


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
	
	if ([[AppTmpData sharedManager]getDeviceOrientation]) {
		
		[self setPortraitView];
	}
	
	else {
	
		[self setLandscapeView];
	
	}

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(removeContentViewer) 
												 name:@"KRemoveContentViewer"
											   object:nil];
	
	[self addTouchGestureToScrollView];
	
	productDetails = (ProductDetails *)[[[AppTmpData sharedManager]getProductDetailsArray]objectAtIndex:productIndex];
	
	[self initializeView];
	
	[self allocThumbnailScrollView];
	[self loadImageArray];
	productDetailsTextView.text = productDetails.Description;
}

#pragma mark -
#pragma mark Initializing Views

- (void)initializeView {
	
	productName.text = productDetails.Name;
	
	textView.text = productDetails.Description;
	
	//NSString *temp = productDetails.idProduct;

	//int productId = (ProductDetails *)productDetails.idProduct;
	
}

- (void)setPortraitView {
	
	//thumbnailScrollView.frame = CGRectMake(20, 390, 332, 77);
	
	self.view.frame = CGRectMake(0, 0, 768, 1024);
	
	//selectionButtonView.frame = CGRectMake(15, 592, 468, 61);
	
	textBackgroundView.frame = CGRectMake(20, 512, 730, 466);
    textView.frame = CGRectMake(20, 17, 680, 429);
	
	if (imageViewer) {
		
		[imageViewer setPortraitView];
	}
}

- (void)setLandscapeView {
	
		//thumbnailScrollView.frame = CGRectMake(20, 390, 332, 77);
	
	self.view.frame = CGRectMake(0, 0, 1024, 748);
	
	///selectionButtonView.frame = CGRectMake(15, 509, 468, 61);
	
	textBackgroundView.frame = CGRectMake(20, 512, 985, 210);
    textView.frame = CGRectMake(20, 17, 938, 173);
	
	if (imageViewer) {
		
		[imageViewer setLandscapeView];
	}
}

- (void)addTouchGestureToScrollView {
	

	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTapOnScrollView)];
	[singleTap setNumberOfTapsRequired:1];
	[singleTap setNumberOfTouchesRequired:1];
	[contentScrollView addGestureRecognizer:singleTap];
	[singleTap release];
	
}

#pragma mark -

#pragma mark Allocating ScrollViews and Images

- (void)allocThumbnailScrollView {
	
    
    NSLog(@"RETAIN COUNT 020 %d", [self retainCount]);
    
    
	contentPaths = [[NSMutableArray alloc]init];
	imagePathArray = [[NSMutableArray alloc]init];
	pdfPathArray = [[NSMutableArray alloc]init];
	videoPathArray = [[NSMutableArray alloc]init];
	
	NSMutableArray *tempArray;
	
	// get Image paths
	tempArray = [[DatabaseManager sharedManager]getImagePathArrayForProductID:productDetails.idProduct];
	
	imageCount = [tempArray count];
	
	[contentPaths addObjectsFromArray:tempArray];
	[imagePathArray addObjectsFromArray:tempArray];
	
	tempArray =nil;
	
	// get pdf paths
	tempArray = [[DatabaseManager sharedManager]getPDFPathArrayForProductID:productDetails.idProduct];
	
	pdfCount = [tempArray count];
	
	[contentPaths addObjectsFromArray:tempArray];
	[pdfPathArray addObjectsFromArray:tempArray];
	
	tempArray =nil;
	
	// get Video paths
	tempArray = [[DatabaseManager sharedManager]getVideoPathArrayForProductID:productDetails.idProduct];
	
	videoCount = [tempArray count];
	
	[contentPaths addObjectsFromArray:tempArray];
	[videoPathArray addObjectsFromArray:tempArray];
	
	tempArray =nil;			  
	int thumbnailCount = imageCount + pdfCount + videoCount;

	contentScrollView.contentSize = CGSizeMake(thumbnailCount * 340, 0);//contentScrollView.contentSize = CGSizeMake(thumbnailCount * 340, 0);
	contentScrollView.pagingEnabled = YES;
	
	int x, y;
	
	if (thumbnailCount > 0) {
	
		thumbnailSelectionImage.frame = CGRectMake(x , y, 67, 67);
		[thumbnailSelectionImage setHidden:NO];
		
		
	}
	
	if (thumbnailCount > 6) {
		
		thumbnailScrollView.contentSize = CGSizeMake(457 + (thumbnailCount-6)*10 , 0);//*70
		//thumbnailScrollView.contentSize = CGSizeMake(457 + (thumbnailCount-6)*70 , 0);//*70
	}
    
        NSLog(@"RETAIN COUNT 025 %d", [self retainCount]);
	
}


- (void)loadImageArray {
	
	  NSLog(@"RETAIN COUNT 050 %d", [self retainCount]);
	//contentImages = [[NSMutableArray alloc]initWithCapacity:[contentPaths count]];
	
	if (imageStoreArray) {
		
		[imageStoreArray release];
		
		imageStoreArray = nil;
	}
	
	tempVideoFrameImage = [[NSMutableArray alloc]init];
	imageStoreArray     = [[NSMutableArray alloc]init];//For storing model class object
	videoFrameTime      =  [[NSMutableArray alloc]init];
	

	for (int i=0; i < [contentPaths count]; i++) {
		
		x = 14 + (i * 340);//gap inthe contentscrollview
		
		y = 14 + (i * 52);//gap between the image in thumbsrcrollview
		
		NSArray *objExtension = [[contentPaths objectAtIndex:i] componentsSeparatedByString:@"/"];
		//For finding whether the it is image or pdf or video
		NSArray *objExtensionn = [[contentPaths objectAtIndex:i] componentsSeparatedByString:@"/"];

		NSString *hi = [objExtension lastObject];//image_ or pdf_ or video_
		NSArray *firstSplit = [hi componentsSeparatedByString:@"_"];
		NSString *firstValue = [firstSplit objectAtIndex:0];//image or pdf or video

		
		if ([firstValue isEqualToString:@"image"]) { 
	
			//For finding the correct image path for the selected image's content image path
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentPath = [paths objectAtIndex:0];
			NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
			NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductContent/Portrait/image",@"CompanyId",companyid]];///Users/rinishrvs/Library/Application Support/iPhone Simulator/4.2/Applications/BCA8AB2A-1ABE-4907-A4BC-803637928FE0/Documents/CompanyId1/CatagoryThumb
			
			NSString *strDownloadDestiantionPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
			
			
			//Model class object
			imageStore = [[ImageStore alloc]init];
			
			if ([[NSFileManager defaultManager]fileExistsAtPath:strDownloadDestiantionPath]) {
				
				image = [[UIImage alloc]initWithContentsOfFile:strDownloadDestiantionPath];
				
				imagePresent = 1;
				
				imageStore.imageFrame     = image;
				imageStore.downloadStatus = 1;
				
			}
			
			else {
				
				image = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"icon_image" ofType:@"png"]];

				imagePresent = 2;
				
				imageStore.imageFrame     = image;
				imageStore.downloadStatus = 0;
			}

			[imageStoreArray addObject:imageStore];
			[imageStore release];
			
			//==========image adding to the content scrollview=====
			 
			[self addViewToContentScrollView];
			
			//==========image adding to the thumb scrollview=====
			
			[self addViewToThumScrollView:i];
			

		}
		
		else if ([firstValue isEqualToString:@"pdf"]) {  // pdf. eg : pdf/12_file.pdf
			
		
			//For finding the correct image path for the selected image's content image path
			NSArray *objExtension = [[contentPaths objectAtIndex:i] componentsSeparatedByString:@"/"];       //NSArray *objExtension = [[contentPaths objectAtIndex:index] componentsSeparatedByString:@"/"];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentPath = [paths objectAtIndex:0];	
			NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
			NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductContent/Portrait/pdf",@"CompanyId",companyid]];		
			NSString *pdfPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
			
			pdfImageCreater = [[PDFImageCreater alloc] initWithPdfName:pdfPath];
			
			image = [pdfImageCreater initialize:1 :YES];
			
			//Model class object
			imageStore = [[ImageStore alloc]init];
			
			if ([[NSFileManager defaultManager]fileExistsAtPath:pdfPath]) {
			
				pdfPresent = 1;
				imageStore.imageFrame     = image;
				imageStore.downloadStatus = 1;
			}
			else {
				
				pdfPresent = 2;
				imageStore.imageFrame     = image;
				imageStore.downloadStatus = 0;
			}
			
			[imageStoreArray addObject:imageStore];
			[imageStore release];

            
 			//==========image adding to the content scrollview=====
			videoFrameCreater = [[VideoFrameCreater alloc]init];
			videoFrameCreater.frame =CGRectMake(x , 0, 300, 300);
			
			videoFrameCreater.xAxix  = 0;
			videoFrameCreater.yAxix  = 0;
			videoFrameCreater.wWidth = 300;
			videoFrameCreater.hHight = 300;
			videoFrameCreater.xLabel = 50;
			videoFrameCreater.yLabel = 40;
			
			
			if (pdfPresent == 2) {//not downloaded
				
				videoFrameCreater.actindicatorSetValue = 11;
			}
			
            UIImage *myPdfImageOnContentScroll;
            myPdfImageOnContentScroll = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"pdfImageOnContentScroll" ofType:@"png"]];
            
			videoFrameCreater.frameCheckVariable = 1;
			
			videoFrameCreater.thumnailImage = [[imageStoreArray lastObject] imageFrame];
			
			//videoFrameCreater.timeLabel     = [videoFrameTime lastObject]; 
			
			videoFrameCreater.playImage      = myPdfImageOnContentScroll;
			
			[contentScrollView addSubview:videoFrameCreater];
			
			[videoFrameCreater release];
            
            
            [myPdfImageOnContentScroll release];
            myPdfImageOnContentScroll = nil;
			
			
			//==========image adding to the thumb scrollview=====
			
			videoFrameCreater = [[VideoFrameCreater alloc]init];
			videoFrameCreater.frame =CGRectMake(y, 0, 300, 300);
			
			videoFrameCreater.xAxix  = 0;
			videoFrameCreater.yAxix  = 0;
			videoFrameCreater.wWidth = 45;//65;
			videoFrameCreater.hHight = 45;//65;
			videoFrameCreater.xLabel = 50;
			videoFrameCreater.yLabel = 40;
			
			
			if (pdfPresent == 2) {//not downloaded
				
				videoFrameCreater.actindicatorSetValue = 1;
			}
            
            UIImage *myPdfImage;
            myPdfImage = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"pdfImage" ofType:@"png"]];
            
			
			videoFrameCreater.delegate = self;
			
			videoFrameCreater.frameCheckVariable = 1;
			
			videoFrameCreater.tagValue      = i;
			
			videoFrameCreater.thumnailImage = [[imageStoreArray lastObject] imageFrame];
			
			//videoFrameCreater.timeLabel     = [videoFrameTime lastObject]; 
			
			videoFrameCreater.playImage     = myPdfImage;	
			
			[thumbnailScrollView addSubview:videoFrameCreater];
			
			[videoFrameCreater release];
            
            [myPdfImage release];
            myPdfImage = nil;
			
		}
		
		else if ([firstValue isEqualToString:@"video"]) { 
			
            NSLog(@"RETAIN COUNT v010 %d", [self retainCount]);
			//For finding the correct image path for the selected image's content image path
			NSArray *objExtension = [[contentPaths objectAtIndex:i] componentsSeparatedByString:@"/"];       //NSArray *objExtension = [[contentPaths objectAtIndex:index] componentsSeparatedByString:@"/"];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentPath = [paths objectAtIndex:0];	
			NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
			NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductContent/Portrait/video",@"CompanyId",companyid]];		
			NSString *strDownloadDestiantionPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
			
			
			//Model class object
			imageStore = [[ImageStore alloc]init];
			
			if ([[NSFileManager defaultManager]fileExistsAtPath:strDownloadDestiantionPath]) {
				
				videoPresent = 1;
				NSURL* videoURL = [NSURL fileURLWithPath:strDownloadDestiantionPath];
				moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
				[[NSNotificationCenter defaultCenter] addObserver:self
														 selector:@selector(moviePlayerPlaybackDuration:)
															 name:MPMoviePlayerPlaybackStateDidChangeNotification
														   object:moviePlayer];
				NSTimeInterval time       = 0.20;
				imageStore.imageFrame     = [moviePlayer thumbnailImageAtTime:time
																  timeOption:MPMovieTimeOptionNearestKeyFrame];
				imageStore.downloadStatus = 1;
				
				[moviePlayer play];
				
				
				if(moviePlayer){
					
					[moviePlayer stop];
					
					[moviePlayer release];
					
					moviePlayer = nil;
				}
				
			}
			
			else {
				
				videoPresent = 2;
				image = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"noVideoImage" ofType:@"png"]];
				
				imageStore.imageFrame     = image;
				imageStore.downloadStatus = 0;
                [image release];
                image = nil;
			}
			
			NSLog(@"RETAIN COUNT v019 %d", [self retainCount]);
			[imageStoreArray addObject:imageStore];
			[imageStore release];


			
			//==========image adding to the content scrollview=====
			
			videoFrameCreater = [[VideoFrameCreater alloc]init];
			videoFrameCreater.frame =CGRectMake(x , 0, 300, 300);
			
			videoFrameCreater.xAxix  = 0;
			videoFrameCreater.yAxix  = 0;
			videoFrameCreater.wWidth = 300;
			videoFrameCreater.hHight = 300;
			videoFrameCreater.xLabel = 200;
			videoFrameCreater.yLabel = 130;
			
			
			//For selecting the playimage large or small
			videoFrameCreater.frameCheckVariable = 3;

			videoFrameCreater.thumnailImage = [[imageStoreArray lastObject] imageFrame];
			
			if ([[imageStoreArray lastObject] downloadStatus] == 0) {//not downloaded for setting the activity indicator
				
				videoFrameCreater.actindicatorSetValue = 11;
			}
            NSLog(@"RETAIN COUNT v025 %d", [self retainCount]);
            UIImage *myPlayImage;
            myPlayImage = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"playButton" ofType:@"png"]];
            

            videoFrameCreater.timeLabel     = [videoFrameTime lastObject]; 
			videoFrameCreater.playImage     = myPlayImage;
			
			[contentScrollView addSubview:videoFrameCreater];
			[videoFrameCreater release];
            
            NSLog(@"RETAIN COUNT v026 %d", [self retainCount]);
            
            [myPlayImage release];
            myPlayImage = nil;
            
			
			//==========image adding to the thumb scrollview=====
			
			videoFrameCreater = [[VideoFrameCreater alloc]init];
			videoFrameCreater.frame =CGRectMake(y, 0, 300, 300);
			
			videoFrameCreater.xAxix  = 0;
			videoFrameCreater.yAxix  = 0;
			videoFrameCreater.wWidth =45;// 65;
			videoFrameCreater.hHight =45;// 65;
			videoFrameCreater.xLabel = 10;//33;
			videoFrameCreater.yLabel = 15;//28;
			
			
			videoFrameCreater.frameCheckVariable = 2;
			
			videoFrameCreater.tagValue      = i;
			

			//setting the activity indicator
			
             
            
			videoFrameCreater.thumnailImage = [[imageStoreArray lastObject] imageFrame];
			
			if ([[imageStoreArray lastObject] downloadStatus] == 0) {
				
				videoFrameCreater.actindicatorSetValue = 1;
			}
            
            UIImage *myPlayImageOnThumbScroll;
            myPlayImageOnThumbScroll = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"playButtonOnThumbScroll" ofType:@"png"]];
			
			videoFrameCreater.timeLabel     = [videoFrameTime lastObject]; 
			videoFrameCreater.playImage     = myPlayImageOnThumbScroll;	
			
			[thumbnailScrollView addSubview:videoFrameCreater];
            videoFrameCreater.delegate = self;
			[videoFrameCreater release];
            
            NSLog(@"RETAIN COUNT v029 %d", [self retainCount]);	
            
			[image release];
			image = nil;
            
            [myPlayImageOnThumbScroll release];
            myPlayImageOnThumbScroll = nil;
            
	       NSLog(@"RETAIN COUNT v030 %d", [self retainCount]);
            
		}
	}
}



#pragma mark -
#pragma mark Methods for MoviePlayer

-(void)moviePlayerPlaybackDuration:(NSNotification *)notification {
	
	
	NSLog(@"Movie Player moviePlayerPlaybackDuration Finished!!!....");
	NSTimeInterval durTime = moviePlayer.duration;
	int mode = durTime;
	
	int second = mode % 60;
	
	durTime = durTime/60;
	
	int minute = durTime;
	
	NSString *videoDuration = [NSString stringWithFormat:@"%d:%d",minute,second];
	
	[videoFrameTime addObject:videoDuration];
	
	//NSLog(@"duration======%@",[thumbVideoTime lastObject]);
	
	if(moviePlayer){
        NSLog(@"RETAIN COUNT movieplayer1 %d", [moviePlayer retainCount]);
        
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:moviePlayer];
        NSLog(@"RETAIN COUNT movieplayer2 %d", [moviePlayer retainCount]);
        [moviePlayer stop];
		[moviePlayer release];
		moviePlayer = nil;
        
        NSLog(@"RETAIN COUNT movieplayer3 %d", [moviePlayer retainCount]);
	}
}




#pragma mark -
#pragma mark methods to add scrollView

- (void)addViewToContentScrollView {
	
	videoFrameCreater = [[VideoFrameCreater alloc]init];
	videoFrameCreater.frame =CGRectMake(x , 0, 300, 300);
	
	videoFrameCreater.xAxix  = 0;
	videoFrameCreater.yAxix  = 0;
	videoFrameCreater.wWidth = 300;
	videoFrameCreater.hHight = 300;
	videoFrameCreater.xLabel = 50;
	videoFrameCreater.yLabel = 40;
	
	
	videoFrameCreater.playImage     = [[imageStoreArray lastObject] imageFrame];
	
	if (imagePresent == 2) {//not downloaded
		
		videoFrameCreater.actindicatorSetValue = 11;
	}
	
	[contentScrollView addSubview:videoFrameCreater];
	
	[videoFrameCreater release];
	
}

- (void)addViewToThumScrollView:(id)index{
	
	
	videoFrameCreater = [[VideoFrameCreater alloc]init];
	videoFrameCreater.frame =CGRectMake(y, 0, 65, 65);
	
	videoFrameCreater.xAxix  = 0;
	videoFrameCreater.yAxix  = 0;
	videoFrameCreater.wWidth = 45;//65;
	videoFrameCreater.hHight = 45;//65;
	videoFrameCreater.xLabel = 50;
	videoFrameCreater.yLabel = 40;
	
	videoFrameCreater.delegate = self;
	videoFrameCreater.tagValue      = index;
	videoFrameCreater.playImage     = [[imageStoreArray lastObject] imageFrame];
	
	if (imagePresent == 2) {//not downloaded
		
		videoFrameCreater.actindicatorSetValue = 1;
	}
	
	[thumbnailScrollView addSubview:videoFrameCreater];
	[videoFrameCreater release];
	
	
	[image release];
	image = nil;
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)facebookButtonClicked:(id)sender {
	
	[self dismissPopoverController];
	
	int index = (contentScrollView.contentOffset.x)/340;
	
	FaceBook_iPad *faceBookView = [[FaceBook_iPad alloc]initWithNibName:@"FaceBook_iPad" bundle:nil];
	
	faceBookView.strProductName     = productDetails.Name;
	faceBookView.strPdtDescription  = productDetails.Description;
	faceBookView.strImageUrl        = [contentPaths objectAtIndex:index];
	faceBookView.strProductURL      = [contentPaths objectAtIndex:index];
	faceBookView.strStyleNumber     = @"E405AE";
	faceBookView.shareDelagate      = self;
	
	popOverControllerView=[[UIPopoverController alloc] initWithContentViewController:faceBookView];
	popOverControllerView.delegate=self;
	

	
	if([[AppTmpData sharedManager]getDeviceOrientation]){
		
		[popOverControllerView presentPopoverFromRect:[sender frame] inView:shareView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	}
	else {
		[popOverControllerView presentPopoverFromRect:[sender frame] inView:shareView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	}
    [popOverControllerView  setPopoverContentSize:CGSizeMake(300,350) animated:NO];	
	
	
	[faceBookView release];

}

- (IBAction)twitterButtonClicked:(id)sender {
	
	int index = (contentScrollView.contentOffset.x)/340;
	
	[self dismissPopoverController];

	
	Share *twitterView = [[Share alloc]initWithNibName:@"ShareView" bundle:nil];
	
	NSString *selectedItemDetails = [NSString stringWithFormat:@"%@"
					  ,[contentPaths objectAtIndex:index]];
	
	twitterView.twitterShareData = selectedItemDetails;
	
	twitterView.shareDelagate    = self;
	
	popOverControllerView=[[UIPopoverController alloc] initWithContentViewController:twitterView];
	popOverControllerView.delegate=self;
	
	if([[AppTmpData sharedManager]getDeviceOrientation]){
		
		[popOverControllerView presentPopoverFromRect:[sender frame] inView:shareView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	}
	else {
		[popOverControllerView presentPopoverFromRect:[sender frame] inView:shareView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    [popOverControllerView  setPopoverContentSize:CGSizeMake(300,350) animated:NO];	
	

	
	[twitterView release];
}

- (IBAction)mailButtonClicked:(id)sender {
	
	if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"This device can not send emails. Please set up a valid email account." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
	else {
		
		 if (sharePaths) {
			 
			 [sharePaths release];
			 sharePaths = nil;
			 sharePaths = [[NSMutableArray alloc]init];
		 }
		
		else {
			
			sharePaths = [[NSMutableArray alloc]init];
		}

		int index = (contentScrollView.contentOffset.x)/340;
		
		[self getSharePaths:index];
		
		NSData *data  = [[NSData alloc] initWithContentsOfFile:[sharePaths objectAtIndex:0]];
		
		[self seetingMailBodyComponents:data:[sharePaths objectAtIndex:1]:[sharePaths objectAtIndex:2]];
		
	}
	
}


- (void)getSharePaths:(int)index {
	
	NSArray *objExtension = [[contentPaths objectAtIndex:index] componentsSeparatedByString:@"/"];       
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [paths objectAtIndex:0];	
	NSString *companyid = [[UserCredentials sharedManager]getCompanyID];

	NSString *hi = [objExtension lastObject];//image_ or pdf_ or video_
	NSArray *firstSplit = [hi componentsSeparatedByString:@"_"];
	NSString *firstValue = [firstSplit objectAtIndex:0];//image or pdf or video
	
	if ([firstValue isEqualToString:@"image"]) {
		
		NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@1/ProductContent/Portrait/image",@"CompanyId",companyid]];		
		NSString *mailAttachPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
		
		[sharePaths addObject:mailAttachPath];
		
		NSArray *objEgfhfxtension = [[contentPaths objectAtIndex:index] componentsSeparatedByString:@"."];  
		NSString *hi = [objExtension lastObject];
		NSArray *firstSplit = [hi componentsSeparatedByString:@"."];
		NSString *fileType = [firstSplit lastObject];
		
		[sharePaths addObject:fileType];
		
		[sharePaths addObject:[objExtension lastObject]];//file name adding
	}
	
	else if ([firstValue isEqualToString:@"pdf"]) {
		
		NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@1/ProductContent/Portrait/pdf",@"CompanyId",companyid]];		
		NSString *mailAttachPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
		
		[sharePaths addObject:mailAttachPath];
		
		NSArray *objEgfhfxtension = [[contentPaths objectAtIndex:index] componentsSeparatedByString:@"."];  
		NSString *hi = [objExtension lastObject];
		NSArray *firstSplit = [hi componentsSeparatedByString:@"."];
		NSString *fileType = [firstSplit lastObject];
		
		[sharePaths addObject:fileType];
		
		[sharePaths addObject:[objExtension lastObject]];//file name adding
		
	}
	
	else if ([firstValue isEqualToString:@"video"]) {
	
		NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@1/ProductContent/Portrait/video",@"CompanyId",companyid]];		
		NSString *mailAttachPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
		
		[sharePaths addObject:mailAttachPath];
		
		NSArray *objEgfhfxtension = [[contentPaths objectAtIndex:index] componentsSeparatedByString:@"."];  
		NSString *hi = [objExtension lastObject];
		NSArray *firstSplit = [hi componentsSeparatedByString:@"."];
		NSString *fileType = [firstSplit lastObject];
		
		[sharePaths addObject:fileType];
		
		[sharePaths addObject:[objExtension lastObject]];//file name adding
		
	}
	
}



- (IBAction)descriptionButtonClicked:(id)sender {

	UIButton *button = (UIButton *)sender;
	
	UIImage *image;
	
	if (button.tag == 0) {  // Description selected
		
	/*	image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"description_clicked" ofType:@"png"]];
		
		descriptionButtonImage.image = image;
		
		textView.text = productDetails.Description;
		
		if ([productDetails.Description isEqualToString:@""] || productDetails.Description == nil) {
			
			textView.text = @"No Description Provided";
		}
		
		
	*/	
		
	}
	
	else if(button.tag == 1) { // product details selected
		
		image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"newProdDetails_clicked" ofType:@"png"]];
		
		descriptionButtonImage.image = image;
		
		textView.text = productDetails.prodDetails;
		
		if ([productDetails.prodDetails isEqualToString:@""] || productDetails.prodDetails == nil) {
			
			textView.text = @"No Product Details Provided";
		}
		
	}
	
	else {  // technical details selected
		
		image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"newTechDetails_clicked" ofType:@"png"]];
		
		descriptionButtonImage.image = image;
		
		textView.text = productDetails.techDetails;
			
		if ([productDetails.techDetails isEqualToString:@""] || productDetails.prodDetails == nil) {
			
			textView.text = @"No Technical Details Provided";
		}
		
	}
	
	[image release];
	
	image = nil;
}


/*- (void)thumbnailButtonClicked:(id)sender {

	UIButton *button = (UIButton *)sender;
	
	contentScrollView.contentOffset = CGPointMake(340 * button.tag, 0);
	
	NSLog(@"Clicked Content path : %@",[contentPaths objectAtIndex:button.tag]);
		
	thumbnailSelectionImage.frame = CGRectMake(button.frame.origin.x - 4 , button.frame.origin.y - 5, 67, 61);
	
	
}*/

- (IBAction)backButtonClicked:(id)sender {
	
	@try {
		
		[self releaseMemory];
		//[self dealloc];
		Torq361AppDelegate *appDelegate = (Torq361AppDelegate *)[UIApplication sharedApplication].delegate;
		
		[appDelegate.home releaseProductDetailsView];
	}

	@catch (NSException * e) {
		NSLog(@"Exception: %@", e);
	}
	@finally {
		NSLog(@"finally");
	}
	
   // NSLog(@"RETAIN COUNT IS:-%d",[self retainCount]);	
	
}
 

- (void)thumbnailButtonClicked:(int)arrayIndex {
	
	//[moviePlayer stop];
	
	NSLog(@"Array Index IS========%d",arrayIndex);
	
	contentScrollView.contentOffset = CGPointMake((340*arrayIndex), 0);
	
}

#pragma mark -

-(void)dismissPopoverController{
	
	if (popOverControllerView) {
		[popOverControllerView dismissPopoverAnimated:NO];
		popOverControllerView=nil;
	}
}


#pragma mark -
#pragma mark Mail delegate


- (void)seetingMailBodyComponents:(NSData *)data:(NSString *)mimeType:(NSString *)fileName {
	
	
    MFMailComposeViewController *mailController = [[[MFMailComposeViewController alloc] init] autorelease];
	[mailController addAttachmentData:data mimeType:mimeType fileName:fileName];
	[mailController setSubject:@"Torq 361 Files"];

	[mailController setTitle:@"tillte"];
	//[mailController setMessageBody:@"Kai Engelhardt is cool, because he taught me how to send EMails with the iPhone!" isHTML:false];
    mailController.mailComposeDelegate = self;
    [self presentModalViewController:mailController animated:true];
	
}



-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EMailsendung fehlgeschlagen!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [controller dismissModalViewControllerAnimated:true];
}




#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
	//[self loadImageArray]; //For Reloading the images

	if (scrollView == thumbnailScrollView) {
		
		int index = (thumbnailScrollView.contentOffset.x)/50;
		
		//Will be Two value 0 or 3.0 means starting 3 means last positions to the content scrollview
		if (index == 3) {
			
			index = (imageCount + pdfCount + videoCount)-1;
		}
		
		contentScrollView.contentOffset = CGPointMake((340*index), 0);
	}
	
	
	if (scrollView == contentScrollView) {
		
		int index = (contentScrollView.contentOffset.x)/340;
		

		
		if (index>((imageCount + pdfCount + videoCount)-5)) {
			
		}
		
		else {
			
			thumbnailScrollView.contentOffset = CGPointMake((40*index), 0);
			
		}

		
		//UIButton *button = (UIButton *)[thumbnailButtons objectAtIndex:index];
		
		//thumbnailSelectionImage.frame = CGRectMake(button.frame.origin.x - 4 , button.frame.origin.y - 5, 67, 61);
		
	}
	
	
}


#pragma mark -
#pragma mark image or  Pdf or Video selection

- (void)didSingleTapOnScrollView {
	
	int index = (contentScrollView.contentOffset.x)/340;
	
	if (index < imageCount) {
		
		//For finding the correct image path for the selected image's content image path
		NSArray *objExtension = [[contentPaths objectAtIndex:index] componentsSeparatedByString:@"/"];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentPath = [paths objectAtIndex:0];
		NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
		NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductContent/Portrait/image",@"CompanyId",companyid]];///Users/rinishrvs/Library/Application Support/iPhone Simulator/4.2/Applications/BCA8AB2A-1ABE-4907-A4BC-803637928FE0/Documents/CompanyId1/CatagoryThumb
		
		NSString *strDownloadDestiantionPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
		
		if ([[NSFileManager defaultManager]fileExistsAtPath:strDownloadDestiantionPath]) {
		
			imageViewer = [[ImageViewer alloc]initWithNibName:@"ImageViewer" bundle:nil];
			imageViewer.imageArray =imagePathArray;
			imageViewer.imageCount = imageCount;
			imageViewer.offset = index;
			[self.view addSubview:imageViewer.view];
            [imageViewer release];
            //imageViewer = nil;

		}
		
	}
	
	else if (index < (imageCount + pdfCount)) {

		//For finding the correct image path for the selected image's content image path
		NSArray *objExtension = [[contentPaths objectAtIndex:index] componentsSeparatedByString:@"/"];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentPath = [paths objectAtIndex:0];	
		NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
		NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductContent/Portrait/pdf",@"CompanyId",companyid]];		
		NSString *strDownloadDestiantionPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
		
		if ([[NSFileManager defaultManager]fileExistsAtPath:strDownloadDestiantionPath]) {
		
			pdfViewer = [[PDFViewer alloc]initWithNibName:@"PDFViewer" bundle:nil];
			pdfViewer.pdfPath = strDownloadDestiantionPath;
			pdfViewer.offset = index;
			[self.view addSubview:pdfViewer.view];
            [pdfViewer release];
            // pdfViewer = nil;
		
		}
		
		else {
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Sorry DownLoad Is Not Complete, So Please Wait" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];

			[alert show];
			[alert release];
		}

	}
	
	else if(index < (imageCount + pdfCount + videoCount)) {
		
		if (videoFrameImage) {
			
			[videoFrameImage release];
			videoFrameImage = nil;
			videoFrameImage     = [[NSMutableArray alloc]init];
		}
		
		else {
			
			videoFrameImage     = [[NSMutableArray alloc]init];
		
		}

		//Video downloaded
		if ([[imageStoreArray objectAtIndex:index] downloadStatus] == 1) {
			
			int initalValue = (imageCount + pdfCount);
			
			int lastValue   = (imageCount + pdfCount + videoCount);
			
			for (int i = initalValue ; i<lastValue; i++) {
				
				[videoFrameImage addObject:[imageStoreArray objectAtIndex:i]];
			}

			videoViewer = [[VideoViewer alloc]initWithNibName:@"VideoViewer" bundle:nil];
			videoViewer.currentSelectedPath = [contentPaths objectAtIndex:index];    // strDownloadDestiantionPath;
			videoViewer.thumbVideoImage = videoFrameImage;
			videoViewer.thumbVideoTime  = videoFrameTime;
			videoViewer.videoPath       = videoPathArray;
			videoViewer.videoCount      = videoCount;
			videoViewer.offset          = index;
			[self.view addSubview:videoViewer.view];
            [videoViewer release];
            videoViewer = nil;
			
		}
		
		else {
			
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Sorry DownLoad Is Not Complete, So Please Wait" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			
			[alert show];
			[alert release];
		}
		
	}
	

}

- (void)removeContentViewer {

	if (imageViewer) {
		
		[imageViewer.view removeFromSuperview];
		
		[imageViewer release];
		
		imageViewer = nil;
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

- (void)viewWillAppear:(BOOL)animated

{
	
}


-(void)releaseMemory {
	
    return;
		if (contentScrollView) {
			
			NSArray *contentViews=[contentScrollView subviews];
			
			for(id subview in contentViews){
				
				[subview removeFromSuperview];
			}
			
			[contentScrollView release];
			contentScrollView = nil;
		}
		
		
		if (thumbnailScrollView) {
			
			NSArray *thumbViews=[thumbnailScrollView subviews];
			
			for(id subview in thumbViews){
				
				[subview removeFromSuperview];
			}
			
			[thumbnailScrollView release];
			thumbnailScrollView = nil;
			
			NSLog(@"retaincount====%d",[thumbViews retainCount]);
		}
		
	
		if (imagePathArray) {
			
			[imagePathArray release];
			
			imagePathArray = nil;
			
			NSLog(@"retaincount====%d",[imagePathArray retainCount]);
		}
		
		if (pdfPathArray) {
			
			[pdfPathArray release];
			
			pdfPathArray = nil;
		}
		
		if (videoPathArray) {
			
			[videoPathArray release];
			
			videoPathArray = nil;
		}
		
	if (contentPaths) {
		
		[contentPaths release];
		
		contentPaths = nil;
	}
		

	
	if (videoFrameImage) {
		
		[videoFrameImage release];
		
		videoFrameImage = nil;
		NSLog(@"retaincount====%d",[videoFrameImage retainCount]);
	}
	
	if (tempVideoFrameImage) {
		
		[tempVideoFrameImage release];
		
		tempVideoFrameImage = nil;
		NSLog(@"retaincount====%d",[tempVideoFrameImage retainCount]);
	}
	
	
	if (videoFrameTime) {
		
		[videoFrameTime release];
		
		videoFrameTime = nil;
		NSLog(@"retaincount====%d",[videoFrameTime retainCount]);
	}
	
	if (sharePaths) {
		
		[sharePaths release];
		
		sharePaths = nil;
		NSLog(@"retaincount====%d",[sharePaths retainCount]);
	}
	
	if (videoFrameTime) {
		
		[videoFrameTime release];
		
		videoFrameTime = nil;
		NSLog(@"retaincount====%d",[videoFrameTime retainCount]);
	}
	
	if (textBackgroundView) {
		
		[textBackgroundView release];
		
		textBackgroundView = nil;
		NSLog(@"retaincount====%d",[textBackgroundView retainCount]);
	}
	

	
}


- (void)dealloc {
	
/*	if (contentImages) {
		
		[contentImages release];
		
		contentImages = nil;
	}
*/	
	if (imagePathArray) {
		
		[imagePathArray release];
		
		imagePathArray = nil;
	}
	
	if (pdfPathArray) {
		
		[pdfPathArray release];
		
		pdfPathArray = nil;
	}
	
	if (videoPathArray) {
		
		[videoPathArray release];
		
		videoPathArray = nil;
	}

    [super dealloc];
}


@end
