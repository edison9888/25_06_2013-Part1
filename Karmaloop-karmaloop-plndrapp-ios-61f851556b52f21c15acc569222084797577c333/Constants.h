// Testing
#define kUseStaginUrls              0       // 1 (YES) to switch to staging URLs. 0 (NO) for production. USE THE BINARY. We need it for a preprocessor flag.
#define kUseDebugGAN                NO      // YES for our local GAN account. No for production.
#define kTestPurchase               NO      // YES for testing purchase, NO for production. If this flag is set to YES, credit cards will be charged and then immediately refunded during purchase. If it's set to no, you will be charged.
//Test cards (if you use a real credit card, while kTestPurchase is YES, the amount will be charged to your credit card, then removed. Probably you want to use these test cards instead)
//378282246310005 Amex
//371449635398431 Amex
//378734493671000 Amex
//5610591081018250 Amex
//30569309025904 Amex
//38520000023237 Amex
//6011111111111117 Discover
//6011000990139424 Discover
//3530111333300000 Jcb
//3566002020360505 Jcb
//5555555555554444 Mastercard
//5105105105105100 Mastercard
//4111111111111111 Visa
//4012888888881881 Visa
//4222222222222 Visa
//4457010000000009 Visa

// Static URLs
#define kPlndrSizeAndFitUrl         @"http://www.plndr.com/size/m-landing.htm"
#define kPlndrOrdersFAQURL          @"http://www.plndr.com/help/Orders-FAQ.htm"
#define kPlndrPaymentFAQURL         @"http://www.plndr.com/help/Payment-FAQ.htm"
#define kPlndrReturnsFAQURL         @"http://www.plndr.com/help/Returns-FAQ.htm"
#define kPlndrPromotionAndGiftURL   @"http://www.plndr.com/help/Promotion-FAQ.htm"

// Twitter endpoint contants
#define kTwitterAuthURL             @"https://api.twitter.com/oauth/"
#define kTwitterStatusURL           @"https://api.twitter.com/1/statuses/"
#define kTwitterBaseURL				@"http://api.twitter.com/1"
#define kTwitterSearchURL			@"http://search.twitter.com/search.json"

// Misc
#define kAppName                    @"PLNDR"
#define	kLastConnectionTimeKey      @"lastConnectionTime"
#define kDeviceWidth                320
#define kDeviceHeight               460
#define kStatusBarHeight            20
#define kNavBarFrame                CGRectMake(0,0,320,44)
#define kHomeNavBarFrame            CGRectMake(0,0,320,49)
#define kHomeTabIndex               0
#define kMyCartTabIndex             1
#define kInviteFriendsTabIndex      2
#define kSettingsTabIndex           3
#define kFontTimer                 [UIFont fontWithName:@"HelveticaNeue-MediumCond" size:14.0f]
#define kCacheTimeSalesAndProducts  10*60 // 10 mins
#define kCacheTimeSavedAddress      30*60 // 30 mins

#define kSecondsInMinute            60
#define kSecondsInHour              3600
#define kSecondsInDay               86400
#define kMagicButtonHeight          44

// Attributed String Keys
#define kAttributedStringFont                   @"kAttributedStringFont"
#define kAttributedStringColor                  @"kAttributedStringColor"
#define kAttributedStringSuppressBottomPadding  @"kAttributedStringSuppressBottomPadding"

