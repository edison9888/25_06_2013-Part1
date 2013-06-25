//
//  TDMBusinessHomeViewController.h
//  TheDailyMeal
//
//  Created by user on 18/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
 #import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "DisplayMap.h"
#import <MessageUI/MessageUI.h>
#import "TDMFBLoginViewController.h"
#import "TDMFaceBookHandler.h"
#import "Twitter.h"
#import "ShareView.h"
#import "Twitter.h"
#import "SPEmailShare.h"
#import "TDMGetSignatureDishHandlerAndProvider.h"
#import "TDMBusinessReviewListHandlerAndProvider.h"

typedef enum businessShowType {
    businessWithSignatureAndReview = 0,
    businessWithEitherSignatureORReview ,
    businessWithNOSignatureANDReview   
}businessType;

@interface TDMBusinessHomeViewController : TDMBaseViewController<MKMapViewDelegate,UIActionSheetDelegate,TDMGetSignatureDishHandlerAndProviderDelegate>
{
    
    BOOL isSignatureDish;
    BOOL isReviewList;
    businessType tableType;
    MKMapView *mapView;
    Twitter *objTwitter;
    NSMutableArray *businessDetails;
    NSMutableDictionary *dict;
    NSMutableArray *arrayOfAddressID;
    SPEmailShare *objEmailShare;
    ShareView *dialog;
}

@property (assign, nonatomic) int businessId;
@property (assign, nonatomic) int businesType;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (retain, nonatomic) NSMutableArray *arrayOfAddressID;
@property (retain, nonatomic) IBOutlet UITableView *businessTable;

- (void)setTable;
- (void) sendEmailTo:(NSString *)to withSubject:(NSString *) subject withBody:(NSString *)body;
@end
