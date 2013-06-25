//
//  Constants.h
//  TheDailyMeal
//
//  Created by RapidValue on 18/03/12.
//  Copyright (c) 2012 RapidValue IT Services All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FBLoginDelegate <NSObject>
- (BOOL)handleOpenURL:(NSURL *)url;
@end

#pragma mark - Static CodeBlock

#define REMOVE_FROM_MEMORY(__POINTER){if(__POINTER){[__POINTER release];__POINTER = nil;}}
#define REMOVE_IMAGEVIEW_FROM_MEMORY(__POINTER){if(__POINTER){__POINTER.image = nil;[__POINTER release];__POINTER = nil;}}
#define REMOVE_TEXTFIELD_FROM_MEMORY(__POINTER){if(__POINTER){__POINTER.text = nil;[__POINTER release];__POINTER= nil;}}
#define REMOVE_ARRAY_FROM_MEMORY(__POINTER){if([__POINTER count])[__POINTER removeAllObjects];[__POINTER release];__POINTER= nil;}
#define kSHOW_ALERT_WITH_MESSAGE(__TITLE,__MESSAGE){UIAlertView *alert = [[UIAlertView alloc]initWithTitle:__TITLE message:__MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];[alert show];REMOVE_FROM_MEMORY(alert)}


#pragma mark - Distance

#define DEG2RAD(degrees) (degrees * 0.01745327)
#define RADIUS_OF_EARTH 6378.1


#pragma mark - No Network
#define TDM_TITLE  @"The Daily Meal"
#define NO_NETWORK_CONNECTIVITY @"Network Error. Please try after some time."
#define SEGMENT_CONTROL_LIST_BUTTON 1
#define SEGMENT_CONTROL_MAP_BUTTON  0
#define SEGMENT_CONTROL_RESTAUARANTS_BUTTON 0
#define  SEGMENT_CONTROL_BARS_BUTTON 1
#define kBARS_CELL_HEIGHT 76;
#define kCELL_IMAGEVIEW_FRAME CGRectMake(10, 6, 67, 59)
#define kREVIEW_CELL_IMAGEVIEW_FRAME CGRectMake(5,3,80,80)
#define ACTIONSHEET_TITLE   @""
#define ACTIONSHEET_ADD_PHOTO_BUTTON_TITLE   @"Take Photo"
#define ACTIONSHEET_ADD_PHOTO_FROM_LIBRARY_BUTTON_TITLE   @"Choose From Library"
#define ACTIONSHEET_CANCEL_BUTTON_TITLE     @"Cancel"
#define kBUSINESS_NAME_LABEL_FRAME CGRectMake(85, 5, 165, 21)
#define kBUSINESS_ADDRESS_LABEL_FRAME CGRectMake(85, 25, 165, 21)
#define kBUSINESS_CATEGORIES_STATIC_LABEL_FRAME CGRectMake(85, 46, 62, 21)
#define kBUSINESS_CATERIES_INPUT_LABEL_FRAME CGRectMake(146, 46, 104, 21)
#define kBUSINESS_DISTANCE_LABEL_FRAME CGRectMake(260, 5, 60, 21)
#define TAKE_PHOTO_BUTTON_INDEX   0
#define FROM_LIBRARY_BUTTON_INDEX    1

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#pragma mark - ClassNames
#define kACCOUNTS_CLASS @"TDMAccountsViewController"
#define kLOGIN_SIGNUPCLASS @"TDMLoginViewController"
#define kMYPROFILE_CLASS @"TDMMyProfileViewController"
#define kFORGOTPASSWORD_CLASS @"TDMForgotPasswordViewController"
#define kABOUTUS_CLASS @"TDMAboutUsViewController"
#define kSIGNATUREDISH_CLASS @"TDMSignatureDishViewController"
#define kSIGNATUREDISH_DETAILS_CLASS @"TDMSignatureDishDetailsViewController"
#define kADDSIGNATURE_CLASS @"TDMAddSignatureDishViewController"
#define kVIEWREVIEW_CLASS @"TDMViewReviewsViewController"
#define kADDREVIEW_CLASS @"TDMAddReviewViewController"
#define kBUSINESSHOME_CLASS @"TDMBusinessHomeViewController"
#define kADDREVIEW_CONFIRMATION_CLASS @"TDMReviewConfirmationViewController"
#define kSUCCESSPAGE_CLASS @"TDMSuccessPageViewController"
#define kBUSINESSHOME_CLASS @"TDMBusinessHomeViewController"
#define kMYFAVORITES_CLASS @"TDMMyFavoritesViewController"

