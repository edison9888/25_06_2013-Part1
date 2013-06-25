    //
//  PDFPageSearch.m
//  Torq361
//
//  Created by Nithin George on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFPageSearch.h"



@implementation PDFPageSearch
@synthesize pdfViewer;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    enterPageNumberField.delegate       = self;
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark -
#pragma mark TextField Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
	NSNumber* candidateNumber;
	
	NSString* candidateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	
	range = NSMakeRange(0, [candidateString length]);
	
	[numberFormatter getObjectValue:&candidateNumber forString:candidateString range:&range error:nil];
	
	if (([candidateString length] > 0) && (candidateNumber == nil || range.length < [candidateString length])) {
		
		return NO;
	}
	else
	{
		return YES;
	}
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)gotoPDFPageButtonClicked:(id)sender {
	
	
	//PDFViewer *pdfViewer=[[PDFViewer alloc]initWithNibName:@"PDFViewer" bundle:nil];
	
	NSString *temp = enterPageNumberField.text; 
	int pageNumber = [temp intValue];
	[enterPageNumberField resignFirstResponder]; 
	[pdfViewer goPDFCorrectPage:pageNumber];	
    [pdfViewer release];
     pdfViewer  = nil;
    NSLog(@"RETAIN COUNT OF PDF SEARCH==%d",[self retainCount]);

}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.pdfViewer = nil;
    
}

- (void)viewWillDisappear:(BOOL)animated {
   // [self viewDidUnload];
   // [self dealloc];
}
- (void)dealloc {
    [super dealloc];
    
 
    [goToButton release];
    [pdfViewer release];
     goToButton = nil;
    [enterPageNumberField release];
     enterPageNumberField = nil;

}


@end