// Colors
#define kPlndrBlack                     [UIColor colorWithWhite:26.0f/255.0f alpha:1.0f]
#define kPlndrWhite                     [UIColor colorWithWhite:241.0f/255.0f alpha:1.0f]
#define kPlndrLightGreyTextColor        [UIColor colorWithWhite:150.0f/255.0f alpha:1.0f]
#define kPlndrMediumGreyTextColor       [UIColor colorWithWhite:102.0f/255.0f alpha:1.0f]
#define kPlndrDarkGreyTextColor         [UIColor colorWithWhite:52.0f/255.0f alpha:1.0f]
#define kPlndrTextGold                  [UIColor colorWithRed:213.0f/255.0f green:179.0f/255.0f blue:39.0f/255.0f alpha:1.0f]
#define kPlndrTextRed                   [UIColor colorWithRed:192.0f/255.0f green:39.0f/255.0f blue:45.0f/255.0f alpha:1.0f]
#define kPlndrBgGrey                    [UIColor colorWithWhite:229.0f/255.0f alpha:1.0f]
#define kPlndrDarkBgGrey                [UIColor colorWithWhite:77.0f/255.0f alpha:1.0f]
#define kListHighlightColor             [UIColor colorWithRed:233.0f/255.0f green:216.0f/255.0f blue:150.0f/255.0f alpha:1.0f]
#define kTileHighlightColor             [UIColor colorWithWhite:1.0f alpha:0.2f]
#define kHomeTileThumbnailOverlayColor  [UIColor colorWithWhite:0.1f alpha:0.75f]
#define kHomeTileThumbnailOpaqueOverlayColor  [UIColor colorWithWhite:77.0f/255.0f alpha:1.0f]
#define kFilterCellSeparatorColor       [UIColor colorWithWhite:161.0f/255.0f alpha:1.0f]
#define kPlndrDataCellErrorColor        [UIColor colorWithRed:246.0f/255.0f green:210.0f/255.0f blue:205.0f/255.0f alpha:1.0f]
#define kPlndrTransparencyColor         [UIColor colorWithWhite:0.0f alpha:0.75f]
#define kPurchaseSummarySeparatorGrey   [UIColor colorWithWhite:184.0f/255.0f alpha:1.0f]
#define kFlipBackgroundColor            [UIColor colorWithRed:193.0f/255.0f green:149.0f/255.0f blue:73.0f/255.0f alpha:1.0f]

//Font
#define kFontBold12                     [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]
#define kFontBold13                     [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f]
#define kFontBold14                     [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]
#define kFontBold15                     [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]
#define kFontBold16                     [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f]
#define kFontBold17                     [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]
#define kFontBold22                     [UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0f]

#define kFontBoldCond14                 [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:14.0f]
#define kFontBoldCond15                 [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:15.0f]
#define kFontBoldCond16                 [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:16.0f]
#define kFontBoldCond17                 [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:17.0f]
#define kFontBoldCond20                 [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:20.0f]

#define kFontMedium11                   [UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0f]
#define kFontMedium12                   [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0f]
#define kFontMedium13                   [UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0f]
#define kFontMedium14                   [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]
#define kFontMedium15                   [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]
#define kFontMedium17                   [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f]

#define kFontMediumCond14               [UIFont fontWithName:@"HelveticaNeue-MediumCond" size:14.0f]
#define kFontMediumCond17               [UIFont fontWithName:@"HelveticaNeue-MediumCond" size:17.0f]

#define kFontRoman12                    [UIFont fontWithName:@"HelveticaNeue-Roman" size:12.0f]
#define kFontRoman16                    [UIFont fontWithName:@"HelveticaNeue-Roman" size:16.0f]
#define kFontRoman22                    [UIFont fontWithName:@"HelveticaNeue-Roman" size:22.0f]

#define kFontUnivers16                  [UIFont fontWithName:@"Univers-Bold" size:16.0f]

#define kBarButtonItemFont              [UIFont fontWithName:@"HelveticaNeue-Medium" size:12]
#define kErrorFontForReplaceingTables   [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:14.0f]   

#define kFontHomeViewTimer              [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]

// Home Screen
#define kHomeLongTileCellHeight     164
#define kHomeLongTileImageHeight    160
#define kHomeLongTileImageWidth     310

#define kHomeShortTileCellHeight    96
#define kHomeShortTileImageWidth    154
#define kHomeShortTileImageHeight   92

