//
//  PrintHandler.m
//  BrightonCreativeStudio
//
//  Created by Runi on 12/01/11.
//  Copyright 2011 RapidValue. All rights reserved.
//

#import "PrintHandler.h"
#import "AppTmpData.h"


@implementation PrintHandler

/*
 Method to print a pdf file.
 */
- (void)printPdf:(NSString *)pdfPath sender:(id)sender delegate:(id)delegate senderView:(UIView *)senderView { 
	NSData *myPdfData = [NSData dataWithContentsOfFile:pdfPath]; 
	UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
	if (controller && [UIPrintInteractionController canPrintData:myPdfData]){
		controller.delegate = delegate;
		UIPrintInfo *printInfo = [UIPrintInfo printInfo]; 
		printInfo.outputType = UIPrintInfoOutputGeneral; 
		printInfo.jobName = [pdfPath lastPathComponent]; 	
		printInfo.duplex = UIPrintInfoDuplexLongEdge; 
		controller.printInfo = printInfo;
		controller.showsPageRange = YES;
		controller.printingItem = myPdfData;	
		
		// We need a completion handler block for printing.
		UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
			if(completed && error){
				NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
			}
		};
		
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            [controller presentFromRect:[sender frame] inView:senderView animated:YES completionHandler:completionHandler];
            
        } else {
            
            [controller presentAnimated:YES completionHandler:completionHandler];
            
        }
        
		//[controller presentFromRect:[sender frame] inView:senderView animated:YES completionHandler:completionHandler];
	}else {
		NSLog(@"Couldn't get shared UIPrintInteractionController!");
	}

}

/*
 Method arranges image and description using HTML and then prints it out.
 */
- (void)printImageAndDescriptionHTML:(NSString *)imagePath textView:(NSString *)description heading
									:(NSString *)heading sender:(id)sender delegate:(id)delegate senderView:(UIView *)senderView {
	// Obtain the shared UIPrintInteractionController
	UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
	if(controller){
		// We need a completion handler block for printing.
		UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
			if(completed && error){
				NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
			}
		};
		
		controller.delegate = delegate;
		// Obtain a printInfo so that we can set our printing defaults.
		UIPrintInfo *printInfo = [UIPrintInfo printInfo];
		
		// This application prints photos. UIKit will pick a paper size and print
		// quality appropriate for this content type.
		printInfo.outputType = UIPrintInfoOutputGeneral;
		// Brighton may or may not be a good name for our print job
		// but that's all we've got.
		printInfo.jobName = @"BrightonCreativeStudio";
		// If we are performing drawing of our image for printing we will print
		// landscape photos in a landscape orientation.
		
		if([[AppTmpData sharedManager] getOrientation]){
			printInfo.orientation = UIPrintInfoOrientationPortrait;
		}else {
			printInfo.orientation = UIPrintInfoOrientationLandscape;
		}	
		// Use this printInfo for this print job.
		controller.printInfo = printInfo;	
		
        /*
		<html>
		<body>
		<h1>heading</h1>
		<img src="imageName"/>
		<p>description</p>
		</body>
		</html>
		*/
		
		NSArray *value = [[[NSArray alloc]init]autorelease];
		value=[imagePath componentsSeparatedByString:@"/"];
		NSString *imageName = [value objectAtIndex: [value count]-1];
		
		NSString *markUpText =@"<html><body><h1><center>";
		markUpText= [markUpText stringByAppendingString:heading];
		markUpText= [markUpText stringByAppendingString:@"</center></h1><center><img src =\""];
		markUpText= [markUpText stringByAppendingString:imageName];
		markUpText= [markUpText stringByAppendingString:@"\" width=\"450\" height=\"500\"/></center><p>"];
		markUpText= [markUpText stringByAppendingString:description];
		markUpText= [markUpText stringByAppendingString:@"</p></body></html>"];
		
		imageName = [NSString stringWithFormat:@"/%@",imageName];
		imagePath = [imagePath stringByReplacingOccurrencesOfString:imageName withString:@""];
		NSURL *url = [NSURL fileURLWithPath:imagePath];

		UIWebView* printWebView = [[[UIWebView alloc]init]autorelease];
		[printWebView loadHTMLString:markUpText baseURL:url];

		UIViewPrintFormatter *viewFormatter = [printWebView viewPrintFormatter]; 
		viewFormatter.startPage = 0;
		viewFormatter.contentInsets	= UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
		controller.printFormatter=viewFormatter;
		
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            [controller presentFromRect:[sender frame] inView:senderView animated:YES completionHandler:completionHandler];
            
        } else {
            
            [controller presentAnimated:YES completionHandler:completionHandler];
            
        }
        
		//[controller presentFromRect:[sender frame] inView:senderView animated:YES completionHandler:completionHandler];	
	}else {
		NSLog(@"Couldn't get shared UIPrintInteractionController!");
	}
}

- (void)dealloc {
	
    [super dealloc];
}

@end
