    //
//  PDFImageCreater.m
//  Torq361
//
//  Created by Nithin George on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFImageCreater.h"
#import "Utilities.h"


@implementation PDFImageCreater

@synthesize iTotalPages;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.


/*
 - (id) init
 {		
 if (choice == 0) {
 NSMutableArray *mediaDetails=[[AppTmpData sharedManager] getContentDetailsArr];
 SelectedContentStore *obj_SelectedContentStore=[mediaDetails objectAtIndex:[[AppTmpData sharedManager]getCurrentSelectedContentId]];	
 
 CFStringRef path = (CFStringRef) obj_SelectedContentStore.str_ContentPath;
 
 pdfURL =CFURLCreateWithFileSystemPath (NULL, path,kCFURLPOSIXPathStyle, 0);
 pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
 
 iTotalPages=CGPDFDocumentGetNumberOfPages(pdf);
 }
 
 else if(choice == 2) {
 NSMutableArray *LandscapeMediaDetails = [[AppTmpData sharedManager] getLandscapeContentDetailsArray];
 int iSelSection = [[AppTmpData sharedManager] getSelectedSectionInLandscapeTable];
 int iSelIndex = [[AppTmpData sharedManager] getSelectedIndexInLandscapeTable];
 
 NSMutableArray *tmpSelectedContentArray = [LandscapeMediaDetails objectAtIndex:iSelSection];
 SelectedContentStore *objSelectedContentStore = [tmpSelectedContentArray objectAtIndex:iSelIndex];
 
 CFStringRef path = (CFStringRef) objSelectedContentStore.str_ContentPath;
 
 pdfURL =CFURLCreateWithFileSystemPath (NULL, path,kCFURLPOSIXPathStyle, 0);
 pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
 
 iTotalPages=CGPDFDocumentGetNumberOfPages(pdf);
 }
 }
 */



-(id)initWithPdfName:(NSString *)filePath	{
	
	self = [super init];
	if (self != nil) {
	
		
		int choice;
		
		choice = [[AppTmpData sharedManager] getPDFMode];
/*		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *basePath = [paths objectAtIndex:0];
		NSString *tempSlash=@"/";
		basePath = [basePath stringByAppendingString:tempSlash]; 
		NSString *temp=filePath;
		basePath = [basePath stringByAppendingString:temp]; 
		
		pdfURL =CFURLCreateWithFileSystemPath (NULL, basePath,kCFURLPOSIXPathStyle, 0);
	*/
		
		pdfURL =CFURLCreateWithFileSystemPath (NULL, filePath,kCFURLPOSIXPathStyle, 0);
		pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
		iTotalPages=CGPDFDocumentGetNumberOfPages(pdf);
	}
	
	return self;
}




-(UIImage *)initialize :(int) i :(BOOL)iOrientation{
	CGSize pageSize;
	if(iOrientation){
		pageSize=CGSizeMake(1024, 768);
	}
	else {
		pageSize=CGSizeMake(150, 180);
	}
	
	
	
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, 
												 pageSize.width, 
												 pageSize.height, 
												 8,						
												 pageSize.width * 4, 	
												 colorSpace, 
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	
	if(iOrientation){
		CGContextClipToRect(context, CGRectMake(0, 0, pageSize.width, pageSize.height));
	}
	else {
		CGContextClipToRect(context, CGRectMake(0, 0, 150, 180));
	}
	
	
	
	
	
	[self renderPageAtIndex:i+1 inContext:context];
	
	CGImageRef image = CGBitmapContextCreateImage(context);	
	CGContextRelease(context);
	
	//[UIImage imageWithCGImage:image];
	//*****
	//UIImage * img=[UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
	
	
	
	//NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/1.png"];
	
	UIImage *img =[UIImage imageWithCGImage:image];
	//NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
	
	CGImageRelease(image);
	
	
	
	//[imageData writeToFile:pngPath atomically:YES];	
	
	return img;
	
}


- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	
	if (!pdf) {			
		
		pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);		
		
	}	
	
	CGPDFPageRef page = CGPDFDocumentGetPage(pdf, index);
	CGAffineTransform transform = aspectFit(CGPDFPageGetBoxRect(page, kCGPDFMediaBox),
											CGContextGetClipBoundingBox(ctx));
	CGContextConcatCTM(ctx, transform);
	CGContextDrawPDFPage(ctx, page);
	
	CGPDFDocumentRelease(pdf);
	pdf=nil;
	
	
	
}

- (void)dealloc {
	//CGPDFDocumentRelease(pdf);
	//pdf=nil;
	[super dealloc];
}


@end