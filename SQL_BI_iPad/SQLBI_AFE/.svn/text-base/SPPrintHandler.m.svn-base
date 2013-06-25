#import "SPPrintHandler.h"


@implementation SPPrintHandler

#pragma  mark Print Handler

// Methods for print

- (BOOL)printFileOrientation:(UIPrintInfoOrientation)orientation popUpFromRect:(CGRect)rect delegate:(id)delegate senderView:(UIWebView *)senderView { 
    
    BOOL success = YES;
	
	float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	
	if (systemVersion>4.1) { 
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
           if (controller)  {
               
			controller.delegate = delegate;
			UIPrintInfo *printInfo = [UIPrintInfo printInfo]; 
			printInfo.outputType = UIPrintInfoOutputGeneral; 
			//printInfo.jobName = [filePath lastPathComponent]; 
            printInfo.jobName=@"Print";
               
            printInfo.orientation=orientation;
            if((orientation==1)|| (orientation==2)){
                printInfo.duplex = UIPrintInfoDuplexLongEdge;  
            }
            else if((orientation==3) ||(orientation==4)){
                printInfo.duplex =UIPrintInfoDuplexShortEdge;
            } 
			
			controller.printInfo = printInfo;
			controller.showsPageRange = YES;
          
            // Print from webview
            UIViewPrintFormatter *viewFormatter=[senderView viewPrintFormatter];
            viewFormatter.startPage=0;
            controller.printFormatter = viewFormatter;
            viewFormatter = nil; 
          
			// We need a completion handler block for printing.
            
			UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if(completed && error)  {
                    
                //NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
              }
            };
			
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                
                [controller presentFromRect:rect inView:senderView animated:YES completionHandler:completionHandler];
            } 
            else {
                
                [controller presentAnimated:YES completionHandler:completionHandler];
            }

		}
        else {
               //NSLog(@"Couldn't get shared UIPrintInteractionController : Unsupported file format.");
            success = NO;
		}
	}	
	
    return success;
}

- (BOOL)printFileOrientation:(UIPrintInfoOrientation)orientation popUpFromRect:(CGRect)rect delegate:(id)delegate printView:(UIWebView *)senderView AndDisplayView:(UIView *)displayView { 
    
    BOOL success = YES;
	
	float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	
	if (systemVersion>4.1) { 
        UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
        if (controller)  {
			controller.delegate = delegate;
			UIPrintInfo *printInfo = [UIPrintInfo printInfo]; 
			printInfo.outputType = UIPrintInfoOutputGeneral; 
			//printInfo.jobName = [filePath lastPathComponent]; 
            printInfo.jobName=@"Print";
            
            printInfo.orientation=orientation;
            if((orientation==1)|| (orientation==2)) {
                printInfo.duplex = UIPrintInfoDuplexLongEdge;  
            }
            else if((orientation==3) ||(orientation==4))    {
                printInfo.duplex =UIPrintInfoDuplexShortEdge;
            } 
			
			controller.printInfo = printInfo;
			controller.showsPageRange = YES;
            
            // Print from webview
            UIViewPrintFormatter *viewFormatter=[senderView viewPrintFormatter];
            viewFormatter.startPage=0;
            controller.printFormatter = viewFormatter;
            viewFormatter = nil; 
            
			// We need a completion handler block for printing.
            
			UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
                if(completed && error){
                    
                    //NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code); 
                }
            };
			
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                
                [controller presentFromRect:rect inView:displayView animated:YES completionHandler:completionHandler];
            } 
            else {
                
                [controller presentAnimated:YES completionHandler:completionHandler];
            }
            
		}
        else {
            //NSLog(@"Couldn't get shared UIPrintInteractionController : Unsupported file format.");
            success = NO;
		}
	}	
	
    return success;
}

- (BOOL)printFileOrientation:(UIPrintInfoOrientation)orientation popUpFromRect:(CGRect)rect delegate:(id)delegate printData:(NSData *)data AndDisplayView:(UIView *)displayView { 
    
    BOOL success = YES;
	
	float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	
	if (systemVersion>4.1) { 
        UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
        if (controller)  {
			controller.delegate = delegate;
            controller.printingItem = data;
            
			// We need a completion handler block for printing.
            
			UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
                if(completed && error){
                    
                    //NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code); 
                }
            };
			
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                
                     [controller presentFromRect:CGRectMake(924, 10, 50, 50) inView:displayView animated:YES completionHandler:completionHandler];
                    //  [controller presentFromBarButtonItem:self.navigationItem.rightBarButtonItem  animated:YES completionHandler:completionHandler];
            } else {
                
                [controller presentAnimated:YES completionHandler:completionHandler];
            }
            
		}
        else {
            //NSLog(@"Couldn't get shared UIPrintInteractionController : Unsupported file format.");
            success = NO;
		}
	}	
	
    return success;
}

- (BOOL)printFileOrientation:(UIPrintInfoOrientation)orientation popUpFromRect:(CGRect)rect delegate:(id)delegate printItems:(NSArray *)array AndDisplayView:(UIView *)displayView { 
    
    BOOL success = YES;
	
	float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	
	if (systemVersion>4.1) {
        UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
        if (controller)  {
			controller.delegate = delegate;
            controller.printingItem = array;
            
			// We need a completion handler block for printing.
            
			UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
                if(completed && error){
                    
                    //NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
                }
            };
			
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                
                [controller presentFromRect:rect inView:displayView animated:YES completionHandler:completionHandler];
                
            } 
            else {
                
                [controller presentAnimated:YES completionHandler:completionHandler];
            }
            
		}
        else {
            //NSLog(@"Couldn't get shared UIPrintInteractionController : Unsupported file format.");
            success = NO;
		}
	}	
	
    return success;
}


#pragma mark memory management

- (void)dealloc {
       
}
@end
