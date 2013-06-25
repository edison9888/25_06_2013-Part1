//
//  PDFImageCreater.h
//  Torq361
//
//  Created by Nithin George on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppTmpData.h"


@interface PDFImageCreater : NSObject {
	
	CGPDFDocumentRef pdf;
	CFURLRef pdfURL;
	int iTotalPages;

	
}

-(id)initWithPdfName:(NSString *)filePath;

-(UIImage *)initialize :(int) i :(BOOL)bOrientation;

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx;



@property(nonatomic) int iTotalPages;


@end
