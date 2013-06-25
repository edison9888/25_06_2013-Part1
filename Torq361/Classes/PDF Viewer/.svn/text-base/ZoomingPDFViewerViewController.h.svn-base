
#import <UIKit/UIKit.h>

@class TiledPDFView;

@interface ZoomingPDFViewerViewController : UIViewController <UIScrollViewDelegate> {
	NSMutableArray *_pageViews;
	UIScrollView *_scrollView;
	NSUInteger _currentPageIndex;
	NSUInteger _currentPhysicalPageIndex;
	
    BOOL _pageLoopEnabled;
	BOOL _rotationInProgress;
 
	 
	NSString *stopTime;
	int iPdfSelection;
    IBOutlet UIActivityIndicatorView *indicator; 
	UILabel *lblPageNo;
	int pdfPages;
	CGPDFDocumentRef pdfDoc;
	 
    
    NSString * str_ContentPath;
}
-(void)setPdf:(int)iSelection;
-(void)unloadViews;
- (NSUInteger)pageForPhysicalPage:(NSUInteger)physicalPage;
- (NSUInteger)physicalPageForPage:(NSUInteger)page;
- (void)setPhysicalPageIndex:(NSUInteger)newIndex;
- (void)loadScrollView;
-(CGPDFDocumentRef)pdfDocument;
- (void)layoutPages;
- (void)currentPageIndexDidChange;
 
 
@property(nonatomic,retain) NSString * str_ContentPath;
@end

