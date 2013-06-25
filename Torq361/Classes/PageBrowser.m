//
//  PageBrowser.m
//  Ahlan
//
//  Created by NaveenShan on 23/02/2011.
//  Copyright 2011 RapidValue IT Services Pvt. Ltd. All rights reserved.
//

#import "PageBrowser.h"
#import "UserCredentials.h"
//#import "PDFImageCreater.h"
#import <MediaPlayer/MediaPlayer.h>


@implementation PageBrowser


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self initializeView];
    }
    return self;
}

-(id)initWithImages:(NSMutableArray *)arrImages SuperViewFrame:(CGRect)frame DelegateObject:(id)objdelegete	{
	if ((self = [super init])) {
		
		self.autoresizesSubviews = YES;
		self.backgroundColor=[UIColor clearColor];
		//self.frame=CGRectMake(0,frame.size.height-(thumpHeight+550),frame.size.width,(thumpHeight+10));
        self.frame=CGRectMake(0,0,frame.size.width,frame.size.height);
		
		m_iTotalpages = 0;
		m_iCurrentPageIndex = 0;
		
		m_arrPages = arrImages;
		[m_arrPages retain];
		
		m_iTotalpages = [m_arrPages count];
		
		delegeteObject = objdelegete;
		[delegeteObject retain];
		
		[self initializeView];
	}

	return self;
}

#pragma mark -

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

//to initialize the page browser view
-(void)initializeView	{
	
	if (m_scrollView) {
		[m_scrollView release];
		m_scrollView = nil;
	}
	
	m_scrollView = [[UIScrollView alloc] init];
	m_scrollView.delegate=self;
	m_scrollView.pagingEnabled=YES;
	m_scrollView.showsVerticalScrollIndicator=NO;
	m_scrollView.showsHorizontalScrollIndicator=NO;
	//m_scrollView.frame=CGRectMake(16,5,self.frame.size.width,(self.frame.size.height-5));
    m_scrollView.frame=CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
	m_scrollView.contentSize=CGSizeMake((m_iTotalpages*(thumpWidth + thumpSpacing)),m_scrollView.frame.size.height);
	m_scrollView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth);
	m_scrollView.backgroundColor=[UIColor clearColor];
	
	[self addSubview:m_scrollView];
    	
    if (m_arrPageViews) {
        [m_arrPageViews removeAllObjects];
        [m_arrPageViews release];
        m_arrPageViews = nil;
    }
    m_arrPageViews=[[NSMutableArray alloc] init];
	
	// to save time and memory, we won't load the page views immediately
	for (int i = 0; i < m_iTotalpages; ++i)
		[m_arrPageViews addObject:[NSNull null]];
	
	[self currentPageIndexDidChange];
}

