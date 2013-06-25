
    //
//  AFEConstants.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Anchor.h"
#import "AnchorInfo.h"
#import "MIMColor.h"
#import "MIMColorClass.h"
#import "LineInfoBox.h"
#import "YAxisBand.h"
#import "XAxisBand.h"
#import "MIM_MathClass.h"
#import "LineScrollView.h"
#import "MIMMeter.h"
#import "BarInfoBox.h"
#import "MIMProperties.h"
#import "MIMFloatingView.h"


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#ifdef DEBUG 
#define DEBUG_MODE 1
#endif

#ifndef DEBUG 
#define DEBUG_MODE 0
#endif

#define X_AXIS_HEIGHT 100

typedef enum
{
    USERDEFINED=1,
    REDTINT,
    GREENTINT,
    BEIGETINT
    
}TINTCOLOR;


typedef enum{
    
    SQUAREFILLED=1,
    SQUAREBORDER=2,
    CIRCLEFILLED=3,
    CIRCLEBORDER=4,
    CIRCLE=5,//Circle with border as fill Color
    SQUARE=6,
    NONE=7,
    DEFAULT=8,
    
}ANCHORTYPE;


typedef enum
{
    GTYPE_USERDEFINED,
    GTYPE_DEFAULT,
    GTYPE_RADIAL,
    GTYPE_HLINEAR,
    GTYPE_VLINEAR,
    GTYPE_ALINEAR //AT SOME ANGLE BUT ITS LINEAR
    
}GRADIENTTYPE;


typedef enum
{
    ALIGNMENT_CENTER,
    ALIGNMENT_LEFT,
    ALIGNMENT_RIGHT,
    ALIGNMENT_TOP,
    ALIGNMENT_BOTTOM,
    
}ALIGNMENT;

typedef enum
{
    DIRECTION_LEFT,
    DIRECTION_RIGHT,
    DIRECTION_TOP,
    DIRECTION_BOTTOM,
    
}DIRECTION;




typedef enum
{
    mPIE_DETAIL_POPUP_TYPE1=1,
    mPIE_DETAIL_POPUP_TYPE2,
    mPIE_DETAIL_POPUP_TYPE3,
    mPIE_DETAIL_POPUP_TYPE4,
    mPIE_DETAIL_POPUP_TYPE5,
    mPIE_DETAIL_POPUP_USERDEFINED,
    
}PIE_DETAIL_POPUP_TYPE;


typedef enum
{
    POPUP_ARROW_WHITE=1,
    POPUP_ARROW_BLACK,
    
}POPUP_ARROW_TINT_STYLE;


typedef enum
{
    INFOBOX_STYLE1=1, // Default one without interaction
    INFOBOX_STYLE2,//Rotation of pie and translation of info box up and down
    INFOBOX_STYLE3,//Selected Pie becomes bigger and related label in info box flashes and highlights
    
}INFOBOX_STYLE;


typedef enum
{
    mPIE_BUBBLE_STYLE1=1,//Square
    mPIE_BUBBLE_STYLE2,//Circle
    mPIE_BUBBLE_STYLE3,//Square translates from Pie
    mPIE_BUBBLE_STYLE4,//Circle translates from Pie
    mPIE_BUBBLE_STYLE5,//Square fades In
    mPIE_BUBBLE_STYLE6,//Circle fades In
    mPIE_BUBBLE_STYLE7,//Show all by default.//User can hide them - fade them out
                       //Later we can add more effects in disappearing/appearing
    
}PIE_BUBBLE_STYLE;



typedef enum
{
    X_TITLES_STYLE1=1, 
    X_TITLES_STYLE2,
    X_TITLES_STYLE3,
    X_TITLES_STYLE4,
}X_TITLES_STYLE;


typedef enum
{
    WALL_PATTERN_STYLE1=1, 
    WALL_PATTERN_STYLE2,
    WALL_PATTERN_STYLE3,
    WALL_PATTERN_STYLE4,
    WALL_PATTERN_STYLE5,
    WALL_PATTERN_STYLE_NONE,
}WALL_PATTERN_STYLE;


typedef enum
{
    VERTICAL_GRADIENT_STYLE=1, //UP
    VERTICAL_GRADIENT_STYLE_2, //DOWN
    HORIZONTAL_GRADIENT_STYLE,//LEFT
    HORIZONTAL_GRADIENT_STYLE_2,//RIGHT
    
}GRADIENT_STYLE;


typedef enum
{
    GLOSS_STYLE_1=1, 
    GLOSS_STYLE_2,
    GLOSS_STYLE_3,
    GLOSS_STYLE_4,
    GLOSS_STYLE_5,
    GLOSS_NONE,
    
}GLOSS_STYLE;



typedef enum
{
    BAR_ANIMATION_VGROW_STYLE=1, 
    
}BAR_ANIMATION_STYLE;

