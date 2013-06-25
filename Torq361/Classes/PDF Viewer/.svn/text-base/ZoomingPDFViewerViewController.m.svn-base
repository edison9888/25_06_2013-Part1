
#import "ZoomingPDFViewerViewController.h"
#import "PDFScrollView.h"
#import "AppTmpData.h"
 
#import "DatabaseManager.h"
 
#pragma mark -

@interface ZoomingPDFViewerViewController () <UIScrollViewDelegate>
@property (nonatomic, retain) NSMutableArray *pageViews;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, readonly) NSUInteger currentPageIndex;
@end

#pragma mark -

@implementation ZoomingPDFViewerViewController

#pragma mark -

@synthesize pageViews=_pageViews, scrollView=_scrollView, currentPageIndex=_currentPageIndex;
@synthesize str_ContentPath;
//load View for page
- (UIScrollView *)loadViewForPage:(NSUInteger)pageIndex {
	pageIndex=	pageIndex+1;
	// Create our PDFScrollView and add it to the view controller.
	PDFScrollView *pageView = [[PDFScrollView alloc] initWithFrame:[[self scrollView] bounds] PageNo:pageIndex PDF:pdfDoc];
	return pageView;
}

- (CGRect)alignView:(UIView *)view forPage:(NSUInteger)pageIndex inRect:(CGRect)rect {
	UIScrollView *imageView = (UIScrollView *)view;
	CGSize imageSize = imageView.frame.size;
	CGFloat ratioX = rect.size.width / imageSize.width, ratioY = rect.size.height / imageSize.height;
	CGSize size = (ratioX < ratioY ?
				   CGSizeMake(rect.size.width, ratioX * imageSize.height) :
				   CGSizeMake(ratioY * imageSize.width, rect.size.height));
	return CGRectMake(rect.origin.x + (rect.size.width - size.width) / 2,
					  rect.origin.y + (rect.size.height - size.height) / 2,
					  size.width, size.height);
	return CGRectMake(0, 0, 768, 1024);
}

//Get number of Scroll View Pages
- (NSUInteger)numberOfPages {
	return pdfPages;
}

//add physiv
- (UIScrollView *)viewForPhysicalPage:(NSUInteger)pageIndex {
	NSParameterAssert(pageIndex >= 0);
	NSParameterAssert(pageIndex < [self.pageViews count]);
	
	UIScrollView *pageView;
	if ([self.pageViews objectAtIndex:pageIndex] == [NSNull null]) {
		pageView = [self loadViewForPage:pageIndex];
		[self.pageViews replaceObjectAtIndex:pageIndex withObject:pageView];
		[self.scrollView addSubview:pageView];
 
		[self.view bringSubviewToFront:lblPageNo];
			NSLog(@"View loaded for page %d", pageIndex);
	} else {
		pageView = [self.pageViews objectAtIndex:pageIndex];
	}
	return pageView;
}

- (CGSize)pageSize {
	return self.scrollView.frame.size;
}

- (BOOL)isPhysicalPageLoaded:(NSUInteger)pageIndex {
	return [self.pageViews objectAtIndex:pageIndex] != [NSNull null];
}

- (void)layoutPhysicalPage:(NSUInteger)pageIndex {
	UIView *pageView = [self viewForPhysicalPage:pageIndex];
	CGSize pageSize = [self pageSize];
	pageView.frame = [self alignView:pageView forPage:[self pageForPhysicalPage:pageIndex] inRect:CGRectMake(pageIndex * pageSize.width, 0, pageSize.width, pageSize.height)];
}
//Load ScrollView Pages
- (void)loadScrollView {
	_pageLoopEnabled = NO;
	[indicator startAnimating];
	_rotationInProgress=YES;
	self.scrollView = [[[UIScrollView alloc] init] autorelease];
	self.scrollView.frame=CGRectMake(0, 0, 768, 1024);
	self.scrollView.delegate = self;
	self.scrollView.pagingEnabled = YES;
	self.scrollView.bounces=NO;
	//Get PDF Doc
	pdfDoc=[self pdfDocument];
	CGPDFDocumentRetain(pdfDoc);
	pdfPages=CGPDFDocumentGetNumberOfPages(pdfDoc);
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
    
	//lblPageNo=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-120, self.view.frame.size.height-30, 200, 30)];
	
    lblPageNo.backgroundColor=[UIColor clearColor];
	lblPageNo.textColor=[UIColor grayColor];
	[self.view addSubview:lblPageNo];
	lblPageNo.text= [NSString stringWithFormat:@"Page %d of %d", self.currentPageIndex+1, pdfPages];
	 
	[self.view addSubview:self.scrollView];
 
}

