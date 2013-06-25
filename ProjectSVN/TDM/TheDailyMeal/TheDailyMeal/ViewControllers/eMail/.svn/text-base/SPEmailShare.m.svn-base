/**************************************************************************************
 *  File Name      : SPEmailShare.m
 *  Project Name   : Zenprise
 *  Description    : N/A
 *  Version        : 1.0
 *  Created by     : Sariga V S
 *  Created on     : 26/08/2011
 *  Copyright (C) 2011 RapidValue IT Services Pvt Ltd. Ltd. All Rights Reserved.
 ***************************************************************************************/

#import "SPEmailShare.h"


@implementation SPEmailShare

@synthesize mailSubject;
@synthesize messageBody;
@synthesize toRecipients;
@synthesize ccRecipients;
@synthesize bccRecipients;
@synthesize attachmentList;

#pragma mark -
//To get top ViewControoler
- (UIViewController *)getTopViewController  {
    
    @try {
        UIViewController *topViewController;
        // Try to find the root view controller programmically
        
        // Find the top window (that is not an alert view or other window)
        UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
        if (topWindow.windowLevel != UIWindowLevelNormal)   {
            
            NSArray *windows = [[UIApplication sharedApplication] windows];
            for(topWindow in windows)   {
                if (topWindow.windowLevel == UIWindowLevelNormal)
                    break;
            }
        }
        
        UIView *rootView = [[topWindow subviews] objectAtIndex:0];	
        id nextResponder = [rootView nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//NSLog(@"Found a View Controller");
            topViewController = nextResponder;
        } else if ([nextResponder isKindOfClass:[UINavigationController class]])    {
            //NSLog(@"Found a Navigation Controller");
            topViewController = nextResponder;
        }    else
            NSAssert(NO, @"EmailViewController: Could not find a root view controller. May have some un-wanted subviews in application window");
        
        // Find the top most view controller being displayed (so we can add the modal view to it and not one that is hidden)
               
        
        
        // Wrap the view in a nav controller if not already
        if ([topViewController respondsToSelector:@selector(presentModalViewController:animated:)])    {
            //NSLog(@"Found a presentModalViewController ");
        }
        else    {
            NSAssert(NO, @"EmailViewController: Could not find a root view controller. .");
        }
        
        return topViewController;
    }
    @catch (NSException *exception) {
        //SPErrorLog(@"Exception : in getTopViewController : %@ ",[exception description]);
    }
    @finally {
        
    }  
    return nil;
}

#pragma mark Mail

- (BOOL)canSendMail
{
    return [MFMailComposeViewController canSendMail];
}

//To send mail
- (void)sendMail
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailComposeViewController=[[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate=self;
         
        [mailComposeViewController setSubject:self.mailSubject];
        [mailComposeViewController setToRecipients:self.toRecipients];
        [mailComposeViewController setCcRecipients:self.ccRecipients];
        [mailComposeViewController setBccRecipients:self.bccRecipients];
        [mailComposeViewController setMessageBody:self.messageBody isHTML:YES];
        
        for(NSValue *value in attachmentList)
        {
            struct Attachment attach ;
             [value getValue:&attach];
             if (attach.path)
             {
                 NSData *data=[NSData dataWithContentsOfFile:attach.path];
                 [mailComposeViewController addAttachmentData:data mimeType:attach.attachmentMimeType fileName:attach.attachmentFilename];
                 //NSLog(@"attach.attachmentFilename : %@",attach.attachmentFilename);
             }
        }
        
        UIViewController *topViewController = [self getTopViewController];
        
        //a dependancey - need to prevent policy fetching.
       
        
        mailComposeViewController.navigationBar.barStyle = UIBarStyleBlack;
        [mailComposeViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [mailComposeViewController setModalPresentationStyle:UIModalPresentationFullScreen];
         
        [topViewController presentModalViewController:mailComposeViewController animated:YES];
        [mailComposeViewController release];
        mailComposeViewController = nil;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Can't Open eMail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error        {
    
    NSString *message ;
    // Notifies users about errors associated with the interface
    switch (result)                {
            
        case MFMailComposeResultCancelled:
            message = @"Message Deleted";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            break;
        case MFMailComposeResultSaved:
            message = @"Message Saved";
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Saved" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert1 show];
            [alert1 release];
            break;
        case MFMailComposeResultSent:
            message = @"Message Sent";
            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Sent" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert2 show];
            [alert2 release];
            break;
        case MFMailComposeResultFailed:
            message = @"Failed";
            UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"Sorry" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert3 show];
            [alert3 release];
            break;
        default:
            message = @"Not sent";
            UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:@"Sorry" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert4 show];
            [alert4 release];
            break;
    }
    
    //a dependancey - need to prevent policy fetching.
    
    
    UIViewController *topViewController=[self getTopViewController];
    
    controller.delegate = nil;
    self.mailSubject=nil;
    self.messageBody=nil;
    self.toRecipients=nil;
    self.ccRecipients=nil;
    self.bccRecipients=nil;
    self.attachmentList=nil;
    
    [topViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark memory management

- (void)dealloc {
    
    self.mailSubject=nil;
    self.messageBody=nil;
    self.toRecipients=nil;
    self.ccRecipients=nil;
    self.bccRecipients=nil;
    self.attachmentList=nil;
 
    [super dealloc];
}

@end
