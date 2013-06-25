//
//  EmailManager.h
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-07-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface EmailManager : NSObject <MFMailComposeViewControllerDelegate>


+(EmailManager*) instance;

- (void)sendEmailWithSubject:(NSString *)subject body:(NSString *)body viewController:(UIViewController *)viewController;
- (void)sendEmailWithSubject:(NSString *)subject body:(NSString *)body recipients:(NSArray*)recipients viewController:(UIViewController *)viewController;

+ (NSDateFormatter *)dateFormatterForSupportEmail;

@end
