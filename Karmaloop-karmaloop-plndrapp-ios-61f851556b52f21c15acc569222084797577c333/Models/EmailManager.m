//
//  EmailManager.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-07-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EmailManager.h"
#import "Constants.h"
#import "Utility.h"
#import "PlndrAppDelegate.h"

@implementation EmailManager

static EmailManager *instance = nil;
+ (EmailManager *)instance {
    if(!instance) {
        instance = [[EmailManager alloc] init];
    }
    return  instance;
}

- (void)sendEmailWithSubject:(NSString *)subject body:(NSString *)body viewController:(UIViewController *)viewController {
    [self sendEmailWithSubject:subject body:body recipients:nil viewController:viewController];
}

- (void)sendEmailWithSubject:(NSString *)subject body:(NSString *)body recipients:(NSArray *)recipients viewController:(UIViewController *)viewController {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        composeViewController.mailComposeDelegate = self;
        
        // Reset nav bar to default appearance.   
        [(PlndrAppDelegate *)[[UIApplication sharedApplication] delegate] updateNavBarAppearanceToDefault:YES];
        
        [composeViewController setSubject:subject];
        [composeViewController setMessageBody:body isHTML:NO];
        [composeViewController setToRecipients:recipients];
        
        [viewController presentModalViewController:composeViewController animated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[Utility localizedStringForKey:kErrorTitleError]
															message:[Utility localizedStringForKey:kSocialManagerEmailNotConfiguredMessage]
														   delegate:nil
												  cancelButtonTitle:[Utility localizedStringForKey:@"OK"]
												  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Customize nav bar appearance
    [(PlndrAppDelegate *)[[UIApplication sharedApplication] delegate] updateNavBarAppearanceToDefault:NO];

    [controller dismissModalViewControllerAnimated:YES];
    
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[Utility localizedStringForKey:@"PLNDR encountered a problem sending your email. Please try again later."] delegate:self cancelButtonTitle:[Utility localizedStringForKey:@"OK"] otherButtonTitles:nil];
		[alertView show];
    }
}

static NSDateFormatter *supportEmailDateFormatter;
+ (NSDateFormatter *)dateFormatterForSupportEmail {
    if (!supportEmailDateFormatter) {
        supportEmailDateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [supportEmailDateFormatter setDateFormat:@"MMMM d, yyyy  h:mm a z"];
    
    return supportEmailDateFormatter;
}

@end
