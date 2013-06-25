//
//  TwitterViewController.h
//  InlandCasinos
//
//  Created by Nithin George on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TwitterViewController : UIViewController {
    
    BOOL bTwitter;
    
   // IBOutlet UITableView *contentTable;
}

-(void)checkSocialNetworkLoginStatus;
- (void)createCustomNavigationLeftButton;

- (IBAction)doneButtonClicked:(id)sender;

- (void)logOut;

@end