#pragma mark - Tabbar Index
#define kBARS_TABBAR_INDEX 0
#define kRESTAURANTS_TABBAR_INDEX 1
#define kADD_DISH_TABBAR_INDEX 2
#define kSIGNATUE_DISH_TABBAR_INDEX 3
#define kWISH_LIST_TABBAR_INDEX 4
#define kCITY_GUIDE_TABBAR_INDEX 5
#define kCHANNEL_TABBAR_INDEX 6

#pragma mark - Tabbar Title
#define kTABBAR_TITLE_BARS NSLocalizedString(@"Bars", @"Bars")
#define kTABBAR_TITLE_RESTAURANTS NSLocalizedString(@"Restaurants", @"Restaurants")
#define kTABBAR_TITLE_SIGNATUREDISH NSLocalizedString(@"Best Dishes", @"Best Dishes")
#define kTABBAR_TITLE_CITYGUIDES NSLocalizedString(@"CityGuide", @"CityGuide")
#define kTABBAR_TITLE_FAVORITES NSLocalizedString(@"Favorites", @"Favorites")
#define kTABBAR_TITLE_CHANNELS NSLocalizedString(@"Channels", @"Channels")
#define kTABBAR_TITLE_MORE NSLocalizedString(@"More", @"More")


#pragma mark - URL

#define FOURSQURE_SERVER_URL @"https://api.foursquare.com/"
#define DAILYMEAL_SEVER_PROD @"http://stage.thedailymeal.com:8081"
//#define DAILYMEAL_URL_PATH @"http://stage.thedailymeal.com:8081"
//@"http://www.thedailymeal.com"

#pragma mark - NavigationBar Titles
#define kNAVBAR_TITLE_MY_SETTINGS @"Account"
#define kNAVBAR_TITLE_MY_REVIEW @"Review List"
#define kNAVBAR_TITLE_ADD_REVIEW @"Add Review"

#define kNAVBAR_TITLE_ABOUT_US @"About Us"
#define kNAVBAR_TITLE_MY_PROFILE @"My Profile"
#define kNAVBAR_TITLE_LOGIN @""
#define kNAVBAR_TITLE_SIGN_UP @"Sign Up"
#define kNAVBAR_TITLE_FORGOT_PASSWORD @"Forgot Password"
#define kNAVBAR_TITLE_BEST_DISHES @"Best Dishes"
#define kNAVBAR_TITLE_REVIEWS @"Reviews"
#define kNAVBAR_TITLE_FAVOURITES @"Favorites"

#pragma mark - Images
#define kVIEW_BACKGROUND_IMAGE [UIImage imageNamed:@"viewBG"]
#define kTABBAR_BACKGROUND_IMAGE [UIImage imageNamed:@"tabbarBG"]
#define kTABBAR_BAR_IMAGE [UIImage imageNamed:@"barTab"]
#define kTABBAR_RESTAURANT_IMAGE [UIImage imageNamed:@"restaurantTab"]
#define kTABBAR_SIGNATUREDISH_IMAGE [UIImage imageNamed:@"dishTab"]
#define kTABBAR_FAVORITE_IMAGE [UIImage imageNamed:@"favoriteTab"]
#define kTABBAR_CITYGUIDES_IMAGE [UIImage imageNamed:@"barTab"]
#define kTABBAR_CHANNELS_IMAGE [UIImage imageNamed:@"barTab"]

#define kNAV_BAR_HOME_IMAGE [UIImage imageNamed:@"homeBarButton"]
#define kNAV_BAR_BACK_IMAGE [UIImage imageNamed:@"backBarButton"]

#define kBACK_BAR_BUTTON_TYPE 1
#define kHOME_BAR_BUTTON_TYPE 2
#pragma mark - Table Sections
#define FIRST_SECTION 0
#define SECOND_SECTION 1
#define THIRD_SECTION 2

#pragma mark  - Table Rows
#define FIRST_ROW  0
#define SECOND_ROW 1

