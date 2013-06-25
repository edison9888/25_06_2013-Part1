//
//  Utilities.h
//  PE
//
//  Created by Nithin George on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//Notification events

#define kReloadNotification @"kReload"
#define NOTIFICATION_SWIPE_LEFT @"SwipeLeft"
#define NOTIFICATION_SWIPE_RIGHT @"SwipeRight"
#define NOTIFICATION_ZOOM_IN @"ZoomIn"
#define NOTIFICATION_ZOOM_OUT @"ZoomOut"
#define NOTIFICATION_DOUBLE_TAP @"DoubleTap"


//===================NIB NAMES==========================

//HomeViewController class
#define HOMEVIEWCONTROLLER_NIB_NAME @"HomeViewController"

//ListViewController class
#define LISTVIEWCONTROLLER_NIB_NAME @"ListViewController"

//MapViewController class
#define MAPVIEWCONTROLLER_NIB_NAME @"MapViewController"

//MoreViewController class
#define MOREVIEWCONTROLLER_NIB_NAME @"MoreViewController"

//AboutViewController class
#define ABOUTVIEWCONTROLLER_NIB_NAME @"AboutViewController"

//SettingViewController class
#define SETTINGVIEWCONTROLLER_NIB_NAME @"SettingViewController"

#define SECTIONVIEWCONTROLLER_NIB_NAME @"SectionViewController"

//=======================DATA BASE=============================

#define DATABASENAME @"PEDB.sqlite"//PEDB.db"
 
//=======================TAB BAR ITEMS=========================

#define DEFAULT_TAB_COUNT 5

#define TAB_X 0
#define TAB_Y 0

#define TAB_X_SPACE 65;

#define TAB_WIDTH 60
#define TAB_HEIGHT 49

#define TABBAR_TAG 100
#define ROOT_TAB_NAME @"TabItems"

#define TAB_IMAGE_TYPE @"png" 

#define TAB_0 @"Tab0"

#define TAB_1 @"Tab1"

#define TAB_2 @"Tab2"

#define TAB_3 @"Tab3"

#define TAB_4 @"Tab4"

#define TAB_5 @"Tab5"

#define TAB_6 @"Tab6"

#define TAB_7 @"Tab6"

#define TAB_NAME @"tabName"

#define NAVIGATION_NAME @"navigationName"

#define ICON_NORMAL @"iconNormal"

#define ICON_SELECT @"iconSelect"

//==============TABLE SECSSION==(MORE)==========================
#define MORE_SECSSION_COUNT 1
#define MORE_SECSSION0_ROWCOUNT 8
#define TEXT_ABOUT     @"About"
#define TEXT_SETTING   @"Settings"
#define TEXT_FAVORITES @"Favorites"
//About
#define ABOUT_SECSSION_COUNT 3
#define ABOUT_SECSSION0_ROWCOUNT   2
#define ABOUT_SECSSION1_ROWCOUNT   2
#define ABOUT_SECSSION2_ROWCOUNT   1
#define ABOUT_SECSSION0_ROW0_TEXT  @"Application"
#define ABOUT_SECSSION0_ROW1_TEXT  @"Version"

#define ABOUT_SECSSION0_ROW0_DETAILED_TEXT  @"Inland Casinos"
#define ABOUT_SECSSION0_ROW1_DETAILED_TEXT  @"2.0"

#define ABOUT_SECSSION1_ROW0_TEXT  @"Inland Casinos"
#define ABOUT_SECSSION1_ROW1_TEXT  @"Developed By"

#define ABOUT_INLAND_CASINOS  @"Inland Casinos is one of several smartphone and tablet applications developed for Enterprise Media. Based in Riverside, CA, Enterprise Media offers a variety of multi-platform news and advertising products."

