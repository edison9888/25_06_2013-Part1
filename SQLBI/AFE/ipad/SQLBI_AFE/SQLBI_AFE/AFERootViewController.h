//
//  AFERootViewController.h
//  SQLBI_AFE
//
//  Created by Sivakumar Nair on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITabBarItem+AFECustom.h"
#import "AFEBaseViewController.h"
#import "PrintANDMailViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SPPrintHandler.h"



@interface AFERootViewController : AFEBaseViewController<UIPopoverControllerDelegate, PrintANDMailViewDelegate, MFMailComposeViewControllerDelegate>
{
    UIBarButtonItem *searchBarButtonItem;
    UIBarButtonItem *shareBarButtonItem;
    UIPopoverController *sharePopOver;
}

-(void) showSearchController;
-(void) showShareViewController;
-(void) didDismissSearchController;
-(NSString*) getTabbarTitle;

@end
