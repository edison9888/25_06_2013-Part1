    //
//  PDFViewer.m
//  Torq361
//
//  Created by Nithin George on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFViewer.h"
#import "CustomScrollView.h"
#import "AppTmpData.h"
#import "PDFImageCreater.h"
#import "PDFPageSearch.h"


@implementation PDFViewer

@synthesize pdfPath, pdfCount, offset;
@synthesize popoverController;


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


- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(OrientationDidChange:)
												 name:UIDeviceOrientationDidChangeNotification
											   object:nil];
	
	pdfImageCreater = [[PDFImageCreater alloc] initWithPdfName:pdfPath];	//For creating the images for the particular PDF
	
	pdfCount=pdfImageCreater.iTotalPages;
    
    //[pdfImageCreater release];
    //pdfImageCreater = nil;
	
	[self initializeView];
	

}


#pragma mark -
#pragma mark For image on scrollview


-(void)initializeView {
	
	forWordButton.hidden=YES;
	backWordButton.hidden=YES;
	
	pdfScrollView=[[CustomScrollView alloc]init];
	[self.view addSubview:pdfScrollView];
	[self.view bringSubviewToFront:backButton];
	[self.view bringSubviewToFront:forWordButton];
	[self.view bringSubviewToFront:backWordButton];
	[self.view bringSubviewToFront:pageLabel];
	[self.view bringSubviewToFront:showPDFPageEnterScreen];
	[self.view bringSubviewToFront:printButton];
	
	[self.view addSubview:viewForEnteringPDFPageNumber];
	[self.view bringSubviewToFront:viewForEnteringPDFPageNumber];
	viewForEnteringPDFPageNumber.hidden = YES;
	//enterPageNumberField.delegate       = self;
	
	if([[AppTmpData sharedManager]getDeviceOrientation]){
		
		[self setPortraitView];
	}
	else {
		
		[self setLandscapeView];
	}
	
	
	if (pdfCount>1) {
		forWordButton.hidden=NO;
	}
	else {
		forWordButton.hidden=YES;
	}
	
	viewControllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < pdfCount; i++) {
        [viewControllers addObject:[NSNull null]];
    }
	
    pdfScrollView.pagingEnabled = YES;
	
	pdfScrollView.contentSize = CGSizeMake(pdfScrollView.frame.size.width * pdfCount, 0);
    pdfScrollView.showsHorizontalScrollIndicator = NO;
    pdfScrollView.showsVerticalScrollIndicator = NO;
    pdfScrollView.scrollsToTop = NO;
    pdfScrollView.delegate = self;
	
	pageLabel.text=[NSString stringWithFormat:@" %d / %d",1,pdfCount];
	
	[self populateImages];
	
	
}