#pragma mark - Font Definitions
#define kFONT_FAMILY_NAME @"Trebuchet MS"
#define kFONT_ITALICS @"TrebuchetMS-Italic"
#define kFONT_REGULAR @"TrebuchetMS"
#define kFONT_BOLD_ITALICS @"Trebuchet-BoldItalic"
#define kFONT_BOLD @"TrebuchetMS-Bold"

#define kIS_TO_LOGIN @"isToLogin"

#define kGET_BOLD_FONT_WITH_SIZE(__SIZE) ([UIFont fontWithName:kFONT_BOLD size:__SIZE])
#define kGET_ITALICS_FONT_WITH_SIZE(__SIZE) ([UIFont fontWithName:kFONT_ITALICS size:__SIZE])
#define kGET_BOLDITALICS_FONT_WITH_SIZE(__SIZE) ([UIFont fontWithName:kFONT_BOLD_ITALICS size:__SIZE])
#define kGET_REGULAR_FONT_WITH_SIZE(__SIZE) ([UIFont fontWithName:kFONT_REGULAR size:__SIZE])

#pragma mark - Channels
#define SELECTED_CHANNEL_CATEGORY_ID_KEY @"ChannelID"
#define kEMPTY_STRING @""
#define KALLFEED_CHANNEL_XML        @"http://www.thedailymeal.com/twitterfeed-mainrss.xml"
#define KCOOK_CHANNEL_XML           @"http://www.thedailymeal.com/twitterfeed-cook.xml"
#define KDRINK_XML                  @"http://www.thedailymeal.com/twitterfeed-drink.xml"
#define KENTERTAIN_CHANNEL_XML      @"http://www.thedailymeal.com/twitterfeed-entertain.xml" 
#define KEAT_DINE_CHANNEL_XML       @"http://www.thedailymeal.com/twitterfeed-eatdine.xml"
#define KTRAVEL_CHANNEL_XML         @"http://www.thedailymeal.com/twitterfeed-travel.xml"
#define KTOP_TEN_CHANNEL_XML        @"http://www.thedailymeal.com/twitterfeed-lists.xml"

#define kARRAY_OF_CHANNEL_CATEGORY_XML_LINKS [NSArray arrayWithObjects:KALLFEED_CHANNEL_XML,KCOOK_CHANNEL_XML,KDRINK_XML,KENTERTAIN_CHANNEL_XML,KEAT_DINE_CHANNEL_XML,KTRAVEL_CHANNEL_XML,KTOP_TEN_CHANNEL_XML,nil]

#define KALL_CHANNEL            @"All feeds"
#define KCOOK_CHANNEL           @"Cook"
#define KDRINK_CHANNEL          @"Drink"
#define KENTERTAINN_CHANNEL     @"Entertain"
#define KEAT_DINE_CHANNEL       @"Eat/Dine"
#define KTRAVEL_CHANNEL         @"Travel"
#define KTOP_TEN_CHANNEL        @"Top 10"

#define kARRAY_OF_CHANNEL_NAMES [NSArray arrayWithObjects:KALL_CHANNEL,KCOOK_CHANNEL,KDRINK_CHANNEL,KENTERTAINN_CHANNEL,KEAT_DINE_CHANNEL,KTRAVEL_CHANNEL,KTOP_TEN_CHANNEL,nil]


#define KMORE_FIRST_SECTION_HEADER      @"CITY GUIDES"
#define KMORE_SECOND_SECTION_HEADER     @"CHANNELS"

#define kARRAY_OF_SECTIONHEADING_NAMES [NSArray arrayWithObjects:KMORE_FIRST_SECTION_HEADER,KMORE_SECOND_SECTION_HEADER,nil]

#define KFIRST_CITY     @"Austin"
#define KSECOND_CITY    @"Boston"
#define KTHIRD_CITY     @"Chicago"
#define KFOURTH_CITY    @"Las Vegas"
#define KFIFTH_CITY     @"Los Angeles"
#define KSIXTH_CITY     @"Miami"
#define KSEVENTH_CITY   @"New Orleans"
#define KEIGHT_CITY     @"New York"
#define KNINENTH_CITY   @"Philadelphia"
#define KTENTH_CITY     @"San Francisco"
#define KELEVENTH_CITY  @"Seattle"
#define KTWELFTH_CITY   @"Washington D.C."

