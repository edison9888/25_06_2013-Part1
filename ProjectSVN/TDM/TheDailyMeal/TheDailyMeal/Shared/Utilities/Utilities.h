//
//  Utilities.h
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/5/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
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

#pragma mark - No Network
#define TDM_TITLE  @"The Daily Meals"
#define NO_NETWORK_CONNECTIVITY @"No Network connectivity"


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


#pragma mark - NavigationBar Titles
#define kNAVBAR_TITLE_MY_SETTINGS @"Account"
#define kNAVBAR_TITLE_MY_REVIEW @"Review"

#define kNAVBAR_TITLE_ABOUT_US @"About Us"
#define kNAVBAR_TITLE_MY_PROFILE @"My Profile"
#define kNAVBAR_TITLE_LOGIN @"Login"
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


#define KMORE_FIRST_SECTION_HEADER      @"CITY GUIDE"
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
#define ACCOUND_BUTTON_IMAGE @"accountButtonImage.png"
#define IMAGE_PNG_TYPE         @"png"
#define IMAGE_JPG_TYPE         @"jpg"

#pragma mark - URLS 
//Sync
#define kSYNC_URL @""

#pragma mark - Business Type

#define kBUSINESS_REST_TYPE @"restaurant"
#define kBUSINESS_BAR_TYPE @"bar"

#define kFacebookQA  @"169827579749932";

#define kDUMMY_SYNC_JSON @"{syncData:{ syncUpdate:1, lastModifiedDate:11354 }, tables: { business:[ { businessId: 1, cityId: 10, businessType:restaurant, address: 113 Plaza Blvd,Avenue 2, logo:noPath, favoriteFlag: 0, name: My Indian Restaurant, topRestaurant: 0, cheap: 1, 101Restaurant: 43, rating :4 , contactNumber:12356789, “businessLatitude:0, “businessLongitude”:0, “businessReviewCount”:4 }, { businessId: 2, cityId: 11, businessType:bar, address: 113 Plaza Blvd,Avenue 119, logo:noPath, favoriteFlag: 1, name: My American Restaurant, topRestaurant: 1, cheap: 1, 101Restaurant: 25, rating :4 , contactNumber:12356789, “businessLatitude:0, “businessLongitude”:0, “businessReviewCount”:0 },{ businessId: 3, cityId: 15, businessType:restaurant, address: St John Blvd,Avenue 119, logo:noPath, favoriteFlag: 1, name: My Ukranian Restaurant, topRestaurant: 1, cheap: 0, 101Restaurant: 2, rating :5 , contactNumber:12356789, “businessLatitude:0, “businessLongitude”:0, “businessReviewCount”:15 } ], criteria:[ { businessId:1, type:indian }, { businessId:2, type:italian }, { businessId:3, type:indian } ], cityGuide:[ { cityId:10, cityName:Austin }, { cityId:11, cityName:Miami }, { cityId:15, cityName:New York } ], review:[ { businessId:1, reviewId:20, date:1st Jan 2012, desc:This is the review20 description. I cannot have much words to describe this, heading:This will be the review heading, image:no path, name:review20, userName:reviewMonster, rating:4 }, { businessId:2, reviewId:21, date:3rd Jan 2012, desc:This is the review21 description. I cannot have much words to describe this, heading:This will be the review21 heading, image:no path, name:review21, userName:reviewMonster, rating:2 }, { businessId:1, reviewId:22, date:4th Jan 2012, desc:This is the review22 description. I cannot have much words to describe this, heading:This will be the review22 heading, image:no path, name:review22, userName:masterBlaster, rating:0 }, { businessId:1, reviewId:23, date:6th Jan 2012, desc:This is the review23 description. I cannot have much words to describe this, heading:This will be the review23 heading, image:no path, name:review23, userName:boomBoom, rating:5 }, { businessId:3, reviewId:24, date:31st Dec 2012, desc:This is the review24 description. I cannot have much words to describe this, heading:This will be the review24 heading, image:no path, name:review24, userName:Blackeye, rating:1 }, { businessId:3, reviewId:25, date:1st Jan 2012, desc:This is the review25 description. I cannot have much words to describe this, heading:This will be the review25 heading, image:no path, name:review25, userName:Dinkan, rating:5 }, { businessId:3, reviewId:67, date:9th Jan 2012, desc:This is the review67 description. I cannot have much words to describe this, heading:This will be the review67 heading, image:no path, name:review67, userName:Dinkan, rating:0 } ], signatureDish:[ { businessId:1, signatureDishId:30, desc:This is the signatureDish30 description. I cannot have much words to describe this, image:no path, name:Chakka, userName:Dinkan, rating:3 }, { businessId:2, signatureDishId:32, desc:This is the signatureDish32 description. I cannot have much words to describe this, image:no path, name:Maanga, userName:Dinkan, rating:5 }, { businessId:3, signatureDishId:33, desc:This is the signatureDish33 description. I cannot have much words to describe this, image:no path, name:Chakka, userName:Dinkan, rating:5 } ] } } "

#define kDUMDUM @"{syncData:{syncUpdate:1,lastModifiedDate:11354}}"


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

//HTTP
// Request Type
typedef enum TDMHTTPRequestType
{
    
    kCurrentLocationBusinessDetails = 1,
    kTDMLogout = 2,
    kTDMLogin = 3,
    kTDMForgotPassword = 4,
    kTDMSignup = 5,
    kTDMBusinessHome = 6,
    kTDMBusinessReview = 7,
    kTDMCityGuideListOfCities = 8,
    kTDMCityGuideListOfRestaurants = 9,
    kTDMBusinessSignatureDishes = 10,
    kTDMBusinessReviewList = 11,
    kTDMUserProfile = 12,
    kAPNSRegister = 14,
    kAPNSUnregister = 15,
    kFacebookLogin = 16,
    kTDMPhotUpload = 17,
    kTDMAddSignatureDish = 18,
    kTDMFilePUT = 19,
    kTDMFoursquareBrowse = 20,
    kTDMFoursquareName = 21,
    kTDMGetSignatureDish = 22,
    kTDMSignUpWithImage = 24
    
} TDMHTTPRequestType;

//JSON URLs
#define TDM_URL @"http://stage.thedailymeal.com:8080/rest/app/"

//saved lattitude and longitude
