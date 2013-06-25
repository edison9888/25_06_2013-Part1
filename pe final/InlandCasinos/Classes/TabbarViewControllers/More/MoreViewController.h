//
//  MoreViewController.h
//  PE
//
//  Created by Nibin_Mac on 25/06/11.
//  Copyright 2011 Rapidvalue Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MoreViewController : UIViewController {
    
}

- (void)createCustomNavigationLeftButton;
- (void)iconButtonClicked:(id)sender;
- (void)loadAboutViewController;
- (void)loadFavoriteViewController;
- (void)loadSettingViewController;

@end