#define kARRAY_OF_CITYGUIDE_NAMES [NSArray arrayWithObjects:KFIRST_CITY,KSECOND_CITY,KTHIRD_CITY,KFOURTH_CITY,KFIFTH_CITY,KSIXTH_CITY,KSEVENTH_CITY,KEIGHT_CITY,KNINENTH_CITY,KTENTH_CITY,KELEVENTH_CITY,KTWELFTH_CITY,nil]
//images
#define ACCOUND_BUTTON_IMAGE @"accountImage.png"
#define IMAGE_PNG_TYPE         @"png"
#define IMAGE_JPG_TYPE         @"jpg"

#pragma mark - URLS 
//Sync
#define kSYNC_URL @""

#pragma mark - Business Type

#define SEARCH_BAR_CRITERIA @"nightlife"
#define SEARCH_RESTURANT_CRITERIA  @"restaurants"
#define FOURSQUARE_QUERY @"query"
#define kBUSINESS_REST_TYPE @"restaurant"
#define kBUSINESS_BAR_TYPE @"bar"
#define DATE_STRING @"v"

#define LATITUDE [NSString stringWithFormat:@"%f", [[[NSUserDefaults standardUserDefaults]valueForKey:@"CurrentLattitude"]doubleValue]]
#define LONGITUDE [NSString stringWithFormat:@"%f", [[[NSUserDefaults standardUserDefaults]valueForKey:@"CurrentLongitude"]doubleValue]]


#define LATITUDE_And_LONGITUDE  [NSString stringWithFormat:@"%@,%@",LATITUDE , LONGITUDE]
#define kLatitudeAndLongitude  @"ll"
#define kFourSquareClientID  @"client_id"
#define kFourSquareSecretID  @"client_secret"
#define kBusinessAndStatusApi  @"v2/venues/search?intent=checkin&radius=9999&limit=100&"
#define kBusinessImageAPI @"/v2/venues/"

#define kFacebookQA  @"169827579749932";

#define PREVIOUSLY_SELECTED_TAB_ID @"previouslySelectedTab"

//MapView
#define kDEFAULTPINID @"com.invasivecode.pin"

//Related to Device Camera
#define ERROR_MSG_DIVICE_WITH_NO_CAMERA @"Sorry, your device does not have a camera."
#define MAX_IMAGE_SELECTION @"You can add a maximum of 1 photos to a job."
#define NO_IMAGE_IS_SELECTED @"No image is selected."


#define RESTAURANT_OR_REVIEW_PHOTO 0
#define USER_PHOTO 1

#define FOURSQUARE_CLIENTID @"3OSVSBMMMMAKYBN2QY4FKTHOCW4P3JDN4LCAVRNEBMDH5KD1"
#define FOURSQUARE_SECRETID @"XYT24E2M5SGZKD3GF2NFTO54BDWKWYOO1RO5UV3QIWF4G0AK"


//saved lattitude and longitude

#pragma mark    -
#pragma mark    Messages

#define MSG_LOCATION_AUTHERIZATION_RESTRICTED   @"This application is not authorized to use location services. The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place."

#define MSG_LOCATION_AUTHERIZATION_DENIED   @"The user explicitly denied the use of location services for this application or location services are currently disabled in Settings."

#define MSG_LOCATION_AUTHERIZED @"This application is authorized to use location services."

#pragma mark    -
#pragma mark    Location Specific Data

#define K_USER_NEEDS_CHANGE_ON_LOCATION_UPDATE @"UserNeedsChangeOnLocationUpdate"

#define K_CURRENT_LONGITUDE @"CurrentLongitude"
#define K_CURRENT_LATITUDE @"CurrentLattitude"


#define ASYNC_IMAGEVIEW_TAG 876


#define UNAUTHORISED_MESSSAGE @"Please login to access the complete data."
#define ALERT_TITLE @"The Daily Meal"

#pragma mark    -
#pragma mark    DEFAULT VALUES

#define KDEFAULTLONGITUDE   -123456.0f
#define KDEFAULTLATITUDE    -123456.0f


#define FBAPP_KEY @"169827579749932"
#define MAPQUEST_APPKEY @"Fmjtd%7Cluua2d6b20%2Crl%3Do5-hrrlu"