- (void)loadScrollViewWithPage:(int)ipage {
	
    if (ipage < 0) return;
    if (ipage >= pdfCount) return;
	
	CustomScrollView *zoomPdfScrollView = [viewControllers objectAtIndex:ipage];
	//zoomPdfScrollView.delegate = self;
	
	UIImageView *imageView =[[UIImageView alloc]init];
	
    if ((NSNull *)zoomPdfScrollView == [NSNull null]) {
		
		zoomPdfScrollView=[[CustomScrollView alloc] init];
		
		//imageView.frame=CGRectMake(0,0,zoomPdfScrollView.frame.size.width, zoomPdfScrollView.frame.size.height);
       // pdfImageCreater = [[PDFImageCreater alloc] initWithPdfName:pdfPath];	//For creating the images for the particular PDF
		img=[pdfImageCreater initialize:ipage :YES];	//passing to the pdf image creater for corresponding image
        
       // [pdfImageCreater release];
        //pdfImageCreater = nil;
        
		imageView = [[UIImageView alloc] initWithImage:img] ;

		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		imageView.contentMode=UIViewContentModeScaleAspectFit;
		zoomPdfScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		
		imageView.tag=ipage;
		zoomPdfScrollView.tag=ipage;
		
		
		[viewControllers replaceObjectAtIndex:ipage withObject:zoomPdfScrollView];    //adding the scrollview to the 1st position to the viewcontroller array
     [zoomPdfScrollView release];
    }
	
    // add the controller's view to the scroll view
    if (nil == zoomPdfScrollView.superview) {
        CGRect frame = pdfScrollView.frame;
		
		frame.origin.x = frame.size.width * ipage;
        frame.origin.y = 0;
        zoomPdfScrollView.frame = frame;
		
		imageView.frame=CGRectMake(0, 0, zoomPdfScrollView.frame.size.width, zoomPdfScrollView.frame.size.height);
		
		
		[zoomPdfScrollView addSubview:imageView];      //adding the image to the scroll view
		
		
		[imageView release];
        imageView = nil;
        
		zoomPdfScrollView.maximumZoomScale=10.0;
		zoomPdfScrollView.minimumZoomScale=1.0;
		zoomPdfScrollView.bouncesZoom=YES;
		zoomPdfScrollView.delegate=self;
		//zoomPdfScrollView.autoresizesSubviews = YES;
		
		[pdfScrollView addSubview:zoomPdfScrollView];
		//NSLog(@"Initial Page value is: %d", zoomScale);
		//float temp = zoomScale;
		//[zoomPdfScrollView setZoomScale:zoomScale animated:NO];
		
    }
	
	
	else {
		if (ipage==0) {
			
			
			zoomPdfScrollView.contentSize=CGSizeMake(zoomPdfScrollView.frame.size.width, zoomPdfScrollView.frame.size.height);
			
			((UIImageView*)[zoomPdfScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, zoomPdfScrollView.frame.size.width, zoomPdfScrollView.frame.size.height);
			
		}
	}
	

 
	
}


-(void)populateImages{
	
	
	if (page-2>=0) {
		for (int i=page-2; i>0; i--) {
			[[pdfScrollView viewWithTag:i] removeFromSuperview];
			[viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];	
		}
	}
	
	
	if (page+2<=pdfCount) {
		for (int i=page+2; i<pdfCount; i++) {
			[[pdfScrollView viewWithTag:i] removeFromSuperview];
			[viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];	
			
		}
	}
	
   // pageControl.currentPage = page;
	
	if (page==0) {
		[self loadScrollViewWithPage:0];
		[self loadScrollViewWithPage:1];
	}
	else{
		// load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
		[self loadScrollViewWithPage:page - 1];
		[self loadScrollViewWithPage:page];
		[self loadScrollViewWithPage:page + 1];
	}
}

#pragma mark -
#pragma mark ScrllView delegates



-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
	
	return [scrollView.subviews objectAtIndex:0];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	
	viewForEnteringPDFPageNumber.hidden = YES;
	
}

  
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
	@try {
        if (!bButtonClicked) {
            
            CGFloat pageWidth = pdfScrollView.frame.size.width;
            
            if (page >= 0 || page >= (pdfCount-1)) {
                
                page = floor((pdfScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
                
            }
            pageLabel.text=[NSString stringWithFormat:@" %d / %d",page+1,pdfCount];
            
            if (page==pdfCount-1) {
                forWordButton.hidden=YES;
            }
            
            else {
                forWordButton.hidden=NO;
            }
            
            if (page==0) {
                backWordButton.hidden=YES;
            }
            
            else {
                backWordButton.hidden=NO;
            }
            
            
            for (int i=0; i<=page-1; i++) {
                
                CustomScrollView *zoomPdfScrollView = [viewControllers objectAtIndex:i];
                
                if ((NSNull *)zoomPdfScrollView != [NSNull null]) {
                    
                    //[(CustomScrollView *)[pdfScrollView viewWithTag:i] setZoomScale:zoomScale animated:NO];
                    zoomPdfScrollView.contentSize=CGSizeMake(zoomPdfScrollView.frame.size.width, zoomPdfScrollView.frame.size.height);
                    ((UIImageView*)[zoomPdfScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, zoomPdfScrollView.frame.size.width, zoomPdfScrollView.frame.size.height);
                }
            }
            
            for (int i=page+1; i<pdfCount; i++) {
                
                CustomScrollView *zoomPdfScrollView = [viewControllers objectAtIndex:i];
                
                if ((NSNull *)zoomPdfScrollView != [NSNull null]) {
                    
                    //[(CustomScrollView *)[pdfScrollView viewWithTag:i] setZoomScale:zoomScale animated:NO];
                    zoomPdfScrollView.contentSize=CGSizeMake(zoomPdfScrollView.frame.size.width, zoomPdfScrollView.frame.size.height);
                    ((UIImageView*)[zoomPdfScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, zoomPdfScrollView.frame.size.width, zoomPdfScrollView.frame.size.height);
                }
            }
            
            [self populateImages];
            
            bButtonClicked = NO;
        }	

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
	}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	
    @try {
        if (bButtonClicked) {
            
            NSLog(@"Initial Page value is: %d", page);
            
            CGFloat pageWidth = pdfScrollView.frame.size.width;
            
            if (page >= 0 || page >= (pdfCount-1)) {
                
                page = floor((pdfScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
                
            }
            
            pageLabel.text=[NSString stringWithFormat:@"%d / %d",page+1,pdfCount];
            
            if (page==pdfCount-1) {
                
                forWordButton.hidden=YES;
            }
            
            else {
                
                forWordButton.hidden=NO;
            }
            
            if (page==0) {
                
                backWordButton.hidden=YES;
            }
            
            else {
                
                backWordButton.hidden=NO;
            }
            
            for (int i=0; i<=page-1; i++) {
                
                CustomScrollView *obj_CustomScrollView = [viewControllers objectAtIndex:i];
                if ((NSNull *)obj_CustomScrollView != [NSNull null]) {
                    
                    //[(CustomScrollView *)[pdfScrollView viewWithTag:i] setZoomScale:zoomScale animated:NO];
                    obj_CustomScrollView.contentSize=CGSizeMake(obj_CustomScrollView.frame.size.width, obj_CustomScrollView.frame.size.height);
                    ((UIImageView*)[obj_CustomScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, obj_CustomScrollView.frame.size.width, obj_CustomScrollView.frame.size.height);
                }
            }
            
            for (int i=page+1; i<pdfCount; i++) {
                
                CustomScrollView *obj_CustomScrollView = [viewControllers objectAtIndex:i];
                if ((NSNull *)obj_CustomScrollView != [NSNull null]) {
                    
                    //[(CustomScrollView *)[pdfScrollView viewWithTag:i] setZoomScale:zoomScale animated:NO];
                    obj_CustomScrollView.contentSize=CGSizeMake(obj_CustomScrollView.frame.size.width, obj_CustomScrollView.frame.size.height);
                    ((UIImageView*)[obj_CustomScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, obj_CustomScrollView.frame.size.width, obj_CustomScrollView.frame.size.height);
                }
            }
            
            [self populateImages];
            
            bButtonClicked = NO;
        }
        

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
	}



- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	
	
}

//for double click the image it will show in one scroll view and ready 4 the pinching



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if(((UITouch *)[touches anyObject]).tapCount == 1){
		

	}

}

#pragma mark -
#pragma mark UIView Delegates

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	//viewForEnteringPDFPageNumber.hidden = YES;
	
}


 
#pragma mark -
#pragma mark Button Clicked

-(IBAction)showPDFPageEnterScreenButtonClicked:(id)sender {

	//[self.view bringSubviewToFront:viewForEnteringPDFPageNumber];
	//viewForEnteringPDFPageNumber.hidden = NO;
    
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pdfPageSearch];
    //[nav release];
    // nav=nil;
	
    if (self.popoverController == nil) {
        
 	PDFPageSearch *pdfPageSearch=[[PDFPageSearch alloc]initWithNibName:@"PDFPageSearch" bundle:[NSBundle mainBundle]];
        
        pdfPageSearch.pdfViewer = self;
        
        UIPopoverController *popover = 
        [[UIPopoverController alloc] initWithContentViewController:pdfPageSearch]; 
        
        popover.delegate = self;
        
        [pdfPageSearch release];
        
        self.popoverController = popover;
        [popover release];
    }
    
    
    if([[AppTmpData sharedManager]getDeviceOrientation]){
		
		[self.popoverController presentPopoverFromRect:CGRectMake(150, 16, 50, 50) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
	}
	else {
		[self.popoverController presentPopoverFromRect:CGRectMake(150, 16, 50, 50) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
	}
    [self.popoverController  setPopoverContentSize:CGSizeMake(250,300) animated:NO];
    
    NSLog(@"RETAIN COUNT OF PDF VIEWER IS %d", [self retainCount]);
    /* 
	 [self dismissPopoverController];
    
	
	PDFPageSearch *pdfPageSearch=[[PDFPageSearch alloc]initWithNibName:@"PDFPageSearch" bundle:[NSBundle mainBundle]];
    
	pdfPageSearch.pdfViewer = self;
    NSLog(@"PDF SEARCH PAGE RETAIN COUNT ?=: %d",[pdfPageSearch retainCount]);
	
	popOverControllerView=[[UIPopoverController alloc] initWithContentViewController:pdfPageSearch];
   
 
     NSLog(@"PDF SEARCH PAGE RETAIN COUNT ??: %d",[pdfPageSearch retainCount]);
    
	popOverControllerView.delegate=self;

	if([[AppTmpData sharedManager]getDeviceOrientation]){
		
		[popOverControllerView presentPopoverFromRect:CGRectMake(150, 16, 50, 50) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
	}
	else {
		[popOverControllerView presentPopoverFromRect:CGRectMake(150, 16, 50, 50) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
	}
    [popOverControllerView  setPopoverContentSize:CGSizeMake(250,300) animated:NO];
    
    [pdfPageSearch release];
    pdfPageSearch=nil;
*/
	
}


#pragma mark -

-(void)dismissPopoverController{
	
	/*if (popOverControllerView) {
		[popOverControllerView dismissPopoverAnimated:NO];
		popOverControllerView=nil;
	}*/
    
    if (self.popoverController) {
		[self.popoverController dismissPopoverAnimated:NO];
		self.popoverController=nil;
	}
}


//-(IBAction)goCorrectPageButtonClicked:(id)sender {

- (void)goPDFCorrectPage:(NSInteger)GoToPageNumber {
	
	//NSString *temp = enterPageNumberField.text; 
	//int GoToPageNumber = [temp intValue];
	[self dismissPopoverController];
	
	pdfCount = pdfCount;
	if (GoToPageNumber <= pdfCount && GoToPageNumber != 0) {
		
		if (GoToPageNumber == page+2) {
			
			[self forWordButtonClicked:1];
		}
		
		else if (GoToPageNumber == page && page != 0) {
			
			[self backWordButtonClicked:1];
		}
		
		else {
			
			page = GoToPageNumber-2;
			[self forWordButtonClicked:1];

		}

	}
	
	else {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Page Info" 
														message:@"Sorry Given Page is Not Exist"
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}

	
	viewForEnteringPDFPageNumber.hidden = YES;
	
	enterPageNumberField.text           = @""; 
	
	 [enterPageNumberField resignFirstResponder]; 
	
}


-(void)backButtonClicked:(id)sender {
	
    NSLog(@"RETAIN COUNT OF PRODUCT DETAILS==%d",[self retainCount]);
	//[self.view removeFromSuperview];
    
    [self dismissModalViewControllerAnimated:NO];
    NSLog(@"RETAIN COUNT OF PRODUCT DETAILS==%d",[self retainCount]);
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

-(void)forWordButtonClicked:(id)sender {
	
	@try {
        bButtonClicked = YES;
        
        page=page+1;
        if (page==1) {
            backWordButton.hidden=NO;
        }
        
        if (page==pdfCount-1) {
            forWordButton.hidden=YES;
        }
        if ([[AppTmpData sharedManager]getDeviceOrientation]) {
            
            CGPoint cg;
            cg.x=768*page;//694*page;
            cg.y=0;
            [pdfScrollView setContentOffset:cg animated:YES];
        }
        
        else {
            
            CGPoint cg;
            cg.x=1024*page;//931*page;
            cg.y=0;
            [pdfScrollView setContentOffset:cg animated:YES];
        }
        
        NSLog(@"Page Value is %d", page);
        
        pageLabel.text=[NSString stringWithFormat:@" %d / %d",page+1,pdfCount];
        
        //[self populateImages];

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
		
}

-(void)backWordButtonClicked:(id)sender {
	
    @try {
        bButtonClicked = YES;
        
        page=page-1;
        if (page==0) {
            backWordButton.hidden=YES;
        }
        if (page<pdfCount-1) {
            forWordButton.hidden=NO;
        }
        if ([[AppTmpData sharedManager]getDeviceOrientation]) {
            
            CGPoint cg;
            cg.x=768*page;//694*page;
            cg.y=0;
            [pdfScrollView setContentOffset:cg animated:YES];
            
        }
        else {
            
            CGPoint cg;
            cg.x=1024*page;//931*page;
            cg.y=0;
            [pdfScrollView setContentOffset:cg animated:YES];
        }
        
        NSLog(@"Page Value is %d", page);
        
        pageLabel.text=[NSString stringWithFormat:@" %d / %d",page+1,pdfCount];
        
        //[self populateImages];

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
	}


#pragma mark -

#pragma mark Printer Methods
/*
 Method fired when print button is clicked.
 */
- (IBAction)printButtonClicked:(id)sender {
	
		viewForEnteringPDFPageNumber.hidden = YES;
	
	if([[[UIDevice currentDevice] systemVersion] floatValue]>3.2){
		
        /*NSMutableArray *mediaDetails=[[AppTmpData sharedManager] getContentDetailsArr];
		 SelectedContentStore *obj_SelectedContentStore=[mediaDetails objectAtIndex:[[AppTmpData sharedManager]getCurrentSelectedContentId]];	
         */

        
		if(!printHandlerInstance){
			printHandlerInstance = [[PrintHandler alloc] init];
			[printHandlerInstance printPdf:pdfPath sender:sender delegate:self senderView:self.view];
		}
	}
}

/*
 Method fired when print option pop up is dismissed.
 */
- (void)printInteractionControllerWillDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController {
	printHandlerInstance =nil;
}

/*
 Method fired when print job is over.
 */
- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController {
	printHandlerInstance =nil;
}



#pragma mark -
#pragma mark Orientation methods


-(void)OrientationDidChange:(UIDeviceOrientation)orientation{
	
	if ([[AppTmpData sharedManager]getDeviceOrientation]) {
		
		[self adjustPortrate];
	}
	else {
		
		[self adjustLandscape];
		
	}
	
}

- (void)setPortraitView {
	
	pdfScrollView.frame=CGRectMake(0, 0, 768, 1024);
	
}

- (void)setLandscapeView {
	
	pdfScrollView.frame=CGRectMake(0,0,1024,768);
	self.view.frame=CGRectMake(0,0,1024,768);
	
}


-(void)adjustPortrate{
	
	pdfScrollView.frame=CGRectMake(0, 0, 768, 1024);
	pdfScrollView.contentSize = CGSizeMake(pdfScrollView.frame.size.width * pdfCount, 0);
	
	if (page-1>=0) {
		for (int i=page-1; i>0; i--) {
			[[pdfScrollView viewWithTag:i] removeFromSuperview];
			[viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];	
			//NSLog(@"Removed Backward Image View on orientation : %d",i);
		}
	}
	
	
	
	
	if (page+1<=pdfCount) {
		for (int i=page+1; i<pdfCount; i++) {
			[[pdfScrollView viewWithTag:i] removeFromSuperview];
			[viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];	
			//NSLog(@"Removed Forward Image View on orientation: %d",i);
		}
		
		
	}
	
	[self populateImages];
	
	
	CGPoint cg;
	cg.x=768*page;//694*page;
	cg.y=0;
	[pdfScrollView setContentOffset:cg animated:NO];
	
	CustomScrollView *objTmpCustomScrollView=(CustomScrollView *)[pdfScrollView viewWithTag:page];
	CGRect frame = objTmpCustomScrollView.frame;
	
	frame.origin.x = 768*page;//694*page;
	frame.origin.y = 0;		
	
	objTmpCustomScrollView.frame=frame;
	
	//objTmpCustomScrollView.contentSize=CGSizeMake(objTmpCustomScrollView.frame.size.width, objTmpCustomScrollView.frame.size.height);
	((UIImageView*)[objTmpCustomScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, objTmpCustomScrollView.frame.size.width, objTmpCustomScrollView.frame.size.height);
	
	pdfScrollView.frame=CGRectMake(0, 0, 768, 1024);//(0, 0, 694, 964);
	
	CustomScrollView *obj_CustomScrollView = [viewControllers objectAtIndex:page];
	if ([obj_CustomScrollView isKindOfClass:[CustomScrollView class]]) {
		obj_CustomScrollView.contentSize=CGSizeMake(obj_CustomScrollView.frame.size.width, obj_CustomScrollView.frame.size.height);
		
	}
	
	if ((NSNull *)obj_CustomScrollView == [NSNull null]) {
		[self populateImages];
	}
	//m_objTableView.frame=CGRectMake(37, 20, 694, 964);
}


-(void)adjustLandscape {
	
	pdfScrollView.frame=CGRectMake(0,0,1024,768);
	pdfScrollView.contentSize = CGSizeMake(pdfScrollView.frame.size.width * pdfCount, 0);
	
	if (page-1>=0) {
		for (int i=page-1; i>0; i--) {
			[[pdfScrollView viewWithTag:i] removeFromSuperview];
			[viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];	
			//NSLog(@"Removed Backward Image View on orientation : %d",i);
		}
	}
	
	if (page+1<=pdfCount) {
		for (int i=page+1; i<pdfCount; i++) {
			[[pdfScrollView viewWithTag:i] removeFromSuperview];
			[viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];	
			//NSLog(@"Removed Forward Image View on orientation : %d",i);
		}		
	}
	
	[self populateImages];
	
	CGPoint cg;
	cg.x=1024*page;//931*page;
	cg.y=0;
	[pdfScrollView setContentOffset:cg animated:NO];
	
	
	CustomScrollView *objTmpCustomScrollView=(CustomScrollView *)[pdfScrollView viewWithTag:page];
	
	
	
	CGRect frame = objTmpCustomScrollView.frame;
	
	frame.origin.x = 1024*page;
	frame.origin.y = 0;
	objTmpCustomScrollView.frame=frame;
	
	//objTmpCustomScrollView.contentSize=CGSizeMake(objTmpCustomScrollView.frame.size.width, objTmpCustomScrollView.frame.size.height);
	((UIImageView*)[objTmpCustomScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, objTmpCustomScrollView.frame.size.width, objTmpCustomScrollView.frame.size.height);
	pdfScrollView.frame=CGRectMake(0,0,1024,768);//(0, 0, 931, 715);
	
	
	CustomScrollView *obj_CustomScrollView = [viewControllers objectAtIndex:page];
	if ([obj_CustomScrollView isKindOfClass:[CustomScrollView class]]) {
		obj_CustomScrollView.contentSize=CGSizeMake(obj_CustomScrollView.frame.size.width, obj_CustomScrollView.frame.size.height);
		
	}
	
	if ((NSNull *)obj_CustomScrollView == [NSNull null]) {
		
		
		[self populateImages];
	}
	
	//m_objTableView.frame=CGRectMake(45, 20, 931, 715);
	
}

#pragma mark -
#pragma mark -
-(void)singleTap{
	
	viewForEnteringPDFPageNumber.hidden = YES;
	
}

#pragma mark -

- (void)didReceiveMemoryWarning {
	
}


- (void)viewDidUnload {
	
    [super viewDidUnload];
}


- (void)dealloc {
    
	//[popoverController release];
    
   // [pdfScrollView release];
  //  pdfScrollView = nil;
    
 
    
   // [viewControllers release];
   // viewControllers = nil;

    [super dealloc];
}


@end







