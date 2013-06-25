//
//  FacebookShareViewController.h
//  PE
//
//  Created by Nithin George on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FacebookShareViewController : UIViewController {
    
    int loginStatus;
    
     IBOutlet UITableView *contentTable;
}
- (void)createCustomNavigationLeftButton;
- (void)logOut;
- (void)checkLiginStatus;

- (IBAction)doneButtonClicked:(id)sender;

@end
