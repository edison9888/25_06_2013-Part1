    //
//  ImageViewer.m
//  Torq361
//
// Created by Nithin George on 20/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageViewer.h"
#import "AppTmpData.h"
#import "UserCredentials.h"
#import "ContentDetails.h"

@implementation ImageViewer

@synthesize imageArray, imageCount, imageScrollView, offset, zoomScale;

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
	
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(OrientationDidChange:)
												 name:UIDeviceOrientationDidChangeNotification
											   object:nil];
	pageControl.hidden = YES;
	
	page = offset;
	//contentScrollView.contentOffset = CGPointMake((340*arrayIndex), 0);
	[self initializeView];
	
    [super viewDidLoad];
}


#pragma mark -
#pragma mark For image on scrollview


-(void)initializeView {
	
	forWordButton.hidden=YES;
	backWordButton.hidden=YES;
	
	imageScrollView=[[CustomScrollView alloc]init];
	[self.view addSubview:imageScrollView];
	[self.view bringSubviewToFront:backButton];
	[self.view bringSubviewToFront:forWordButton];
	[self.view bringSubviewToFront:backWordButton];
	[self.view bringSubviewToFront:pagelabel];
	[self.view bringSubviewToFront:zoomThumbImage];
	zoomThumbImage.hidden = YES;
	
	if([[AppTmpData sharedManager]getDeviceOrientation]){

		[self setPortraitView];
	}
	else {

		[self setLandscapeView];
	}
	
	
/*	if (imageCount>1) {
		forWordButton.hidden=NO;
	}
	else {
		forWordButton.hidden=YES;
	}
*/	
	
	if (offset+1 == imageCount) {
		forWordButton.hidden=YES;
	}
	else {
		forWordButton.hidden=NO;
	}
	
	if (offset+1 == 1) {
		backWordButton.hidden=YES;
	}
	else {
		backWordButton.hidden=NO;
	}
	
	
	viewControllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < imageCount; i++) {
        [viewControllers addObject:[NSNull null]];
    }
	
    imageScrollView.pagingEnabled = YES;
	
	imageScrollView.contentSize = CGSizeMake(imageScrollView.frame.size.width * imageCount, 0);
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.scrollsToTop = NO;
    imageScrollView.delegate = self;

	imageScrollView.contentOffset = CGPointMake((imageScrollView.frame.size.width * offset), 0);
	pagelabel.text=[NSString stringWithFormat:@" %d / %d",offset+1,imageCount];
	
	[self populateImages];
	

}


- (void)loadScrollViewWithPage:(int)ipage {
	
    if (ipage < 0) return;
    if (ipage >= imageCount) return;
	
	zoomImageScrollView = [viewControllers objectAtIndex:ipage];
	
	UIImageView *imageView =[[UIImageView alloc]init];
	
    if ((NSNull *)zoomImageScrollView == [NSNull null]) {
		
		zoomImageScrollView=[[UIScrollView alloc] init];
		zoomImageScrollView.maximumZoomScale=10.0;
		zoomImageScrollView.minimumZoomScale=1.0;
		zoomImageScrollView.bouncesZoom=YES;
		zoomImageScrollView.delegate=self;

		//For finding the correct image path for the selected image's content image path
		/*NSArray *objExtension = [[imageArray objectAtIndex:ipage] componentsSeparatedByString:@"/"];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentPath = [paths objectAtIndex:0];	
		NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
		NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductContent/Portrait/image",@"CompanyId",companyid]];		
		NSString *strDownloadDestiantionPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
		
        */
        ContentDetails * content=( ContentDetails * )[imageArray objectAtIndex: ipage];
        
        NSArray *objExtension = [content.Path componentsSeparatedByString:@"/"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [paths objectAtIndex:0];	
        NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
        NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductContent/Portrait/%@",@"CompanyId",companyid,content.Type]];		
        NSString *strDownloadDestiantionPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];

        
        
        
		UIImage *image = [[UIImage alloc]initWithContentsOfFile:strDownloadDestiantionPath];
		
		
		//imageView.frame=CGRectMake(0, 0, zoomImageScrollView.frame.size.width, zoomImageScrollView.frame.size.height);
		
		[imageView setImage:image];
		[image release];
	
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		imageView.contentMode=UIViewContentModeScaleAspectFit;
		zoomImageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
		imageView.tag=ipage;
		zoomImageScrollView.tag=ipage;

		[viewControllers replaceObjectAtIndex:ipage withObject:zoomImageScrollView];    //adding the scrollview to the 1st position to the viewcontroller array
        [zoomImageScrollView release];
    }
	
	
    // add the controller's view to the scroll view
    if (nil == zoomImageScrollView.superview) {
        CGRect frame = imageScrollView.frame;
		
		frame.origin.x = frame.size.width * ipage;
        frame.origin.y = 0;
        zoomImageScrollView.frame = frame;
		
		imageView.frame=CGRectMake(0, 0, zoomImageScrollView.frame.size.width, zoomImageScrollView.frame.size.height);

		
		[zoomImageScrollView addSubview:imageView];      //adding the image to the scroll view
		
		
		[imageView release];
		

		
		//zoomImageScrollView.autoresizesSubviews = YES;
		
		[imageScrollView addSubview:zoomImageScrollView];
		//NSLog(@"Initial Page value is: %d", zoomScale);
		//float temp = zoomScale;
		//[zoomImageScrollView setMinimumZoomScale:1.0];	
		
    }
	
	
	else {
		/*if (ipage==0) {
			
			
			zoomImageScrollView.contentSize=CGSizeMake(zoomImageScrollView.frame.size.width, zoomImageScrollView.frame.size.height);
			
			((UIImageView*)[zoomImageScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, zoomImageScrollView.frame.size.width, zoomImageScrollView.frame.size.height);
			
		}*/
	}
	
	
	
}