typedef enum
{
    BAR_LABEL_STYLE1=1, 
    BAR_LABEL_STYLE2,
    
}BAR_LABEL_STYLE;



#define LINESCROLLVIEWTAG 1000
#define XBANDTAG 1001
#define YBANDTAG 1002

#define SORTFIELD_Class @"ClassName"
#define SORTFIELD_NumberOfAFES @"AFECount"
#define SORTFIELD_AFEEstimate @"Budget"
#define SORTFIELD_Accrual @"Accrual"
#define SORTFIELD_Actual @"Actual"
#define SORTFIELD_Total @"ActualPlusAccrual"
#define SORTFIELD_AFEName @"Name"
#define SORTFIELD_PercentageConsumption @"Consumption"
#define SORTFIELD_BillingCategoryCode @"Code"
#define SORTFIELD_BillingCategoryName @"Name"
#define SORTFIELD_NumberOfInvoices @"InvoiceCount"
#define SORTFIELD_VendorName @"VendorName"
#define SORTFIELD_InvoiceDate @"InvoiceDate"
#define SORTFIELD_ServiceDate @"ServiceDate"
#define SORTFIELD_GrossExpense @"GrossExpense"
#define SORTFIELD_InvoiceNumber @"InvoiceNumber"
#define SORTFIELD_PropertyName @"PropertyName"
#define SORTFIELD_PropertyType @"PropertyType"
#define SORTFIELD_AccountingDate @"AccountingDate"
#define SORTFIELD_AFEStartDate @"AFEBeginDate"
#define SORTFIELD_AFEStatus @"Status"
#define SORTFIELD_AFEInvoiceAmount @"InvoiceAmount"

#ifndef SQLBI_AFE_AFEConstants_h
#define SQLBI_AFE_AFEConstants_h

#define CLASS_ORGANIZATION_SUMMARY @"OrganizationSummaryViewController"
#define CLASS_WELL_SEARCH @"WellSearchViewController"
#define CLASS_AFE_SEARCH @"AFESearchViewController"


#define TAB_TITLE_ORGANIZATION_SUMMARY @"Organization Summary"
#define TAB_TITLE_WELL_SEARCH  @"Well Search"
#define TAB_TITLE_AFE_SEARCH  @"AFE Search"

#define NSUserDefaultsKeyCurrentSelectedDashboardStartDate @"currentDashboardStartDate"
#define NSUserDefaultsKeyCurrentSelectedDashboardEndDate @"currentDashboardEndDate"
#define NSUserDefaultsKeyOrganisationSearchCurrentOrgTypeSelected @"currentOrgTypeSelected"
#define NSUserDefaultsKeyOrganisationSearchCurrentOrgIDSelected @"currentOrgIDSelected"
#define NSUserDefaultsKeyOrganisationSearchCurrentStatusSelected @"currentOrgStatusSelected"
#define NSUserDefaultsKeyOrganisationSearchCurrentStartDateSelected @"currentOrgStartDateSelected"
#define NSUserDefaultsKeyOrganisationSearchCurrentEndDateSelected @"currentOrgEndDateSelected"
#define NSUserDefaultsKeyOrganisationSearchCurrentOrgNameSelected @"currentOrgNameSelected"

//#define COMMON_FONTNAME_NORMAL @"AppleGothic"
//#define COMMON_FONTNAME_NORMAL_ITALIC @"AppleGothicItalic"
//#define COMMON_FONTNAME_BOLD @"AppleGothicBold"
//#define COMMON_FONTNAME_BOLD_ITALIC @"GOTHICBI_0"


#define COMMON_FONTNAME_NORMAL @"CenturyGothic"
#define COMMON_FONTNAME_NORMAL_ITALIC @"CenturyGothic-Italic"
#define COMMON_FONTNAME_BOLD @"CenturyGothic-Bold"
#define COMMON_FONTNAME_BOLD_ITALIC @"Century Gothic Bold Italics"



#define FONT_NAVIGATIONBAR_TITLE [UIFont fontWithName:COMMON_FONTNAME_BOLD size:19]
#define FONT_SUMMARY_HEADER_TITLE [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:18]
#define FONT_SUMMARY_DATE [UIFont fontWithName:COMMON_FONTNAME_BOLD size:12]
#define FONT_DETAIL_PAGE_TAB [UIFont fontWithName:COMMON_FONTNAME_BOLD size:14]
#define FONT_MAIN_TABBAR [UIFont fontWithName:COMMON_FONTNAME_BOLD size:11]
#define FONT_HEADLINE_METRICS_COLUMN_TITLE [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:13]
#define FONT_HEADLINE_METRICS_COLUMN_VALUE [UIFont fontWithName:COMMON_FONTNAME_BOLD size:20]
#define FONT_HEADLINE_METRICS_PERCENTAGE_VALUE [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:15]
#define FONT_BARGRAPH_TEXT [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:10]