- (UIButton *)loadViewForPage:(int)pageIndex	{
	
	UIButton *controller = nil;
	@try {	
		
		if(m_arrPages && [m_arrPages count] > pageIndex)	{	
			
			//NSString *pagePath=[m_arrPages objectAtIndex:(pageIndex)];
			//if(pagePath) { 
				
				UIButton *objButton=[[UIButton alloc] init];
				[objButton setFrame:CGRectMake(((pageIndex*thumpWidth)+thumpSpacing),0,thumpWidth,thumpHeight)];
				objButton.layer.borderWidth=thumpBorder;
				objButton.layer.borderColor=[thumpBorderColor CGColor]; 
				[objButton setTag:pageIndex];
				objButton.contentMode = UIViewContentModeScaleAspectFit;
            
                ContentDetails *content=( ContentDetails* )[m_arrPages objectAtIndex:pageIndex];
                UIImage *img=[self getimage:content];
                if(img==nil){
                    //objButton.layer.borderColor=[thumpBorderColorForDownload CGColor]; 
                    [objButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [objButton setTitle:@"Downloading" forState:UIControlStateNormal];
                }else{
                    [objButton setTitle:@"" forState:UIControlStateNormal];
                    //[objButton setBackgroundImage:img
                                         //forState:UIControlStateNormal];
                    [objButton setImage:img forState:UIControlStateNormal];
                    objButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
                    
                    [img release];
                    img=nil;
                }
                
            
            
				[objButton addTarget:self			
							  action:@selector(scrollThumbClicked:)
					forControlEvents:UIControlEventTouchUpInside];
				
				controller =objButton;
            
				/*[m_scrollView addSubview:objButton];
				[objButton release];
				objButton = nil;*/
			//}
		}
	}
	@catch (NSException * e) {
		NSLog(@"Exception loadViewForPage");
	}
	@finally {
		
	}	
	return controller;
}

- (void)viewForPage:(int)pageIndex {
	
	if(pageIndex < 0){
		
		return ;
	}
	else if(pageIndex >= m_iTotalpages){
		
		return ;
	}
	
	UIButton *pageView;
	@try{
		
		if ([m_arrPageViews objectAtIndex:pageIndex] == [NSNull null]) {
			
			pageView = [self loadViewForPage:pageIndex];
            [m_arrPageViews replaceObjectAtIndex:pageIndex withObject:pageView];
            [m_scrollView addSubview:pageView];
            [pageView release];
			
		} else {
			
			pageView = [m_arrPageViews objectAtIndex:pageIndex];
		}
		
		pageView.frame = CGRectMake((pageIndex * (thumpWidth+thumpSpacing)),0,thumpWidth,thumpHeight);
	}
	@catch (NSException *e) {
		NSLog(@"Exception viewForPage");

	}

}

-(void)unloadPages	{
	
	@try {
		
		if (m_arrPageViews) {
			int minVal=(m_iCurrentPageIndex-5);
			int maxVal=(m_iCurrentPageIndex+5);
			// unload non-visible pages in case the memory is scarse
			for (int pageIndex = 0; pageIndex < m_iTotalpages; ++pageIndex)	{
				
				if ((pageIndex < minVal)  || (pageIndex > maxVal) )	{
						
					UIButton *pageView = [m_arrPageViews objectAtIndex:pageIndex];
					if((NSNull *)pageView != [NSNull null]) {
						
						[[pageView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
						[[pageView subviews] makeObjectsPerformSelector:@selector(release)];
						[pageView removeFromSuperview];
						if(pageView)
							pageView=nil;
						[m_arrPageViews replaceObjectAtIndex:pageIndex withObject:[NSNull null]];
					}
				}	
			}
		}
		
	}
	@catch (NSException * e) {
		NSLog(@"Exception Unload");
	}
	@finally {
		
	}
}

-(void)scrollThumbClicked:(id)sender{
    UIButton *btn=(UIButton*)sender;
    for (int pageIndex = 0; pageIndex < m_iTotalpages; ++pageIndex)	{
        
        UIButton *pageView = [m_arrPageViews objectAtIndex:pageIndex];
        if((NSNull *)pageView != [NSNull null]) {
            pageView.layer.borderColor=[thumpBorderColor CGColor]; 
        }
    }
	btn.layer.borderColor=[thumpBorderSelColor CGColor]; 
    
    if([delegeteObject respondsToSelector:@selector(scrollThumbClicked:)]) {
        [delegeteObject scrollThumbClicked:sender];
    }

}
-(UIImage*)getimage:(ContentDetails *) content{
    
    
    UIImage * imageselected=nil;
    
    NSArray *objExtension = [content.Path componentsSeparatedByString:@"/"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];	
    NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
    NSString *strThumbImagess=[documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@/ProductContent/Portrait/%@",@"CompanyId",companyid,content.Type]];		
    NSString *strDownloadDestiantionPath = [NSString stringWithFormat:@"%@/%@",strThumbImagess,[objExtension lastObject]];
    /*if ([content.Type isEqualToString: @"video"]) {
        
        // return nil;
        if ([[NSFileManager defaultManager]fileExistsAtPath:strDownloadDestiantionPath]) {
            NSURL* videoURL = [NSURL fileURLWithPath:strDownloadDestiantionPath];
            MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
            NSTimeInterval time       = 0.00;
            imageselected = [moviePlayer thumbnailImageAtTime:time timeOption:MPMovieTimeOptionNearestKeyFrame];
            [moviePlayer play];
            if(moviePlayer){
                
                [moviePlayer stop];
                
                [moviePlayer release];
                
                // moviePlayer = nil;
            }
            
        }
        
        else {
            
            imageselected  = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"noVideoImage" ofType:@"png"]];
            [imageselected autorelease];
            
        }
        
    }
    
    
    if ([content.Type isEqualToString: @"pdf"]) {
        
        
        PDFImageCreater*  pdfImageCreater = [[PDFImageCreater alloc] initWithPdfName:strDownloadDestiantionPath];       
        imageselected = [pdfImageCreater initialize:1 :YES];
        [pdfImageCreater release];
        
    }*/
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:strDownloadDestiantionPath]){
        imageselected=nil;
    }else if ([content.Type isEqualToString: @"video"]) {
        
        imageselected  = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"icon_video" ofType:@"png"]];
    }
    else if([content.Type isEqualToString: @"pdf"]){
        imageselected  = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"pdfImage" ofType:@"png"]];
        
    }else if ([content.Type isEqualToString: @"image"]) {
        
        imageselected = [[UIImage alloc]initWithContentsOfFile:strDownloadDestiantionPath];
    }
    
    return imageselected;
    
}