-(void)close:(id)sender{

	 
	[self unloadViews];
	[[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	self.pageViews = nil;
	 self.scrollView = nil;
	[self. view removeFromSuperview];
	 CGPDFDocumentRelease(pdfDoc);
}

- (void)viewDidLoad {
	[self loadScrollView];
	 
	self.pageViews = [NSMutableArray array];
	// to save time and memory, we won't load the page views immediately
	NSUInteger numberOfPhysicalPages = (_pageLoopEnabled ? 2 * pdfPages : pdfPages);
	for (NSUInteger i = 0; i < numberOfPhysicalPages; ++i)
		[self.pageViews addObject:[NSNull null]];
	[self layoutPages];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(currentPageIndexDidChange) userInfo:nil repeats:NO];
	[self setPhysicalPageIndex:[self physicalPageForPage:_currentPageIndex]];
}

- (void)currentPageIndexDidChange {

		[self unloadViews];
	if ([self.pageViews count]>0) {
	  [self layoutPhysicalPage:_currentPhysicalPageIndex];
	if (_currentPhysicalPageIndex+1 < [self.pageViews count])
		[self layoutPhysicalPage:_currentPhysicalPageIndex+1];
	if (_currentPhysicalPageIndex > 0)
		[self layoutPhysicalPage:_currentPhysicalPageIndex-1];
	}
		
}

- (void)layoutPages {
	CGSize pageSize = [self pageSize];
    if(self.interfaceOrientation==UIInterfaceOrientationPortrait||self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown){
        self.scrollView.contentSize = CGSizeMake([self.pageViews count] * pageSize.width, pageSize.height);
        
    }else{
        
        self.scrollView.contentSize = CGSizeMake([self.pageViews count] * pageSize.width,1024);
    }
	
	// move all visible pages to their places, because otherwise they may overlap
	for (NSUInteger pageIndex = 0; pageIndex < [self.pageViews count]; ++pageIndex)
		if ([self isPhysicalPageLoaded:pageIndex])
			[self layoutPhysicalPage:pageIndex];
}

//Get number of PDF Pages
-(CGPDFDocumentRef)pdfDocument{
 	
	NSString *pdfPath= str_ContentPath;
	NSURL *pdfURL=[NSURL fileURLWithPath:pdfPath];
	CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
	return pdf;
}
- (NSUInteger)physicalPageIndex {
	CGSize pageSize = [self pageSize];
	return (self.scrollView.contentOffset.x + pageSize.width / 2) / pageSize.width;
}

- (void)setPhysicalPageIndex:(NSUInteger)newIndex {
	self.scrollView.contentOffset = CGPointMake(newIndex * [self pageSize].width, 0);
}

- (NSUInteger)physicalPageForPage:(NSUInteger)page {
	NSParameterAssert(page < pdfPages);
	return (_pageLoopEnabled ? page + pdfPages : page);
}

- (NSUInteger)pageForPhysicalPage:(NSUInteger)physicalPage {
	if (_pageLoopEnabled) {
		NSParameterAssert(physicalPage < 2 * pdfPages);
		return physicalPage % pdfPages;
	} else {
		NSParameterAssert(physicalPage < pdfPages);
		return physicalPage % pdfPages;
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	indicator.hidden=NO;
	[indicator startAnimating];
	NSUInteger newPageIndex = self.physicalPageIndex;
	if (newPageIndex == _currentPhysicalPageIndex) return;
	if(newPageIndex<0)
		newPageIndex=0;

	_currentPhysicalPageIndex = newPageIndex;
	_currentPageIndex = [self pageForPhysicalPage:_currentPhysicalPageIndex];
	lblPageNo.text= [NSString stringWithFormat:@"Page %d of %d", self.physicalPageIndex+1, pdfPages];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	indicator.hidden=YES;
	NSLog(@"scrollViewDidEndDecelerating");
	NSUInteger physicalPage = self.physicalPageIndex;
		NSUInteger properPage = [self physicalPageForPage:[self pageForPhysicalPage:physicalPage]];
	if (physicalPage != properPage)
		self.physicalPageIndex = properPage;
	
	if (_currentPhysicalPageIndex>=1) {
		[self currentPageIndexDidChange];
	}	
	
	
	
}
 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	//[self unloadViews];
}
 



-(void)unloadViews{
	if (self.pageViews) {
		// unload non-visible pages in case the memory is scarse
		for (NSUInteger pageIndex = 0; pageIndex < [self.pageViews count]; ++pageIndex)
			if (pageIndex < _currentPhysicalPageIndex-1 || pageIndex > _currentPhysicalPageIndex+1)
				if ([self isPhysicalPageLoaded:pageIndex]) {
					UIScrollView *pageView = [self.pageViews objectAtIndex:pageIndex];
					[self.pageViews replaceObjectAtIndex:pageIndex withObject:[NSNull null]];
					[[pageView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
					[pageView removeFromSuperview];
					[pageView release];
					pageView=nil;
				}
	}
	
}
- (void)viewDidUnload {
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

    if(toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || toInterfaceOrientation == UIInterfaceOrientationPortrait){
        
        self.scrollView.frame=CGRectMake(0, 0, 768, 1024);
        [self layoutPages];
        
        
    }
        else
        {
            self.scrollView.frame=CGRectMake(128, 0, 768, 1024);
              [self layoutPages];
        }
    
}

#pragma mark analyzePDF
-(void)setPdf:(int)iSelection{
	iPdfSelection=iSelection;
}
//Format
- (NSString *)customizeValueFormat :(int)tmpVal {
	
	NSString *strVal;
	if (tmpVal<10) {
		strVal = [NSString stringWithFormat:@"0%d",tmpVal];
	}
	else {
		strVal = [NSString stringWithFormat:@"%d",tmpVal];
	}
	
	return strVal;
}

 
 
-(void)viewWillDisappear:(BOOL)animated{
	
//	[self unloadViews];
	
}

- (void)dealloc {
	[self viewDidLoad];
    [super dealloc];
}

@end
