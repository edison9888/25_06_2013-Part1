//
//  TDMImageZoomHelper.h
//  TheDailyMeal
//
//  Created by Mrudula Krishanan on 25/04/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDMNavigationController.h"
#import "TDMOverlayView.h"

@protocol ShowNavigationBar <NSObject>
@required
- (void)showNavigationBar;
@end

@interface TDMImageZoomHelper : UIView
{
     id <ShowNavigationBar> navigationBardelegate;
}
@property (nonatomic, assign) TDMOverlayView *overlayView;
@property (nonatomic, assign)id <ShowNavigationBar> navigationBardelegate;
@property (nonatomic, retain)NSString *imagePath;
@property (retain, nonatomic) IBOutlet UIImageView *zoomedImage;

- (IBAction)onCloseButtonClicked:(id)sender;
- (void)showImage;
@end