-(void)currentPageIndexDidChange	{
	
	@try {
		
		if (m_iCurrentPageIndex+5 < m_iTotalpages)
			[self viewForPage:m_iCurrentPageIndex+5];
		if (m_iCurrentPageIndex+4 < m_iTotalpages)
			[self viewForPage:m_iCurrentPageIndex+4];
		if (m_iCurrentPageIndex+3 < m_iTotalpages)
			[self viewForPage:m_iCurrentPageIndex+3];
		if (m_iCurrentPageIndex+2 < m_iTotalpages)
			[self viewForPage:m_iCurrentPageIndex+2];
		if (m_iCurrentPageIndex+1 < m_iTotalpages)
			[self viewForPage:m_iCurrentPageIndex+1];
		
		if (m_iCurrentPageIndex >= 0 && m_iCurrentPageIndex < m_iTotalpages)
			[self viewForPage:m_iCurrentPageIndex];
		
		if (m_iCurrentPageIndex > 0)
			[self viewForPage:m_iCurrentPageIndex-1];
		if (m_iCurrentPageIndex-1 > 0)
			[self viewForPage:m_iCurrentPageIndex-2];
		if (m_iCurrentPageIndex-2 > 0)
			[self viewForPage:m_iCurrentPageIndex-3];
		if (m_iCurrentPageIndex-3 > 0)
			[self viewForPage:m_iCurrentPageIndex-4];
		if (m_iCurrentPageIndex-4 > 0)
			[self viewForPage:m_iCurrentPageIndex-5];
        
        if([delegeteObject respondsToSelector:@selector(pageBrowserCurrentPageIndexDidChange:)]) {
            [delegeteObject pageBrowserCurrentPageIndexDidChange:m_iCurrentPageIndex];
        }
		//to unload currently non viewing pages
		[self unloadPages];
		
	}
	@catch (NSException * e) {
		
	}
	@finally {
		
	}
}

#pragma mark -
#pragma mark Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	@try {

		int newPageIndex = (m_scrollView.contentOffset.x + self.frame.size.width / 2) / thumpWidth;
		if (newPageIndex == m_iCurrentPageIndex) 
			return;
		
		// could happen when scrolling fast
		if (newPageIndex < 0)
			newPageIndex = 0;
		else if (newPageIndex >= m_iTotalpages)
			newPageIndex = m_iTotalpages - 1;
		
		m_iCurrentPageIndex = newPageIndex;
		[self currentPageIndexDidChange];
	}
	@catch (NSException * e) {
		//NSLog(@"DIDSCROLL");
	}
}


#pragma mark -

- (void)dealloc {
	
	if (m_arrPages) {
		[m_arrPages removeAllObjects];
		[m_arrPages release];
		m_arrPages = nil;
	}
	
	if (delegeteObject) {
		[delegeteObject release];
		delegeteObject = nil;
	}
	
	if (m_scrollView) {
		[[m_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[m_scrollView removeFromSuperview];
		[m_scrollView release];
		m_scrollView = nil;
	}
    
    if (m_arrPageViews) {
        [m_arrPageViews removeAllObjects];
        [m_arrPageViews release];
        m_arrPageViews = nil;
    }
	
    [super dealloc];
}


@end
