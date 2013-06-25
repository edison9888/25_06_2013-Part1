//
//  Uitilites.h
//  Red Beacon
//
//  Created by Nithin George on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ASIHTTPRequest.h"
//#import "RBRequestInfo.h"

@protocol FBLoginDelegate <NSObject>
- (BOOL)handleOpenURL:(NSURL *)url;
@end

//===========job view controller==================

#define JOB_DETAIL_DEADING @"Who do you need?"
#define JOB_DETAIL_FOOTTER @"Home service done right"
#define COL_COUNT 2
#define HOME_NAVIGATION_TITLE @"Cancel"
#define JOB_LAST_ITEM         @"more soon..."

//===========job request============================
#define JOBREQUEST_ROW_COUNT 2
#define JOBREQUEST_COL_COUNT 1
#define NAV_SUBTITLE @"Job Request"

#define LOCATION_TITLE @"Service Location is"
#define LOCATION_SUB_TITLE @"select location"

#define SCHEDULE_TITLE @"Schedule is"
#define SCHEDULE_SUB_TITLE @"Flexible"



//===========Grid custom cell=======================

#define SECTION_X     10
#define SECTION_SPACE 155
#define SECTION_Y     18
#define SECTION_WIDTH 149
#define SECTION_HEIGHT 36

//==========schedule page===========================
#define SCHEDULE_SECTION_ROW0_MAIN_TITLE @"Flexible"
#define SCHEDULE_SECTION_ROW0_SUB_TITLE @"Find best quotes over next few days"

#define SCHEDULE_SECTION_ROW1_MAIN_TITLE @"Urgent"
#define SCHEDULE_SECTION_ROW1_SUB_TITLE @"Find those available now"

#define SCHEDULE_SECTION_ROW2_MAIN_TITLE @"Start at Date & Time"
#define SCHEDULE_SECTION_ROW2_SUB_TITLE @"Find those available around date & time"

//NavigationTitles
#define kJVCPageTitle @"JobViewController"
#define kJRCSubTitle @"Job Request"
#define kLVCPageTitle @"Location"
#define kSVCPageTitle @"Schedule"

//Frames
//jobViewController
#define jvcBarButtonItemFrame CGRectMake(0, 0, 40, 25)
#define RBNAVIGATIONITEM_TITLEVIEW_RECT CGRectMake(0, 0, 320, 40)

//Images
#define kRBImageType @"png"
#define kRBInfoImage @"setting"
#define kRBLogoImage @"logoImage"
#define locationModeSelectedTickImageName @"RBTick"

#define kRBNavigationTitle_Font_Size 16
#define kRBNavigationSubTitle_Font_Size 12

//Key-Value pairs
#define KEY_VIDEO_NAME @"videoName"
#define KEY_IMAGE_NAME @"imageName"
#define KEY_AUDIO_NAME @"audioName"
#define KEY_USERNAME @"RBUsername"
#define KEY_PASSWORD @"RBPassword"
#define KEY_AUDIO_DURATION @"audioDuration"
#define KEY_SHEDULE_TYPE @"sheduleType"
#define KEY_SCHEDULE_DATE @"scheduleDate"
#define KEY_LOCATION_ZIP @"zipCode"
#define KEY_LOCATION_TYPE @"locationType"
#define KEY_LOCATION_CITYNAME @"CityName"
#define KEY_HASHCODE @"RBHashCode"

#define SCHEDULE_TYPE_FLEXIBLE @"F"
#define SCHEDULE_TYPE_URGENT @"R"
#define SCHEDULE_TYPE_DATE @"N"


#define LOCATION_TYPE_GPS @"GPSMode"
#define LOCATION_TYPE_CUSTOM @"CustomMode"


//Audio constants
#define AUDIO_DURATION 60.0


//Validation alert messages
#define kValidationAlertTitle @"Validation Failed!"
#define kJobRequestSendSuccesfullAlertMessage @"We'll email you quotes as they arrive over the next 48 hours."

#define kGoogleAPIToFetchZipCode @"http://maps.googleapis.com/maps/api/geocode/json?"

#define TimeValuePlist @"RBTimeSelectionValues"
#define kPlistType @"plist"

#define AS_INVALID_ZIPCODE_ALERT_TITLE @"Area not serviced"
#define AS_INVALID_ZIPCODE_ALERT_MESSAGE @"Sorry, we currently don't service this area"
#define AS_FAILED_PREPARE_JOB_REQ_ALERT_MESSAGE @"Job Request failed. Please try again!"
#define AS_FAILED_CONFIRM_JOB_REQ_ALERT_MESSAGE @"Confirm Job Request failed. Please try again!"
#define AS_FAILED_SESSION_EXPIRY_REQ_ALERT_MESSAGE @"Unable to verify session. Please try again!"
#define AS_FAILED_MEDIA_UPLOAD_REQ_ALERT_MESSAGE @"Media upload failed."
#define AS_FAILED_LOGIN_REQ_ALERT_MESSAGE @"Failed to send Login Request. Please try again!"
#define AS_FAILED_SIGNUP_REQ_ALERT_MESSAGE @"Failed to send Signup Request. Please try again!"
#define AS_FAILED_FBLOGIN_REQ_ALERT_MESSAGE @"Failed to send Facebook Login Request. Please try again!"


#define kRedBeaconDidEnterForground @"redBeaconDidEnterForground"
#define kRedBeaconDidEnterBackground @"redBeaconDidEnterBackground"

//Facebook Login credentials
#define FACEBOOKLOGIN_APPID       @"163802440329834"
#define FACEBOOKLOGIN_PERMISSIONS @"publish_stream,offline_access,email"

// Media Type
typedef enum RBMediaType
{
    kImage = 0,
    kAudio = 1,
    kVideo = 2
    
} RBMediaType;

// Media Type
typedef enum RBMediaStatus
{
    kWaitingForUpload = 0,
    kUploadSuccess = 1,
    kUploadFailed = 2,
    kReadyForQueue = 3
    
} RBMediaStatus;

// Request Type
typedef enum RBHTTPRequestType
{
    kLogout = 1,
    kUploadMediaRequest = 2,
    kJobRequestP1 = 3,
    kJobRequestP2 = 4,
    kContent = 5,
    kHash = 6,
    kSignUp = 7,
    kEmailNotTaken = 8,
    kUsernameNotTaken = 9,
    kZipcodeValidation = 10,
    kUnknowRequestType = 11,
    kSessionExpiry = 12,
    kLogin = 13,
    kFacebookLogin = 14
    
} RBHTTPRequestType;

NSString * const kDateFormat;

@interface RBConstants : NSObject
{
    
}

+ (NSString *)urlEncodedParamStringFromString:(NSString *)original;
+ (NSString*)getImageMimeTypeFromName:(NSString*)imageName;
+ (NSString*)getVideoMimeTypeFromName:(NSString*)videoName;
+ (NSString*)getAudioMimeTypeFromName:(NSString*)audioName;
+ (void)deleteMediaFile:(NSString*)filePath;
+ (NSString*)getStringFromDate:(NSDate*)date;
+ (NSString*)mediaTypeToString:(RBMediaType)mediaType;

@end