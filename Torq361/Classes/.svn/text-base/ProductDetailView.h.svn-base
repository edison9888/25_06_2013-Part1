//
//  ProductDetailView.h
//  Torq361
//
//  Created by JK on 22/06/11.
//  Copyright 2011 RapidValue . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"
#import "ProductDetails.h"
#import "AppTmpData.h"
#import "ScrollSlideView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>
#import "ContentDetails.h"
#import "ImagesViewer.h"
#import "PageBrowser.h"
#import "ReaderViewController.h"
 

@protocol ProductDetailViewDeligate <NSObject>

-(void)productDetailViewClosed;

@end
@interface ProductDetailView : UIViewController<ReaderViewControllerDelegate> {
    
    
    //labels(2)
    IBOutlet UILabel       * labelShareWith;
    IBOutlet UILabel       * productName;    
    
    ///button (6)
    IBOutlet UIButton      * descriptionButton;
    IBOutlet UIButton      * productDetailsButton;
    IBOutlet UIButton      * TechnicalDetailsButton;
    IBOutlet UIButton      * fBButton;
    IBOutlet UIButton      * twitterbutton;
    IBOutlet UIButton      * MailButton;
    
    //textView(2)
    IBOutlet UITextView    * textViewDetailedDescription;
    IBOutlet UITextView    * textViewDescription;
    
    //Views(4)
    IBOutlet UIView         * textBackgroundView;
    IBOutlet UIView         * shareOptionsView;
    IBOutlet UIView         * selectionButtonView;
    IBOutlet UIView         * bottomContainerView;
    
    //imageViews(8)
    IBOutlet UIImageView   * descriptionButtonImage;
    IBOutlet UIImageView   * thumbnailSelectionImage;    
    IBOutlet UIImageView   * thumbnailContainer;
    IBOutlet UIImageView   * imageViewred_border;
    IBOutlet UIImageView   * backgroundImage;
    IBOutlet UIImageView   *prodThumpImage;
    IBOutlet UIImageView   *prodThumpImageBg;
    IBOutlet UIImageView   *prodThumpScrollBack;
    IBOutlet UIImageView   *prodThumpScrollFront;
    
    
    ProductDetails * productDetails;
    
    PageBrowser *pageBrowser;
    
#pragma valuepassed
    
    int productId;

#pragma contents arry
    
    NSMutableArray *  contentslist;
    //NSMutableArray *  imageContents;
    //NSMutableArray *  pdfContents;
    //NSMutableArray *  VideoContents;

    
    ScrollSlideView *ScrollButton0;
    ScrollSlideView *ScrollButton1;
    ScrollSlideView *ScrollButton2;
    
    int totalContentCount;
    int imagecount;
    int pdfcount;
    int videocount;
    int currIndex;
    int currIndexthumb;

    id<ProductDetailViewDeligate> deligate;
    
    //MPMoviePlayerController * moviePlayer; 
    
    //ZoomingPDFViewerViewController *zoomingPDFViewerViewController;

    
}
@property(nonatomic)int productId;
@property(nonatomic,retain)id<ProductDetailViewDeligate> deligate;
@property(nonatomic,retain) ProductDetails * productDetails;

//@property(nonatomic,assign) ProductDetails * productDetails;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender;
-(UIImage*)getimage:(ContentDetails *) content;

- (IBAction)facebookButtonClicked:(id)sender;
- (IBAction)twitterButtonClicked:(id)sender;
- (IBAction)mailButtonClicked:(id)sender;

-(IBAction)productDetailedDescButtonClicked:(id)sender;
 
-(void)setDisplay;
-(void)loadContentScroll:(int) index;

- (IBAction)backButtonClicked:(id)sender;
-(void)createScrollviewContent;
-(void)loadDefaultImages;
-(void)setScrollImage:(int)onpage:(ContentDetails *) content:(int )scroolltag:(int)index;
-(void)showThumbnailScrollView;
-(void)unloadThumbnailScrollView;
-(void)showImageViewer;
-(void)showImageViewerWithIndex:(int)index fromPath:(NSString*)strDownloadDestiantionPath;
-(void)showVideoViwerWithFile:(NSString *)filePath;
-(void)showPdfViewerWithFile:(NSString*)pdfFile;
@end
