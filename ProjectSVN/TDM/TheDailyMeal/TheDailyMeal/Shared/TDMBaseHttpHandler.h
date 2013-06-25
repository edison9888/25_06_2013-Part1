//
//  TDMBaseHttpHandler.h
//  TheDailyMeal
//
//  Created by Nithin George on 06/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMURLHandler.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#include "SBJson.h"
@protocol TDMBaseHttpHandlerDelegate <NSObject>
@required
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request;
- (void)requestCompletedWithErrors:(ASIHTTPRequest *)theRequest;
@optional
- (void)sessionValid:(BOOL)status;
@end


@interface TDMBaseHttpHandler : NSObject
{
    id <TDMBaseHttpHandlerDelegate> delegate;
    TDMHTTPRequestType requestType;
    BOOL clearCurrentQueue;

}

@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) TDMHTTPRequestType requestType;
@property (nonatomic, assign) BOOL clearCurrentQueue;

+ (void)setSessionCookie: (NSHTTPCookie *)cookie;
+ (NSHTTPCookie *)getSessionCookie;
+ (void)saveSession;
+ (void)clearSession;
+ (BOOL)isSessionInfoAvailable;
- (void)saveTheCookie:(ASIHTTPRequest*)request;
- (BOOL)extractSuccessKeyValue:(NSDictionary*)responseDictionary;
- (BOOL)connected;
+ (TDMHTTPRequestType)getRequestType:(ASIHTTPRequest*)request;
- (void)trackRequestError:(ASIHTTPRequest*)request;

- (void)postRequest:(NSString*)strAPIName withParams:(NSDictionary *)params  withRequestType:(TDMHTTPRequestType)requestType;
- (void)postRequest:(NSString*)apiName RequestBody:(NSString*)strRequest withRequestType:(TDMHTTPRequestType)requestType;
- (void)getRequest:(NSString*)apiName withRequestType:(TDMHTTPRequestType)TDMHTTPrequestType;
- (void)getRequest:(NSString*)strAPIName withParams:(NSDictionary *)params  withRequestType:(TDMHTTPRequestType)requestType;
- (void)putRequest:(NSString *)apiName RequestBody:(NSString *)strRequest withRequestType:(TDMHTTPRequestType)TDMHTTPrequestType;
// Functions to be overridden
//TDMBusinessDetailsProviderAndHandler
- (void)getCurretLocationBusinessdetailsForQuery:(NSString *)query 
                                     forLatitude:(double)latitude 
                                    andLongitude:(double)longitude;

//TDMLogoutHandler
- (void)logoutCurrentUser;

//TDMLoginHandler
- (void)loginUserWithUserName:(NSString *)userName andPassword:(NSString *)password;

//TDMForgotPasswordHandlerAndProvider
-(void)sendForgotPasswordEmail:(NSString *)emailAddress;

//TDMSignupHandlerAndProvider
-(void)signUpUserWithUserName:(NSString *)userName 
               havingPassword:(NSString *)password 
                     andEmail:(NSString *)email 
                  withComment:(NSString *)comment 
         andLegalAcceptOption:(int)legalAccept;

//TDMUserThumbnailHandlerAndProvider
- (void)signUpWithProfileImage:(NSString *)imagePath userId:(NSString *)userId;
//TDMBusinessHomeHandlerAndProvider
-(void)getBusinessHomeDetailsForVenueID:(int)venueNID;

//TDMBusinessReviewHandlerAndProvider
//-(void)getBusinessReviewsForVenueID:(int)venueNID;
- (void)getBusinessReviewsForVenue;

//TDMCityGuideListOfCitiesHandler
-(void)getListOfCitiesForVenueID:(int)vid andParent:(int)parent;

//TDMCityGuideListOfRestaurantsHandler
-(void)getListOfRestaurantsForCity:(NSString *)cityName:(NSString *)guideType:(int) count:(int)offset;

//TDMCityGuideListOfBarsHandler
-(void)getListOfBarsForCity:(NSString *)cityName : (NSString *)guideType:(int) count:(int)offset;

//TDMBusinessSignatureDishesListHandler
-(void)getSignatureDishesListForVenue:(int)venueID;

//TDMBusinessReviewListHandlerAndProvider
-(void)getReviewListForVenueID:(int)venueID;

//TDMUserProfileHandlerAndProvider
-(void)getUserProfileForUserID:(NSString *)userID;

//TDMUploadPhotoHelper
-(void)uploadPhotoFromPath:(NSString *) filePath withFileName:(NSString *)fileName andUploadType:(int)fileType;

//TDMAddSignatureDishHandlerAndProvider
-(void)addSignatureDishWithBody:(NSString *)body andTitle:(NSString *)title forVenue:(NSString *) vid withPhotoFID:(NSString *)photoFID;

//TDMFilePUTHelper
-(void)putFileWithFID:(NSString *) fid;

//TDMFoursquareBrowse
-(void)makeFourSquareBrowseRequestWithQuery:(NSString *)query forLatitude:(float) latitude andLongitude:(float) longitude;

//TDMFoursquareName
-(void)makeFourSquareNameRequestWithQuery:(NSString *)query forLatitude:(float) latitude andLongitude:(float) longitude;

//TDMGetSignatureDishHandlerAndProvider
-(void)getSignatureDishForVenueID:(NSString *)venueID;

//TDMBusinessHomeHandlerAndProvider
-(void)getBusinessReviewsForVenueID:(int)venueNID;

@end