#define kHomeScrollWheelWidth       175
#define kHomeScrollWheelHeight      37
#define kHomeScreenNavBarMargin                     10
#define kHomeScreenThumbnailOverlayHeight           27
#define kHomeScreenClockHeight                      40
#define kHomeScreenThumbnailOverlayInnerMargin      7

#define kHomeScreenListCellWidth        320
#define kHomeScreenListCellHeight       62
#define kHomeScreenListMargin           10
#define kHomeScreenListIconWidth        100
#define kHomeScreenListIconHeight       60
#define kTimerRedThresholdInHours       24

#define kTimerRotationInRadians         1.65f
#define kTimerAnimationDuration         0.4f
#define k90DegreesInRadians             1.57f
// Sale Screen
#define kSaleScreenTableWidth                   320
#define kSaleScreenThumbnailsPerRow             3
#define kSaleScreenThumbnailMargin              6
#define kSaleScreenThumbnailHeight              150
#define kSaleScreenThumbnailWidth               98
#define kSaleScreenThumbnailOverlayHeight       30     
#define kSaleScreenThumbnailOverlayHorizontalMargin  3
#define kSaleScreenThumbnailOverlayVerticalMargin    1
#define kSaleScreenThumbnailOriginalPriceFont       [UIFont systemFontOfSize:10]
#define kSaleScreenFilterTableHeight                286 // 6.5 * kSaleScreenFilterTableRowHeight
#define kSaleScreenHeaderTopMargin                  5
#define kSaleScreenFilterTableRowHeight             44
#define kProductPageSize                            99
#define kSaleLoadingFooterHeight                    50.0f
#define kSaleLoadingFooterTitle                     @"LOADING MORE PRODUCTS"
#define kSaleFilterCellSaparatorHeight               0.5f
#define kSaleFilterCellSeparatorPadding             5.0f
#define kSaleFilterCellWidth                        180.0f
#define kSaleFilterCellSeparatorWidth               170.0f
// Filter Screen
#define kFilterScreenMargin                        10

// Product Screen
#define kLabelHeight                        22
#define kProductDetailsContainerWidth       308
#define kProductDetailsContainerHeight      347
#define kProductDetailsContainerMargin      6
#define kProductContainerInternalHorizontalMargin 6
#define kProductSecondaryDetailsHorizontalMargin  12
#define kProductSecondaryDetailsVerticalMargin    8
#define kProductDetailImageWidth                  180
#define kProductDetailImageHeight                 275
#define kProductDetailSizeTableWidth              108
#define kProductDetailSizeTableCellHeight         44
#define kProductDetailSizeTableCellLabelMargin    25

#define kProductAddToCartTitle                  @"ITEM ADDED"
#define kProductAddToCartMessage                @"\"%@\" in %@ has been added to your cart!"
#define kProductAddToCart                       @"ADD TO CART"
#define kProductAddToCartButton1                @"VIEW CART"
#define kProductAddToCartButton2                @"CONTINUE SHOPPING"
#define kProductPickASize                       @"PICK A SIZE"
#define kProductSizeXXX                         @"SIZE %@"
#define kProductSoldOutLabel                    @"SOLD OUT"
#define kProductNoSizesAvailable                @"No sizes available"

// My Cart
#define kMyCartSectionHeaderHeight              30
#define kMyCartTableCellHeight                  99
#define kMyCartTableCellImageWidth              58
#define kMyCartTableCellImageHeight             89
#define kMyCartTableCellInternalMargin          10
#define kMyCartTableCellImageMargin             6
#define kMyCartSectionErrorHeaderHeight         40
#define kMyCartTableCellErrorFooterHeight       20

// Login Screen
#define kLoginHeaderHeight                      38
#define kLoginNotAMemberMessage                 @"NOT A MEMBER? APPLY NOW!"
#define kLoginForgotPasswordMessage             @"Forgot Password?"
#define kLoginSignIn                            @"SIGN IN"


