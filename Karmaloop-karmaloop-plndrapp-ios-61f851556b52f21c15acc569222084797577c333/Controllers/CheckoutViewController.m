//
//  CheckoutViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-05-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckoutViewController.h"
#import "Constants.h"
#import "StepOneViewController.h"
#import "StepTwoViewController.h"
#import "Utility.h"
#import "PurchaseReceiptViewController.h"
#import "ModelContext.h"
#import "PlndrPurchaseSession.h"
#import "GANTracker.h"
#import "CartItem.h"
#import "Product.h"
#import "CheckoutCompleteResponse.h"
#import "CheckoutSummary.h"
#import "PopupUtil.h"
#import "PlndrAppDelegate.h"
#import "NavigationControlManager.h"

@interface CheckoutViewController ()
- (void) updateNavBar;
- (void) stepClicked:(id)sender;
- (void) rightButtonPressed:(id)sender;
- (void) leftButtonPressed:(id)sender;
- (void) updateStepButtonStates;
- (void) createCheckoutCompleteSubscription;
- (void) handleCheckoutCompleteSubscriptionError;
- (void) pushCheckoutCompleteResponse;
- (void) proceedToStepTwo;
- (void)displayLastCheckoutError;

@end

@implementation CheckoutViewController

@synthesize stepOneButton = _leftTopButton;
@synthesize stepTwoButton = _rightTopButton;
@synthesize stepContainerView = _stepContainerView;
@synthesize stepOneController = _stepOneController;
@synthesize stepTwoController = _stepTwoController;
@synthesize checkoutCompleteSubscription = _checkoutCompleteSubscription;
@synthesize checkoutErrorPopup = _checkoutErrorPopup;
@synthesize lastDisplayedCheckoutPopup = _lastDisplayedCheckoutPopup;

- (id)init {
    self = [super init];
    if(self) {
        self.title = @"CHECKOUT";
    }
    return self;
}