#define ABOUT_DEVELOPED_BY  @"This product is developed by RapidValue - leader in mobility solutions. We are a business and technology solutions firm, focusing on generating accelerated business value enabled by disruptive technologies like the touch-screen mobile technologies and cloud computing.\n\nOur contacts\n\nUSA\n  3333 Bowers Avenue, Suite 130,\n  Santa Clara, CA 95054.\n  p: 408-731-6774 | p: 408-744-6191\n  web: www.rapidvaluesolutions.com\n\nIndia\n  Second Floor, Door no: 203,\n  Tejomaya, L&T TechPark, Infopark,\n  Kakkanad, Kochi, Kerala, India.\n  d: +91 484 4061901"

#define ABOUT_SECSSION2_ROW0_TEXT  @"Legal"

#define ABOUT_TEXT    @"Legal Notice:\n\nInland Casinos and Inland Casinos content copyright © Enterprise Media. All rights reserved."

//Setting
#define SETTING_SECSSION_COUNT 2
#define SETTING_SECSSION0_ROWCOUNT   2
#define SETTING_SECSSION1_ROWCOUNT   1
#define SETTING_SECSSION2_ROWCOUNT   1
#define SETTING_SECSSION0_HEADER     @"Sharing"
#define SETTING_SECSSION1_HEADER     @"Inland Casinos"
#define SETTING_SECSSION2_HEADER     @"Reset"
#define SETTING_SECSSION0_ROW0_TEXT  @"Twitter"
#define SETTING_SECSSION0_ROW1_TEXT  @"Facebook"

//#define SETTING_SECSSION1_ROW0_TEXT  @"Recommend Inland Casinos"
#define SETTING_SECSSION1_ROW1_TEXT  @"Contact Support"
#define SETTING_SECSSION1_ROW2_TEXT  @"Reset"

#define SETTING_SECSSION2_ROW0_TEXT  @"Clear Content Cache"


//Facebook
#define FACEBOOK_TITLE @"Facebook"
#define FACEBOOK_SECSSION_COUNT 2
#define FACEBOOK_SECSSION0_ROWCOUNT 1
#define FACEBOOK_SECSSION1_ROWCOUNT 1
#define FACEBOOK_SECSSION0_FOOTER @"Login to Facebook to share a story." 
#define FACEBOOK_SECSSION0_ROW0_TEXT @"User"
#define FACEBOOK_SECSSION0_ROW0_DESCRIPTION_TEXT_WITHOUT_LOGIN @"Not Logged In"
#define FACEBOOK_SECSSION0_ROW0_DESCRIPTION_TEXT_WITH_LOGIN @"Logged In"
#define FACEBOOK_SECSSION1_ROW0_TEXT @"                             Logout"

//Twitter
#define TWITTER_TITLE @"Twitter"
#define SHKTwitterClass @"SHKTwitter"
#define TWITTER_SECSSION_COUNT 2
#define TWITTER_SECSSION0_ROWCOUNT 1
#define TWITTER_SECSSION1_ROWCOUNT 1
#define TWITTER_SECSSION0_FOOTER @"This page will allow you to logout from your current logged in account." 
#define TWITTER_SECSSION0_ROW0_TEXT @"Current Login Status"
#define TWITTER_SECSSION0_ROW0_DESCRIPTION_TEXT_WITHOUT_LOGIN @"Not Logged In"
#define TWITTER_SECSSION0_ROW0_DESCRIPTION_TEXT_WITH_LOGIN @"Logged In"
#define TWITTER_SECSSION1_ROW0_TEXT @"                             Logout"

//Reset
#define RESET_SECSSION_COUNT 1
#define RESET_SECSSION0_ROWCOUNT   1
#define RESET_SECSSION1_ROWCOUNT   2
#define RESET_SECSSION1_FOOTER    @"Note that Inland Casinos requires network connectivity after a reset to function"
#define RESET_SECSSION0_ROW0_TEXT  @"Clear Content Cache"
#define RESET_SECSSION1_ROW0_TEXT  @"Reset Connection"
#define RESET_SECSSION1_ROW1_TEXT  @"Reset All Settings and Cache"

//ActionSheet
#define CLEAR_CACHE_TITLE   @"Please note that Inland Casinos requires network connectivity after clearing cache content."
#define ACTION_BUTTON_TITLE @"Clear Cache"