// Checkout Screen
#define kCheckoutStepButtonHeight               35
#define kSummaryHorizontalMargin                5
#define kSummaryHorizontalLabelMargin           12
#define kSummaryVerticalMargin                  8
#define kSummaryItemFont                        [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]
#define kSummaryItemSizeConstraint              CGSizeMake(300,25)
#define kSummaryBackgroundImageCap              7

#define kSummaryHorizontalCellHeight            95
#define kSummaryHorizontalCellWidth             65

#define kSummaryTableMaxLeftLabelMaxSpace       200

// Purchase Options
#define kPOTableEmptyHeaderHeight               10
#define kPOTableHeaderHeight                    46
#define kPOTableCellHeight                      45

// Popup
#define kPopupHorizontalMargin                  10
#define kPopupVerticalMargin                    5
#define kPopupWidth                             280
#define kPopupOneButtonHeight                   185
#define kPopupTwoButtonHeight                   225
#define kPopupImageHorizontalCap                9
#define kPopupImageVerticalCap                  8

// Tags
#define kGenderCategoryMenPrefix                  1000
#define kGenderCategoryWomenPrefix                2000
#define kGenderCategoryAllPrefix                  3000
#define kBaseDataCellInvalidIndexTag              99999999

// HTTP Status Codes
#define kHTTP_200_OK                            200
#define kHTTP_400                               400
#define kHTTP_401_ERROR_AuthTokn                401
#define kHTTP_ERROR_NoConnection              -1009
// Strings
#define kRequired               @"Required"
#define kOptional               @"Optional"
#define kPasswordRequest        @"PASSWORD REQUEST"

// DataCells
#define kTitleAndTextPadding                    10

#define kMultiLineHorizontalCellMargin          12
#define kMultiLinePreviewVerticleCellMargin     12
#define kMultiLinePreviewLabelLineMargin        0
#define kMultiLinePreviewMaxLabelWidth          242
#define kMultiLinePreviewTitleAndDetailSpacer   8

#define kMultiLineItemizedHorizontalCellMargin  18
#define kMultiLineItemizedVerticleCellMargin    12
#define kMultiLineItemizedItemLineMargin        5
#define kMultiLineItemizedMaxLineWidth          284
#define kMultiLineItemizedItemSpacer            20

// TableView
#define kButtonFooterHeight               80

// MySettingsView
#define kPlndrCustomerSupportPhoneNumber                        @"1866WEPLNDR" // 1 866 937 5637 or 1.866.WE.PLNDR
#define kPlndrCustomerSupportCallErrorText                      @"Calling is not supported on this device.\nPlease call:\n%@ (%@)"
#define kPlndrCustomerSupportPrettyPhoneText                    @"1 866 WE PLNDR"
#define kPlndrCustomerSupportPrettyPhoneNumber                  @"1 866 937 5637"
#define kPlndrCustomerSupportEmail                              @"questions@plndr.com"
#define kMySettingsAccountHeaderVerticalPadding                 5

// TabBar
#define kTabBarHeight               44
#define kTabBarMyCartBadgeOrigin    CGPointMake(115,5)

// Purchase Confirmation
#define kPurchaseConfirmationHeaderHeight       65
#define kPurchaseConfirmationHeaderMargin       15

//Social Manager

#define kFacebookAppID                              @"239667536054428"
#define kFACEBOOK_ACCESS_TOKEN                      @"FBAccessTokenKey"
#define kFACEBOOK_EXPIRATION_DATE                   @"FBExpirationDateKey"
#define kInviteUrl                                  @"http://www.plndr.com/plndr/MembersOnly/Login.aspx?r="
#define kShortInviteMessage                         @"Don’t sleep! Shop @PLNDR & save up to 90%. Here’s your exclusive invite:"
#define kCaptionInviteMessage                       @"PLNDR: Clothing, Accessories, Plunder!"
#define kLongInviteMessage                          @"PLNDR.com is a members only boutique of only the best in sneakers, street apparel and other cutting edge brands, offered to you through exclusive limited timed (48 hour) sales. All merchandise is marked down up to 80% off for our members."
#define kSocialManagerEmailNotConfiguredMessage     @"This device has not been configured for email. Please configure the device and try again."
#define kSocialManagerSMSNotConfiguredMessage       @"This device has not been configured for SMS. Please configure the device and try again."
#define kSocialManagerTwitterSuccessfulTweet        @"The Tweet was posted successfully."
#define kSocialManagerTwitterFailedTweet            @"You Cancelled posting the Tweet."
#define kFacebookImageUrl                           @"http://assets.karmaloop.com/plndr/img/plndr-logo.png"

