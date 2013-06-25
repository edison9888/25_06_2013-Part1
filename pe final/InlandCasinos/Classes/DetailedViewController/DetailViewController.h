//
//  DetailViewController.h
//  PE
//
//  Created by Nithin George on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import <MessageUI/MessageUI.h>
//@protocol XMLParserDelegate1 <NSObject>
//-(void)samplemethod;

//@end


@interface DetailViewController : UIViewController<UIGestureRecognizerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate> {
    
    IBOutlet UIToolbar *toolBar;
    IBOutlet UIWebView *webView;
    IBOutlet UIView *indicatorView;
    //IBOutlet UIBarButtonItem *shareButton;
    ///IBOutlet UIBarButtonItem *favoriteButton;
    
    //id <XMLParserDelegate1> delegate;
    
    BOOL hideBar;
    
    NSString *aminityName;
    
    NSMutableArray *listItems;
    
    int selectedListID;
    
    UIButton *backwordBtn;
    UIButton *forwordBtn;
    
    GADBannerView *bannerView_;//For displaying admob
    

}

//@property (nonatomic, retain) id <XMLParserDelegate1> delegate;

@property(nonatomic,retain) UIWebView *webView;

@property(nonatomic,retain) NSString *aminityName;

@property(nonatomic,retain) NSMutableArray *listItems;

@property(nonatomic) int selectedListID;

- (void)playAdmob;
- (void)createTittle;
- (void)addButtonItems;
- (void)setButtonEnability;
- (void)gotoPhotoBrowser;
- (void)webviewTouch;
- (void)loadHtml:(int)index;

- (void)webviewSwipe;

- (void)createCustomNavigationBackButton;
- (void)createCustomNavigationRightButton;
- (void)hideTaBar:(BOOL)flag;
- (void)hideTopBarAndBottomBar:(BOOL)flag;
- (void)showThumDisplay:(NSMutableArray *)photos;

- (NSString *)createDocumentPath;

//Action sheet
- (IBAction)shareButtonClicked:(id)sender;
- (IBAction)showActionSheetFavorate:(id)sender;
- (IBAction)backWordButtonClicked:(id)sender;
- (IBAction)forwordButtonClicked:(id)sender;
- (void)mailButtonClicked;
- (void)twitterButtonClicked;
- (void)FacebookButtonClicked;

- (void)seetingMailBodyComponents:(NSString *)toAddress:(NSString *)subject:(NSString *)body;

@end