#define RESET_CACHE_TITLE   @"Reset the news server connection? cached and saved content will be preserved"
#define RESET_BUTTON_TITLE  @"Reset"

#define RESET_ALL_CACHE_TITLE   @"Reset all settings and clear cached content? Saved content will not be preserved"
#define RESET_ALL_BUTTON_TITLE  @"Reset"

//=======================mail=============================
#define SETTING_MAIL1_SUBJECT       @"Inland Casinos App" 
#define SETTING_MAIL1_BODY          @"Thought you might be interested in the Inland Casinos iPhone and iPod Touch app...You can download it from the iTunes App Store using the following link:\n http://apps.vervewirelesss.com/store.php?id=penterprise" 
#define SETTING_MAIL1_TO_ADDRESS    @""

#define SETTING_MAIL2_SUBJECT       @"Inland Casinos Support" 
#define SETTING_MAIL2_BODY          @" \n\n\n-- \n Application: Inland Casinos \n Version: 2.0" 
#define SETTING_MAIL2_TO_ADDRESS    @"feedback@pe.com"

//=======================IMAGE NAMES=======================

#define DEFAULT_IMAGE       @"icon.png"
#define SETTING_IMAGE       @"settings.png"
#define SETTING_CLOSE_IMAGE @"SettingClose.png"

//==========Database=====================================

#define HOME_TYPE @"casino"
#define HOME_TAG  @"parent_idmenu"

#define IMAGE_DEFAULT_VALUE  @"Pending"
#define IMAGE_DOWNLOAD_VALUE @"Sucess"

#define TABBAR_DINING    @"Dining" 
#define TABBAR_EVENTS    @"Events"
#define TABBAR_MORE      @"More"
#define TABBAR_FAVORITES @"Favorites"
#define IMAGE_DISPLAY_NAV_BACK_TITTLE @"Story"

#define INITIAL_BUILD_DATE @"Thu, 21 Jul 2005 16:27:10 GMT"

//favorite status==============================================

#define NOTFAVORATE 0;
#define YESFAVORITE 1;

//==========Folder creation=====================================

#define PARENTFOLDER @"PE.com"
#define MAPIDETEFIER  @"Location"

//==========================HOME sections=================

#define ROOT_HOME_SECTION_NAME @"HomeSections"

#define SUB_HOME_SECTION_NAME @"Sections"

#define HOME_SECTION_COUNT 11

#define HOME_SECTION_TAG @"tag"

#define COL_COUNT 3

#define SECTION_X 27

#define SECTION_SPACE 100

#define SECTION_Y 18

#define SECTION_WIDTH 57//70

#define SECTION_HEIGHT 57//70

#define SECTION_LABLEL_X 20

#define SECTION_LABLEL_Y 70//90

#define SECTION_LABLEL_WIDTH 60//70

#define SECTION_LABLEL_HEIGHT 35//20

//===============imageThum Display==========

#define THUMB_COL_COUNT 4

#define THUMB_X 15

#define THUMB_SPACE 70

#define THUMB_Y 18

#define THUMB_WIDTH 57

#define THUMB_HEIGHT 57

//=================tabbar ites data=========
#define TABBAR_LOCATION_LINK @"http://res.pe.com/maps/allcasinos.html"

//==========================Sub sections=====
#define SRCTAG @"src=\""

#define HREFTAG @"href=\""

#define URLENDELEMENT @"\""

#define CONTENT_PART @"<p>"

#define IMG_START_TAG @"<img" 

#define IMG_END_TAG @"<" 

#define SMALL_IMAGE 0

#define LARGE_IMAGE 1

//image types
#define LARGEJPG @"JPG"

#define SMALLJPG @"jpg"

#define LARGEPNG @"PNG"

#define SMALLPNG @"png"

//==================RSS FEED=================
#define SUB_SECTION_NAME @"SubSections"

#define SUB_SECTION_ROW_COUNT 4


//===========ListView========================

#define LISTVIEW_COL_COUNT 1

#define LISTVIEW_SECTION_X 1

#define LISTVIEW_SECTION_Y 0

