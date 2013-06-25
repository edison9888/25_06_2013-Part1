
#import "PDFScrollView.h"
#import "TiledPDFView.h"
#import <QuartzCore/QuartzCore.h>
 
 
@implementation PDFScrollView
- (id)initWithFrame:(CGRect)frame PageNo:(int)pageNo PDF:(CGPDFDocumentRef)pdf
{
    if ((self = [super initWithFrame:frame])) {
		// Set up the UIScrollView
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
		[self setBackgroundColor:[UIColor whiteColor]];
		self.maximumZoomScale =3.0;
		self.minimumZoomScale = 0.30;
		//Get the PDF Page that we will be drawing
		page = CGPDFDocumentGetPage(pdf,pageNo);
		CGPDFPageRetain(page);
		// determine the size of the PDF page
		CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
		pdfScale = self.frame.size.width/pageRect.size.width;
		pdfHeight=self.frame.size.height/pageRect.size.height;
		pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
		
		// Create a low res image representation of the PDF page to display before the TiledPDFView
		// renders its content.
		UIGraphicsBeginImageContext(pageRect.size);
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		// First fill the background with white.
		CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
		CGContextFillRect(context,pageRect);
		
		CGContextSaveGState(context);
		// Flip the context so that the PDF page is rendered
		// right side up.
		CGContextTranslateCTM(context, 0.0, pageRect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		// Scale the context so that the PDF page is rendered 
		// at the correct size for the zoom level.
		CGContextScaleCTM(context, pdfScale,pdfScale);	
		CGContextDrawPDFPage(context, page);
		CGContextRestoreGState(context);
		UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
		backgroundImageView.frame = pageRect;
		backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:backgroundImageView];
		[self sendSubviewToBack:backgroundImageView];
		// Create the TiledPDFView based on the size of the PDF page and scale it to fit the view.
		pdfView = [[TiledPDFView alloc] initWithFrame:pageRect andScale:pdfScale];
		
		[self addSubview:pdfView];
		[self setZoomScale:0.80];
        [pdfView setPage:page];
				
    }
    return self;
}

- (void)setPage:(CGPDFPageRef)newPage
{
     CGPDFPageRelease(self->page);
     self->page = CGPDFPageRetain(newPage);
     [pdfView setPage:page];
}

- (void)dealloc{
	// Clean up
    [pdfView release];
	[backgroundImageView release];
	CGPDFPageRelease(page);
    [super dealloc];
}

#pragma mark -
#pragma mark Override layoutSubviews to center content

// We use layoutSubviews to center the PDF page in the view
- (void)layoutSubviews 
{
    [super layoutSubviews];
     // center the image as it becomes smaller than the size of the screen
	
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = pdfView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    pdfView.frame = frameToCenter;
	backgroundImageView.frame = frameToCenter;
    
	// to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
	// tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
	// which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
	//pdfView.contentScaleFactor = 1.0;
}

#pragma mark -
#pragma mark UIScrollView delegate methods

// A UIScrollView delegate callback, called when the user starts zooming. 
// We return our current TiledPDFView.
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	    return pdfView;
}

@end