- (void)dealloc {
    self.stepTwoController.checkoutDelegate = nil;
    [self.checkoutCompleteSubscription cancel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.stepOneButton = nil;
    self.stepTwoButton = nil;
    
    self.stepContainerView = nil;
    self.stepOneController = nil;
    self.stepTwoController.checkoutDelegate = nil;
    self.stepTwoController = nil;
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
    
    [self.view setBackgroundColor:kPlndrBgGrey];
    
    UIImage *leftTopImage = [UIImage imageNamed:@"toggle_left.png"];
    self.stepOneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.stepOneButton setFrame:CGRectMake(0, 0, leftTopImage.size.width, leftTopImage.size.height)];
    [self.stepOneButton setBackgroundImage:leftTopImage forState:UIControlStateNormal];
    [self.stepOneButton setBackgroundImage:[UIImage imageNamed:@"toggle_left_hl.png"] forState:UIControlStateSelected];
    [self.stepOneButton setBackgroundImage:[UIImage imageNamed:@"toggle_left_hl.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.stepOneButton setTitle:@"STEP 1" forState:UIControlStateNormal];
    [self.stepOneButton setTitleColor:kPlndrTextGold forState:UIControlStateNormal];
    [self.stepOneButton setTitleColor:kPlndrBlack forState:UIControlStateSelected];
    [self.stepOneButton setTitleColor:kPlndrBlack forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.stepOneButton.titleLabel setFont:kFontBoldCond15];
    self.stepOneButton.adjustsImageWhenHighlighted = NO;
    [self.stepOneButton addTarget:self action:@selector(stepClicked:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:self.stepOneButton];
    
    UIImage *rightTopImage = [UIImage imageNamed:@"toggle_right.png"];
    self.stepTwoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.stepTwoButton setFrame:CGRectMake(self.stepOneButton.frame.origin.x + self.stepOneButton.frame.size.width - 13, self.stepOneButton.frame.origin.y, rightTopImage.size.width, rightTopImage.size.height)];
    [self.stepTwoButton setBackgroundImage:rightTopImage forState:UIControlStateNormal];
    [self.stepTwoButton setBackgroundImage:[UIImage imageNamed:@"toggle_right_hl.png"] forState:UIControlStateSelected];
    [self.stepTwoButton setBackgroundImage:[UIImage imageNamed:@"toggle_right_hl.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.stepTwoButton setTitle:@"STEP 2" forState:UIControlStateNormal];
    [self.stepTwoButton setTitleColor:kPlndrTextGold forState:UIControlStateNormal];
    [self.stepTwoButton setTitleColor:kPlndrBlack forState:UIControlStateSelected];
    [self.stepTwoButton setTitleColor:kPlndrBlack forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.stepTwoButton setTitleColor:kPlndrMediumGreyTextColor forState:UIControlStateDisabled];
    [self.stepTwoButton.titleLabel setFont:kFontBoldCond15];
    self.stepTwoButton.adjustsImageWhenHighlighted = NO;
    self.stepTwoButton.adjustsImageWhenDisabled = NO;
    [self.stepTwoButton addTarget:self action:@selector(stepClicked:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:self.stepTwoButton];
    
    self.stepContainerView = [[UIView alloc] initWithFrame:CGRectMake(0,self.stepOneButton.frame.size.height , kDeviceWidth, kDeviceHeight - kNavBarFrame.size.height - self.stepOneButton.frame.size.height - kTabBarHeight)];
    [self.view addSubview:self.stepContainerView];
    
    self.stepOneController = [[StepOneViewController alloc] init];
    self.stepTwoController = [[StepTwoViewController alloc] init];
    self.stepTwoController.checkoutDelegate = self;
    
    float titleEdgeLeft = -0.15f;
    float imageEdgeRight = -0.85f;
    [self.stepOneButton setTitleEdgeInsets:UIEdgeInsetsMake(0, titleEdgeLeft*self.stepOneButton.frame.size.width, 0, 0)];
    [self.stepOneButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, imageEdgeRight*self.stepOneButton.frame.size.width)];
    [self.stepTwoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, titleEdgeLeft*self.stepTwoButton.frame.size.width, 0, 0)];
    [self.stepTwoButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, imageEdgeRight*self.stepTwoButton.frame.size.width)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[GANTracker sharedTracker] trackPageview:kGANPageCheckout withError:nil];
    
    [self stepClicked:self.stepOneButton];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateContainerView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) changeToStep:(CheckoutViewControllerSteps)step {
    UIViewController *currentViewController = nil;
    UIViewController *newViewController = nil;
    
    UIButton *currentSelectedButton = nil;
    UIButton *newSelectedButton = nil;
    
    if (step == CheckoutViewControllerStepOne){
        
        currentViewController = self.stepTwoController;
        currentSelectedButton = self.stepTwoButton;
        newViewController = self.stepOneController;
        newSelectedButton = self.stepOneButton;
    } else {
        currentViewController = self.stepOneController;
        currentSelectedButton = self.stepOneButton;
        newViewController = self.stepTwoController;
        newSelectedButton = self.stepTwoButton;
    }
    [currentViewController.view removeFromSuperview];
    [currentViewController removeFromParentViewController];
    
    [self addChildViewController:newViewController];
    [self.stepContainerView addSubview:newViewController.view];
    newViewController.view.frame = CGRectMake(0,0,self.stepContainerView.frame.size.width,self.stepContainerView.frame.size.height);
    
    newSelectedButton.selected = YES;
    currentSelectedButton.selected = NO;
    [self updateNavBar];
    
}
#pragma mark - private

- (void)updateNavBar {
    UIButton *rightButton;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (self.stepOneButton.selected) {
        rightButton = [PlndrBaseViewController createNavBarButtonWithText:@"NEXT" withNormalColor:kPlndrTextGold withHighlightColor:kPlndrBlack];
        [leftButton setTitle:@"MY CART" forState:UIControlStateNormal];
    } else {       
        rightButton = [PlndrBaseViewController createNavBarButtonWithText:@"BUY!" withNormalColor:kPlndrTextGold withHighlightColor:kPlndrBlack];
        [leftButton setTitle:@"STEP 1" forState:UIControlStateNormal];
    }
    [rightButton setTitleColor:kPlndrMediumGreyTextColor forState:UIControlStateDisabled];
    
    [rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.titleLabel.font = kBarButtonItemFont;
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"back_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 3)];
    UIImage *backButtonHLImage = [[UIImage imageNamed:@"back_btn_hl.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 3)];
    [leftButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [leftButton setBackgroundImage:backButtonHLImage forState:UIControlStateHighlighted];
    [leftButton setTitleColor:kPlndrWhite forState:UIControlStateNormal];
    [leftButton setTitleColor:kPlndrBlack forState:UIControlStateHighlighted];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [leftButton sizeToFit];
    leftButton.frame = CGRectMake(0, 0, leftButton.frame.size.width + 14, leftButton.frame.size.height);
    [leftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

}

- (void)stepClicked:(id)sender {
    if (sender == self.stepOneButton) {
        [self changeToStep:CheckoutViewControllerStepOne];
    } else {
        [self changeToStep:CheckoutViewControllerStepTwo];
    }
}



- (void)rightButtonPressed:(id)sender {
    if (self.stepOneButton.selected) {
        [self proceedToStepTwo];
    } else {
        [self doPurchase];        
    }

}

- (void)leftButtonPressed:(id)sender {
    if (self.stepOneButton.selected) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self stepClicked:self.stepOneButton];
    }
}

- (void)updateStepButtonStates {
    UIImage *checkMarkImage =[UIImage imageNamed:@"check_icn.png"];
    UIImage *checkMarkHLImage = [UIImage imageNamed:@"check_icn_hl.png"];
    UIView *checkMarkNoneView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, checkMarkImage.size.width, checkMarkImage.size.height)];
    checkMarkNoneView.opaque = NO;
    UIImage *checkMarkNone = [Utility imageWithView:checkMarkNoneView];
    
    //Step One is Completed
    if ([self.stepOneController stepIsComplete]) {
        [self.stepOneButton setImage:checkMarkImage forState:UIControlStateNormal];
        [self.stepOneButton setImage:checkMarkHLImage forState:UIControlStateSelected];
        [self.stepOneButton setImage:checkMarkHLImage forState:UIControlStateSelected | UIControlStateHighlighted];
        
        [self.stepTwoButton setEnabled:YES];
    } else {
        [self.stepOneButton setImage:checkMarkNone forState:UIControlStateNormal];
        [self.stepOneButton setImage:checkMarkNone forState:UIControlStateSelected];
        [self.stepOneButton setImage:checkMarkNone forState:UIControlStateSelected | UIControlStateHighlighted];
        
        [self.stepTwoButton setEnabled:NO];
    }
    
    //Step Two is Completed
    if ([self.stepOneController stepIsComplete] && [self.stepTwoController stepIsComplete]) {
        [self.stepTwoButton setImage:checkMarkImage forState:UIControlStateNormal];
        [self.stepTwoButton setImage:checkMarkHLImage forState:UIControlStateSelected];
        [self.stepTwoButton setImage:checkMarkHLImage forState:UIControlStateSelected | UIControlStateHighlighted];
    } else {
        [self.stepTwoButton setImage:checkMarkNone forState:UIControlStateNormal];
        [self.stepTwoButton setImage:checkMarkNone forState:UIControlStateSelected];
        [self.stepTwoButton setImage:checkMarkNone forState:UIControlStateSelected | UIControlStateHighlighted];
    }
}

- (void) createCheckoutCompleteSubscription {
    [_checkoutCompleteSubscription cancel]; //Cancel any previously set up subscription
    _checkoutCompleteSubscription = [[CheckoutCompleteSubscription alloc] initWithContext:[ModelContext instance]];
    _checkoutCompleteSubscription.delegate = self;
    [self subscriptionUpdatedState:_checkoutCompleteSubscription];
}


- (void)handleCheckoutCompleteSubscriptionError {
    [self.stepTwoController showDataErrors];
    [self.stepTwoController.dataTable reloadData];
    BOOL areThereCheckoutErrors = [[ModelContext instance].plndrPurchaseSession.checkoutErrors count] > 0;
    if (areThereCheckoutErrors) {
        [self setFlagForCartItemForViewController:self];
    }
    PopupViewController *popup;
    NSString *errorStr;
    NSString *popupButtonTitle = nil;
    if (areThereCheckoutErrors) {
        CheckoutError *firstCheckoutError = [[ModelContext instance].plndrPurchaseSession.checkoutErrors objectAtIndex:0];
        [ModelContext instance].plndrPurchaseSession.lastDisplayedCheckoutError = firstCheckoutError;
        errorStr = firstCheckoutError.generalMessage;
        
        XLCheckoutErrorResolution checkoutErrorResolution = [firstCheckoutError getCheckoutErrorResolution];
        if ([NavigationControlManager shouldErrorResolution:checkoutErrorResolution resultInNavigationFromController:self]) {
            popupButtonTitle = kCheckoutErrorButtonGoThere;
        }
        [self displayAPIErrorWithTitle:kCheckoutErrorTitle message:errorStr buttonTitle:popupButtonTitle usingPopup:&popup];
        self.checkoutErrorPopup = popup;
        
    } else {
        errorStr = [Utility getDefaultErrorStringFromSubscription:self.checkoutCompleteSubscription];
        [self displayAPIErrorWithTitle:kCheckoutErrorTitle message:errorStr buttonTitle:popupButtonTitle usingPopup:&popup];
        self.defaultErrorPopup = popup;
    }
    // TODO - special error handling for CheckoutErrors
}
    
- (void)pushCheckoutCompleteResponse {
    
    for (AdjustedCartItem* item in [[[[ModelContext instance] plndrPurchaseSession] checkoutSummary] adjustedItems]) {
        // Get the matching CartItem, so we have a categoryId
        CartItem *cartItem = [[ModelContext instance] getCartItemWithSkuId:item.skuId];
        NSString *categoryId = cartItem.product.categoryId ? [NSString stringWithFormat:@"%d", cartItem.product.categoryId.intValue] : @"N/A";
        
        [[GANTracker sharedTracker] addItem:[[[[[ModelContext instance] plndrPurchaseSession] checkoutComplete] orderNumber] stringValue]
                                    itemSKU: [item.skuId stringValue]
                                  itemPrice:([item.originalPricePerUnit doubleValue] * item.quantity.intValue)
                                  itemCount:item.quantity.intValue 
                                   itemName:item.productName 
                               itemCategory:categoryId
                                  withError:nil];      
    }

    CheckoutSummary *checkoutSummary = [[[ModelContext instance] plndrPurchaseSession] checkoutSummary];
    
    [[GANTracker sharedTracker] addTransaction:[[[[[ModelContext instance] plndrPurchaseSession] checkoutComplete] orderNumber] stringValue]
                                    totalPrice:[checkoutSummary.total doubleValue]
                                     storeName:kAppName
                                      totalTax:[checkoutSummary.tax doubleValue]
                                  shippingCost:[checkoutSummary.shippingSubtotal doubleValue]
                                     withError:nil];
        
    [[GANTracker sharedTracker] trackTransactions:nil];

    PurchaseReceiptViewController *purchaseConfirmationViewController = [[PurchaseReceiptViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:purchaseConfirmationViewController];
    [self presentModalViewController:navController animated:YES];
    [self changeToStep:CheckoutViewControllerStepOne]; // TODO: 32558291 - Refactor to seem less hacky
}

- (BOOL)isStillVisible:(id)sender {
    if (self.stepOneButton.isSelected) {
        return [[NavigationControlManager instance] isControllerVisible:self.stepOneController];
    } else {
        return [[NavigationControlManager instance] isControllerVisible:self.stepTwoController];
    }
}

- (void)proceedToStepTwo {
    if ([self.stepOneController stepIsComplete]) {
        [self stepClicked:self.stepTwoButton];
    } else {
        [self.stepOneController showDataErrors];
        [self.stepOneController.dataTable reloadData];
    }

}

#pragma mark - CheckoutDelegate

- (void)updateContainerView {
    [self updateNavBar];
    [self updateStepButtonStates];
}

- (void)doPurchase {
    [self.stepTwoController.scrollContainer setContentOffset:CGPointMake(0,0) animated:YES];
    if ([self.stepTwoController stepIsComplete]) {
        [self createCheckoutCompleteSubscription];
    } else {
        [self displayLastCheckoutError];
    }
}

#pragma Checkout Helper 

- (void)displayLastCheckoutError {
    NSString *errorStr;
    NSString *popupButtonTitle;
    PopupViewController *popup;
    CheckoutError *lastCheckoutError = [ModelContext instance].plndrPurchaseSession.lastDisplayedCheckoutError;
    errorStr = lastCheckoutError.generalMessage;
    XLCheckoutErrorResolution checkoutErrorResolution = [lastCheckoutError getCheckoutErrorResolution];
    if ([NavigationControlManager shouldErrorResolution:checkoutErrorResolution resultInNavigationFromController:self]) {
        popupButtonTitle = kCheckoutErrorButtonGoThere;
    }
    [self displayAPIErrorWithTitle:kCheckoutErrorTitle message:errorStr buttonTitle:popupButtonTitle usingPopup:&popup];
    self.lastDisplayedCheckoutPopup = popup;
}
    

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if (subscription.state == SubscriptionStateAuthenticationRequired) {
        [self hideLoadingView];
        [self abortForAuthentication];
    } else if(subscription.state == SubscriptionStateNoConnection) {
        [self hideLoadingView];
        [self handleConnectionError];
    } else if (subscription == self.checkoutCompleteSubscription) {
        if (subscription.state == SubscriptionStateAvailable) {
            [subscription cancel];
            [self hideLoadingView];
            [self pushCheckoutCompleteResponse];
        } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
            [self hideLoadingView];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            [self handleCheckoutCompleteSubscriptionError];
        } else { // Pending
            [self showLoadingView];
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
        }
    }
}

#pragma mark - PopupViewControllerDelegate

- (void) dismissPopup:(id)sender {
    [PopupUtil dismissPopup];
    if (self.defaultErrorPopup) {
        [((PlndrAppDelegate*)[UIApplication sharedApplication].delegate) switchToTabIndex:kMyCartTabIndex];
        self.defaultErrorPopup = nil;
    } else if(self.checkoutErrorPopup) {
        // otherwise do nothing 
        self.checkoutErrorPopup = nil;
    } else {
        self.lastDisplayedCheckoutPopup = nil;
    }
}

#pragma mark - PopupNotificationDelegate

- (void) popupButtonOneClicked:(id)sender popupViewController:(PopupNotificationViewController *)popupViewController{
    [PopupUtil dismissPopup];
    // pop to cart if this error was fatal
    if (self.defaultErrorPopup) {
        [((PlndrAppDelegate*)[UIApplication sharedApplication].delegate) switchToTabIndex:kMyCartTabIndex];
        self.defaultErrorPopup = nil;
    } else if(self.checkoutErrorPopup){
        // Otherwise, let the NavigationControlManager handle it (Tell it we are step 2, to avoid duplication of error handling
        // between checkout and step 2)
        CheckoutError *firstCheckoutError = [[ModelContext instance].plndrPurchaseSession.checkoutErrors objectAtIndex:0];
        XLCheckoutErrorResolution checkoutErrorResolution = [firstCheckoutError getCheckoutErrorResolution];
        [[NavigationControlManager instance] setErrorType:checkoutErrorResolution forViewController:self.stepTwoController];
        self.checkoutErrorPopup = nil;
    } else {
        CheckoutError *lastError = [ModelContext instance].plndrPurchaseSession.lastDisplayedCheckoutError;
        XLCheckoutErrorResolution checkoutErrorResolution = [lastError getCheckoutErrorResolution];
        [[NavigationControlManager instance] setErrorType:checkoutErrorResolution forViewController:self.stepTwoController];
        self.lastDisplayedCheckoutPopup = nil;
    }
}

@end