#define LISTVIEW_SECTION_SPACE 10

#define LISTVIEW_SECTION_WIDTH 62//70//80

#define LISTVIEW_SECTION_HEIGHT 62//75//90

//Header Label
#define LISTVIEW_SECTION_HEADERLABLEL_X 65

#define LISTVIEW_SECTION_HEADERLABLEL_Y 1

#define LISTVIEW_SECTION_HEADERLABLEL_WIDTH 220

#define LISTVIEW_SECTION_HEADERLABLEL_HEIGHT 18//40

//Detail Label
#define LISTVIEW_SECTION_DETAILLABLEL_X 65

#define LISTVIEW_SECTION_DETAILLABLEL_Y 20

#define LISTVIEW_SECTION_DETAILLABLEL_WIDTH 230

#define LISTVIEW_SECTION_DETAILLABLEL_HEIGHT 25//80

//Date & Time Label
#define LISTVIEW_SECTION_DATELABLEL_X 65

#define LISTVIEW_SECTION_DATELABLEL_Y 45

#define LISTVIEW_SECTION_DATELABLEL_WIDTH 220

#define LISTVIEW_SECTION_DATELABLEL_HEIGHT 15//20



//===========***********========================

#define GAD_SIZE_320x50 CGSizeMake(320, 50)

// Medium Rectangle size for the iPad (especially in a UISplitView's left pane).
#define GAD_SIZE_300x250 CGSizeMake(300, 250)

// Full Banner size for the iPad (especially in a UIPopoverController or in
// UIModalPresentationFormSheet).
#define GAD_SIZE_468x60 CGSizeMake(468, 60)

// Leaderboard size for the iPad.
#define GAD_SIZE_728x90 CGSizeMake(728, 90)


//************html display**************************

#define HTMLTAG_WITHOUT_IMAGE @"<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'><html><head><META http-equiv='Content-Type' content='text/html; charset=utf-8'></head><body><div><div><p><p><b>%@</b></p><p>%@</p><div><a href=%@></a><p>%@</p></div></p></div></div></body></html>"

//#define HTMLTAG_WITH_IMAGE @"<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'><html><head><META http-equiv='Content-Type' content='text/html; charset=utf-8'></head><body><div><div><p><p><b>%@</b></p><p>%@</p><div><a href=%@><img src=%@ align=right width=80 height=80/></a><p>%@</p></div></p></div></div></body></html>"



#define HTMLTAG_WITH_IMAGE @"<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'><html><head><META http-equiv='Content-Type' content='text/html; charset=utf-8'></head><body><div><div><p><p><b>%@</b></p><p>%@</p><div style=\"float:right;\"><a href=%@><img src=%@ align=right width=80 height=80/></a><p>%@</p></div><span>%@</span></p></div></div></div></body></html>"


#define SHARE_TEXT @"Hi,\n\nI thought of sharing some interesting events at Inland Casinos. Please visit "

#define SHARE_TWITTER_TEXT @"Thought of sharing some interesting events. Visit "

//Below are the variables define for AdMob

NSString *activePublisherID; //Publisher ID mentioned in this variable will be used for displaying Ad 


//Below values are for testing purpose
//#define PremierPagePublisherID     @"a14e4502603c2f3"

#define PremierPagePublisherID     @"a14f2b84f669e41"
#define AguaCalientePublisherID    @"a14f2b77d756928"
#define FantasySpringsPublisherID  @"a14f2b8099da32d"
#define HarrahsPublisherID         @"a14f2b810f707dd"
#define MorongoPublisherID         @"a14f20c457bf2b2"
#define PalaPublisherID            @"a14f20c5121d7cb"
#define PaumaPublisherID           @"a14f2b81f900eb8"
#define PechangaPublisherID        @"a14f2b826800533"
#define SanManuelPublisherID       @"a14f2b830aa4507"
#define SobobaPublisherID          @"a14f2b8385d42c8"
#define SpaResortPublisherID       @"a14f2b83ef46935"
#define Spotlight29PublisherID     @"a14f2b8494f0893"


