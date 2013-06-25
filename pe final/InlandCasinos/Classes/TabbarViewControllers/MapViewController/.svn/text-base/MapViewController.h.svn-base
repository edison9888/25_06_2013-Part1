//
//  MapViewController.h
//  PE
//
//  Created by Nithin George on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface MapViewController : UIViewController {
    
    IBOutlet UIWebView *mapDisplay;
    
    int selectedButtonID;
    
    NSString *mapLink;
    NSString *locationSelectedCasinosName;
    
    GADBannerView *bannerView_;//For displaying admob
}

@property(nonatomic,retain)NSString *mapLink;

@property(nonatomic)int selectedButtonID;

@property(nonatomic,retain)NSString *locationSelectedCasinosName;

- (void)playAdmob;
- (void)createCustomNavigationBackButton;
- (void)backButtonClicked:(id)sender;

@end