// Invite Friends
#define kInviteFriendsTitle                     @"SHOP FOR FREE?"
#define kInviteFriendsSubtitle                  @"Invite Friends and Earn Unlimited $10 Credits *"
#define kInviteFriendsEmailTitle                @"Invite with Email"
#define kInviteFriendsFacebookTitle             @"Invite with Facebook"
#define kInviteFriendsTwitterTitle              @"Invite with Twitter"
#define kInviteFriendsSMSTitle                  @"Invite with SMS"

// Share Product/Sale
#define kShareProuctText @"Check out %@ on PLNDR for %d%% off! %@" // Item Name, Discount Percentage, Url
#define kShareSaleText @"Check out %@ on PLNDR! %@" // BrandName Url

// Timer Related
#define kTimerShadowHeight      1.0f


// Base Modal
#define kModalErrorMessage                      @"Please verify the highlighted fields below."
#define kFontHeaderErrorMessage                 [UIFont fontWithName:@"HelveticaNeue-BoldCond" size:14.0f]
#define kErrorHeaderHeight                      38
#define kErrorHeaderMargin                      10

// Discounts
#define kAppliedDiscountRepCode                @"RepCode"
#define kAppliedDiscountPromoCode              @"PromoCode"
#define kAppliedDiscountGiftCode               @"GiftCode"

//Change Password
#define kChangePasswordSuccessTitle             @"CHANGE PASSWORD SUCCESS"
#define kChangePasswordSuccessMessage           @"Your Password has been changed successfully."


// Error Message
#define kBasicErrorMessage              @"Sorry there was an error. Please try again."
#define kBasicFatalErrorTitle           @"Whoops!"
#define kBasicFatalErrrorMessage        @"Something has gone wrong. Please try again in a bit.\nIf the problem persists please email questions@plndr.com."
#define kMyCartGreyHeaderErrorMessage   @"Please review the errors below."
#define kMyCartInsufficientStockMessage @"Only %d of this item is available."
#define kMyCartSoldOutMessage           @"This item is sold out."
#define kHomeNoSalesError               @"Whoops! We couldn't get any sales. Please refresh or try again later."
#define kSaleNoProductsError            @"Whoops! There are no products here. Check out other filters or sales for dope deals!"
#define kProfileAddressUnavailable      @"Whoops! We're having trouble retrieving your addresses. Please try again later."
#define kAddressDefaultShippingError    @"Please select a default shipping address."
#define kAddressDefaultBillingError     @"Please select a default billing address."
#define kAddressPurchaseShippingError   @"Please select a shipping address."
#define kAddressPurchaseBillingError    @"Please select a billing address."
#define kAddressErrorTitle        @"ADDRESS ERROR"
#define kAddressCreateErrorTitle        @"CREATE ADDRESS ERROR"
#define kAddressCreateErrorMessage      @"Whoops! We couldn't create this address. Please try again later." // TODO use the error in the API
#define kAddressUpdateErrorTitle        @"UPDATE ADDRESS ERROR"
#define kAddressUpdateErrorMessage      @"Whoops! We couldn't update this address. Please try again later." // TODO use the error in the API
#define kAddressDeleteErrorTitle        @"DELETE ADDRESS ERROR"
#define kAddressDeleteErrorMessage      @"Whoops! We couldn't delete this address. Please try again later." // TODO use the error in the API
#define kSaleEndErrorMessage            @"The \"%@\" sale has ended. Check out other dope sales on PLNDR!"
#define kSaleEndTitle                   @"SALE HAS ENDED"
#define kStepTwoErrorHeader             @"Please correct your order and try again."
#define kShippingOptionsEmptyMessage    @"Unable to retrieve options. Please correct your order and try again."
#define kSaleEndButtonTitle             @"HOME"
#define kPasswordRequestPopupConnectionErrorMessage         @"Whoops! Please check your connection."