#define FONT_SUMMARY_VIEW_BARCHART [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:10]
#define FONT_SUMMARY_BOLD_VIEW_BARCHART [UIFont fontWithName:COMMON_FONTNAME_BOLD size:10]
#define FONT_SUMMARY_DETAIL_VIEW_BARCHART [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:11]

#define FONT_TOP_AFE_SUMMARY_VIEW_LEGEND_BARCHART [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:10]

#define FONT_SEARCH_STATIC_LABEL_BOLD [UIFont fontWithName:COMMON_FONTNAME_BOLD size:18]
#define FONT_SEARCH_VALUE_LABEL [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:15]
#define FONT_SEARCH_VALUE_LABEL_BOLD [UIFont fontWithName:COMMON_FONTNAME_BOLD size:15]

#define FONT_DASHBOARD_BUTTON_DEFAULT_LABEL [UIFont fontWithName:COMMON_FONTNAME_BOLD size:11]
#define FONT_DASHBOARD_BUTTON_SELECTED_LABEL [UIFont fontWithName:COMMON_FONTNAME_BOLD size:12]
#define FONT_PIECHART_VALUE_LABEL [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:9]
#define FONT_PIECHART_SAMPLE_DATA_LABEL [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:9]
#define FONT_DASH [UIFont fontWithName:COMMON_FONTNAME_NORMAL size:18]

#define FONT_HEADLINE_TITLE [UIFont fontWithName:COMMON_FONTNAME_BOLD size:13]
#define FONT_HEADLINE_VALUE [UIFont fontWithName:COMMON_FONTNAME_BOLD size:18]
#define FONT_BOLD_HEADLINE_METRICS_PERCENTAGE_VALUE [UIFont fontWithName:COMMON_FONTNAME_BOLD size:15]

#define COLOR_NAVIGATIONBAR_TITLE [Utility getUIColorWithHexString:@"#ffffff"]
#define COLOR_MAIN_TABBAR_SLECTED [Utility getUIColorWithHexString:@"#1d2f58"]
#define COLOR_MAIN_TABBAR_UNSLECTED [Utility getUIColorWithHexString:@"#192131"]
#define COLOR_SUMMARY_HEADER_TITLE [Utility getUIColorWithHexString:@"#ffffff"]
#define COLOR_HEADLINE_METRICS_COLUMN_TITLE [Utility getUIColorWithHexString:@"#647182"]
#define COLOR_HEADLINE_METRICS_COLUMN_VALUE [Utility getUIColorWithHexString:@"#1b2128"]
#define COLOR_RED [Utility getUIColorWithHexString:@"#ff0000"]
#define COLOR_GREEN [Utility getUIColorWithHexString:@"#2ac500"]
#define COLOR_BARGRAPH_TEXT [Utility getUIColorWithHexString:@"#1b2b40"]
#define COLOR_FONT_DASHBOARD_BUTTON_DEFAULT_LABEL [Utility getUIColorWithHexString:@"#ffffff"]
#define COLOR_DASHBOARD_BUTTON_SELECTED_LABEL [Utility getUIColorWithHexString:@"#192835"]

#define COLOR_PIECHART_VALUE_LABEL [Utility getUIColorWithHexString:@"#ffffff"]
#define COLOR_PIECHART_SAMPLE_DATA_LABEL [Utility getUIColorWithHexString:@"#1b2b40"]

#define FONT_TABLEVIEWCELL [UIFont fontWithName:COMMON_FONTNAME_BOLD size:15]
#define FONT_TABLEVIEWCELL_HEADER [UIFont fontWithName:COMMON_FONTNAME_BOLD size:15]

#define COLOR_DASHBORD_DATE [Utility getUIColorWithHexString:@"#a1e2ff"]
#define COLOR_HEADER_TITLE [Utility getUIColorWithHexString:@"#ffffff"]


typedef enum
{
    AFEViewControllerViewTypeSummary,
    AFEViewControllerViewTypeDetailed
    
}AFEViewControllerViewType;

typedef enum
{
    AFEOrganizationSummaryPageTypeHeadlineMetrics,
    AFEOrganizationSummaryPageTypeTopAFEClasses,
    AFEOrganizationSummaryPageTypeTopBudgetedAFE,
    AFEOrganizationSummaryPageTypeProjectWatchlist
    
}AFEOrganizationSummaryPageType;

typedef enum{
    TreeGraphDrawTypeFieldEstimate,
    TreeGraphDrawTypeFieldActuals
    
}
TreeGraphDrawType;

typedef enum{
    AFEAnimationDirectionLeft,
    AFEAnimationDirectionRight
    
}
AFEAnimationDirection;

typedef enum{
    AFESortDirectionAscending,
    AFESortDirectionDescending
    
}
AFESortDirection;


#endif