-(void)populateImages{
	
	
	if (page-2>=0) {
		for (int i=page-2; i>0; i--) {
			[[imageScrollView viewWithTag:i] removeFromSuperview];
			[viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];	
		}
	}
	
	
	if (page+2<=imageCount) {
		for (int i=page+2; i<imageCount; i++) {
			[[imageScrollView viewWithTag:i] removeFromSuperview];
			[viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];	
	
		}
	}
	
    pageControl.currentPage = page;

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



-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	
/*	zoomThumbImage.hidden = NO;
	UIImageView *temp = (UIImageView *) [scrollView.subviews objectAtIndex:0];
	[zoomThumbImage setImage:temp.image]; 
	zoomImageThumbFrame= [[ZoomImageThumbFrame alloc]initWithNibName:@"ZoomImageThumbFrame" bundle:nil];
	zoomImageThumbFrame.view.frame= CGRectMake(20, 20, 76, 56);
	//zoomImageThumbFrame.view.borderColor = [UIColor redColor].CGColor;
	zoomImageThumbFrame.view.layer.borderWidth = 3.0f;
	[zoomThumbImage addSubview:zoomImageThumbFrame.view];
	[zoomImageThumbFrame release];
	zoomImageThumbFrame = nil;
*/	

	//((UIImageView*)[scrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, 768, 1024);
	/*CGPoint point;
	point.x=84;
	point.y=108;
	
	[scrollView setContentOffset:point];
	[scrollView setBackgroundColor:[UIColor redColor]];
	
	if (page==0) {
		scrollView.maximumZoomScale=10.0;
		scrollView.minimumZoomScale=1.0;
		scrollView.bouncesZoom=YES;
		zoomImageScrollView.contentSize=CGSizeMake(zoomImageScrollView.frame.size.width, zoomImageScrollView.frame.size.height);
		((UIImageView*)[zoomImageScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, 768, 1024);

	}*/
	
	return [scrollView.subviews objectAtIndex:0];

	
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    @try {
        if (!bButtonClicked) {
            
            zoomThumbImage.hidden = YES;
            
            CGFloat pageWidth = imageScrollView.frame.size.width;
            
            if (page >= 0 || page >= (imageCount-1)) {
                
                page = floor((imageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
                
            }
            pagelabel.text=[NSString stringWithFormat:@" %d / %d",page+1,imageCount];
            
            if (page==imageCount-1) {
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
                
                CustomScrollView *zoomImageScrollView = [viewControllers objectAtIndex:i];
                
                if ((NSNull *)zoomImageScrollView != [NSNull null]) {
                    
                    //[(CustomScrollView *)[imageScrollView viewWithTag:i] setZoomScale:zoomScale animated:NO];
                    zoomImageScrollView.contentSize=CGSizeMake(zoomImageScrollView.frame.size.width, zoomImageScrollView.frame.size.height);
                    ((UIImageView*)[zoomImageScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, zoomImageScrollView.frame.size.width, zoomImageScrollView.frame.size.height);
                }
            }
            
            for (int i=page+1; i<imageCount; i++) {
                
                CustomScrollView *zoomImageScrollView = [viewControllers objectAtIndex:i];
                
                if ((NSNull *)zoomImageScrollView != [NSNull null]) {
                    
                    //[(CustomScrollView *)[imageScrollView viewWithTag:i] setZoomScale:zoomScale animated:NO];
                    zoomImageScrollView.contentSize=CGSizeMake(zoomImageScrollView.frame.size.width, zoomImageScrollView.frame.size.height);
                    ((UIImageView*)[zoomImageScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, zoomImageScrollView.frame.size.width, zoomImageScrollView.frame.size.height);
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
            
            CGFloat pageWidth = imageScrollView.frame.size.width;
            
            if (page >= 0 || page >= (imageCount-1)) {
                
                page = floor((imageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
                
            }
            
            pagelabel.text=[NSString stringWithFormat:@"%d / %d",page+1,imageCount];
            
            if (page==imageCount-1) {
                
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
                    
                    //[(CustomScrollView *)[imageScrollView viewWithTag:i] setZoomScale:zoomScale animated:NO];
                    obj_CustomScrollView.contentSize=CGSizeMake(obj_CustomScrollView.frame.size.width, obj_CustomScrollView.frame.size.height);
                    ((UIImageView*)[obj_CustomScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, obj_CustomScrollView.frame.size.width, obj_CustomScrollView.frame.size.height);
                }
            }
            
            for (int i=page+1; i<imageCount; i++) {
                
                CustomScrollView *obj_CustomScrollView = [viewControllers objectAtIndex:i];
                if ((NSNull *)obj_CustomScrollView != [NSNull null]) {
                    
                    //[(CustomScrollView *)[imageScrollView viewWithTag:i] setZoomScale:zoomScale animated:NO];
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
	
/*	zoomScale = scrollView.zoomScale;
	
	[scrollView setBackgroundColor:[UIColor redColor]];
	
	NSLog(@"Zooommmm Scale:::::%f",zoomScale);
	
	if (bButtonClicked) {//if (zoomScale == 1) {
	
		((UIImageView*)[scrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, 768, 1024);
			
	}
	
	for(int k=0; k<[viewControllers count]; k++) {
	
		CustomScrollView *temp = [viewControllers objectAtIndex:k];
		
		if (((NSNull *)temp != [NSNull null])) {
			
			//[temp setZoomScale:zoomScale animated:NO];
			//[viewControllers replaceObjectAtIndex:k withObject:temp];
		}
			
	}
*/	
}

//for double click the image it will show in one scroll view and ready 4 the pinching

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {		
	
	
}

#pragma mark -
#pragma mark Button Clicked

-(void)backButtonClicked:(id)sender {
	
    [self dismissModalViewControllerAnimated:YES];
    return;
	if (imageScrollView) {
		
		NSArray *contentViews=[imageScrollView subviews];
		
		for(id subview in contentViews){
			
			[subview removeFromSuperview];
		}
		
		[imageScrollView release];
		imageScrollView = nil;
	}
	
	[self.view removeFromSuperview];	
}

-(void)forWordButtonClicked:(id)sender {
	@try {
        
        zoomThumbImage.hidden = YES;
        
        
        bButtonClicked = YES;
        
        page=page+1;
        if (page==1) {
            backWordButton.hidden=NO;
        }
        
        if (page==imageCount-1) {
            forWordButton.hidden=YES;
        }
        if ([[AppTmpData sharedManager]getDeviceOrientation]) {
            
            CGPoint cg;
            cg.x=768*page;//694*page;
            cg.y=0;
            [imageScrollView setContentOffset:cg animated:YES];
        }
        
        else {
            
            CGPoint cg;
            cg.x=1024*page;//931*page;
            cg.y=0;
            [imageScrollView setContentOffset:cg animated:YES];
        }
        
        NSLog(@"Page Value is %d", page);
        
        pagelabel.text=[NSString stringWithFormat:@" %d / %d",page+1,imageCount];
        
        //[self populateImages];
        

        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
   }

-(void)backWordButtonClicked:(id)sender {
	
    @try {
        zoomThumbImage.hidden = YES;
        
        bButtonClicked = YES;
        
        page=page-1;
        if (page==0) {
            backWordButton.hidden=YES;
        }
        if (page<imageCount-1) {
            forWordButton.hidden=NO;
        }
        if ([[AppTmpData sharedManager]getDeviceOrientation]) {
            
            CGPoint cg;
            cg.x=768*page;//694*page;
            cg.y=0;
            [imageScrollView setContentOffset:cg animated:YES];
            
        }
        else {
            
            CGPoint cg;
            cg.x=1024*page;//931*page;
            cg.y=0;
            [imageScrollView setContentOffset:cg animated:YES];
        }
        
        NSLog(@"Page Value is %d", page);
        
        pagelabel.text=[NSString stringWithFormat:@" %d / %d",page+1,imageCount];
        
        //[self populateImages];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
	
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
	
	imageScrollView.frame=CGRectMake(0, 0, 768, 1024);

}

- (void)setLandscapeView {
	
	imageScrollView.frame=CGRectMake(0,0,1024,768);
	self.view.frame=CGRectMake(0,0,1024,768);

}


-(void)adjustPortrate{
	
	imageScrollView.frame=CGRectMake(0, 0, 768, 1024);
	imageScrollView.contentSize = CGSizeMake(imageScrollView.frame.size.width * imageCount, 0);
	
	if (page-1>=0) {
		for (int i=page-1; i>0; i--) {
			[[imageScrollView viewWithTag:i] removeFromSuperview];
			[viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];	
			//NSLog(@"Removed Backward Image View on orientation : %d",i);
		}
	}
	
	
	
	
	if (page+1<=imageCount) {
		for (int i=page+1; i<imageCount; i++) {
			[[imageScrollView viewWithTag:i] removeFromSuperview];
			[viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];	
			//NSLog(@"Removed Forward Image View on orientation: %d",i);
		}
		
		
	}

	[self populateImages];
	
	
	CGPoint cg;
	cg.x=768*page;//694*page;
	cg.y=0;
	[imageScrollView setContentOffset:cg animated:NO];
	
	CustomScrollView *objTmpCustomScrollView=(CustomScrollView *)[imageScrollView viewWithTag:page];
	CGRect frame = objTmpCustomScrollView.frame;
	
	frame.origin.x = 768*page;//694*page;
	frame.origin.y = 0;		
	
	objTmpCustomScrollView.frame=frame;
	
	//objTmpCustomScrollView.contentSize=CGSizeMake(objTmpCustomScrollView.frame.size.width, objTmpCustomScrollView.frame.size.height);
	((UIImageView*)[objTmpCustomScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, objTmpCustomScrollView.frame.size.width, objTmpCustomScrollView.frame.size.height);
	
	imageScrollView.frame=CGRectMake(0, 0, 768, 1024);//(0, 0, 694, 964);
	
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
	
	imageScrollView.frame=CGRectMake(0,0,1024,768);
	imageScrollView.contentSize = CGSizeMake(imageScrollView.frame.size.width * imageCount, 0);
	
	if (page-1>=0) {
		for (int i=page-1; i>0; i--) {
			[[imageScrollView viewWithTag:i] removeFromSuperview];
			[viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];	
			//NSLog(@"Removed Backward Image View on orientation : %d",i);
		}
	}
	
	if (page+1<=imageCount) {
		for (int i=page+1; i<imageCount; i++) {
			[[imageScrollView viewWithTag:i] removeFromSuperview];
			[viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];	
			//NSLog(@"Removed Forward Image View on orientation : %d",i);
		}		
	}
	
	[self populateImages];
	
	CGPoint cg;
	cg.x=1024*page;//931*page;
	cg.y=0;
	[imageScrollView setContentOffset:cg animated:NO];
	
	
	CustomScrollView *objTmpCustomScrollView=(CustomScrollView *)[imageScrollView viewWithTag:page];
	
	
	
	CGRect frame = objTmpCustomScrollView.frame;
	
	frame.origin.x = 1024*page;
	frame.origin.y = 0;
	objTmpCustomScrollView.frame=frame;
	
	//objTmpCustomScrollView.contentSize=CGSizeMake(objTmpCustomScrollView.frame.size.width, objTmpCustomScrollView.frame.size.height);
	((UIImageView*)[objTmpCustomScrollView.subviews objectAtIndex:0]).frame=CGRectMake(0, 0, objTmpCustomScrollView.frame.size.width, objTmpCustomScrollView.frame.size.height);
	imageScrollView.frame=CGRectMake(0,0,1024,768);//(0, 0, 931, 715);
	
	
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

- (void)didReceiveMemoryWarning {

}


- (void)viewDidUnload {
	
    [super viewDidUnload];
}


- (void)dealloc {
	
    [super dealloc];
}


@end







