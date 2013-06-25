//
//  PDFPageSearch.h
//  Torq361
//
//  Created by Nithin George on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFViewer.h"

@interface PDFPageSearch : UIViewController {

	IBOutlet UIButton *goToButton;
	IBOutlet UITextField *enterPageNumberField;
	PDFViewer *pdfViewer;
	
}

@property(nonatomic,retain)PDFViewer *pdfViewer;

- (IBAction)gotoPDFPageButtonClicked:(id)sender;

@end
