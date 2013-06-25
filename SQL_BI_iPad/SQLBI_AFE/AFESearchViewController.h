//
//  AFESearchViewController.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFERootViewController.h"
#import "SearchViewController_AFE.h"
#import "AFESearchDetailViewController.h"
#import "AFESearchAPIHandler.h"
#import "PrintANDMailViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SPPrintHandler.h"
#import "AFE.h"



@interface AFESearchViewController : AFERootViewController<SearchViewControllerAFEDelegate>


-(void) searchAFEDetailsWithAFEObject:(AFE*) afeObj;


@end
