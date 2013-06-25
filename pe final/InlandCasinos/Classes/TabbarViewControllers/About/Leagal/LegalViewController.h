//
//  LegalViewController.h
//  InlandCasinos
//
//  Created by Nithin George on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface LegalViewController : UIViewController<MFMailComposeViewControllerDelegate> {
    
    int viewIdentifier;
    
    IBOutlet UIWebView *dataDisplay;
    IBOutlet UIView    *indicatorView;
}

@property(nonatomic)int viewIdentifier;

- (void)loadHtml:(NSString *)htmlPath;
- (void)seetingMailBodyComponents:(NSString *)toAddress:(NSString *)subject:(NSString *)body;

@end