#define kChangePasswordErrorTitle       @"CHANGE PASSWORD ERROR"
#define kPurchaseErrorTitle             @"PURCHASE ERROR"
#define kCreditCardErrorTitle           @"CREDIT CARD ERROR"
#define kDiscountErrorTitle             @"DISCOUNT ERROR"
#define kInviteErrorTitle               @"INVITE ERROR"
#define kLoginErrorTitle                @"LOGIN ERROR"
#define kProductErrorTitle              @"PRODUCT ERROR"
#define kShippingOptionsErrorTitle      @"SHIPPING OPTIONS ERROR"
#define kSignUpErrorTitle               @"SIGN UP ERROR"
#define kCheckoutErrorTitle             @"CHECKOUT ERROR"
#define kCartErrorTitle                 @"CART ERROR"
#define kCheckoutErrorButtonGoThere     @"GO THERE!"
#define kAuthErrorMessage               @"Your session has expired, please login again."
#define kSkuInconsistencyError          @"This item is no longer available."
#define kErrorTitleError                @"ERROR"

// Google Analytics General Constants
#define kGANTrackingID @"UA-2308403-26"
#define kGANTrackingTestID @"UA-32916460-1"
#define kGANDispatchPeriodSec 10

// Google Analytics Events/Actions/Labels
#define kGANEventAppGeneral @"app_general"
#define kGANActionAppStartup  @"start_application"
#define kGANLabelAppStartup @"Application Startup"
#define kGANActionLeaveApp @"leave_application"
#define kGANLabelLeaveApp @"Time on App"

#define kGANEventInvite @"invite_friend"
#define kGANActionInviteEmail @"invite_via_email"
#define kGANActionInviteTwitter @"invite_via_twitter"
#define kGANActionInviteFacebook @"invite_via_facebook"
#define kGANActionInviteSMS @"invite_via_sms"

#define kGANEventCheckout @"checkout"
#define kGANActionAddToCart @"add_to_cart"
#define kGANActionCheckoutStart @"start_checkout"
#define kGANActionCheckoutComplete @"complete_checkout"


// Google Analytics Pages
#define kGANAppStart @"/app_start"
#define kGANPageHome @"/home"
#define kGANPageMyCart @"/my_cart"
#define kGANPageInvite @"/invite"
#define kGANPageSettings @"/settings"
#define kGANPageLogin @"/login"
#define kGANPageCreditCard @"/credit_card"
#define kGANPageEditAddress @"/edit_address"
#define kGANPageShippingOptions @"/shipping_options"
#define kGANPageSignup @"/signup"
#define kGANPageChangePassword @"/change_password"
#define kGANPageCheckout @"/checkout"
#define kGANPageCheckoutStep1 @"/checkout_step1"
#define kGANPageCheckoutStep2 @"/checkout_step2"
#define kGANPageDiscounts @"/discounts"
#define kGANPageManageAddress @"/manage_address"
#define kGANPageProfile @"/profile"
#define kGANPagePurchaseReceipt @"/purchase_receipt"

// Notifications 
#define kNotificationDidAppear   @"NotificationViewDidAppear"

//Connection Error Modal
#define kConnectionErrorNoConnectionMessage                 @"No Network Connection"
#define kConnectionErrorAssistanceMessage                   @"Check your internet connection and try again."
#define kConnectionErrorVerticalPadding                     20
