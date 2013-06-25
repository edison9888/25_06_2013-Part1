//
//  MyCartViewController.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyCartViewController.h"
#import "Constants.h"
#import "ModelContext.h"
#import "Product.h"
#import "MyCartTableCell.h"
#import "Utility.h"
#import "ProductViewController.h"
#import "CartItem.h"
#import "LoginSession.h"
#import "CheckoutViewController.h"
#import "PlndrPurchaseSession.h"
#import "CheckoutSummary.h"
#import "CheckoutError.h"
#import "GANTracker.h"
#import "StepOneViewController.h"

@interface MyCartViewController () 

- (void) setupNavBar;
- (void) doneButtonPressed;
- (void) editButtonPressed;
- (void) checkoutButtonPressed;
- (void) updateView:(BOOL)reloadTable;
- (void) updateSectionHeader;
- (void) pushPurchaseFlowIfLoggedIn;
- (void) updateNavBarButtonStates;
- (UIView*) createErrorView;
- (void) createCartStockSubscription;
- (void) handleCartStockSubscriptionError;


@end

@implementation MyCartViewController

@synthesize cartTable = _cartTable;
@synthesize numberItemsLabel = _numberItemsLabel;
@synthesize subtotalLabel = _subtotalLabel;
@synthesize errorHeader = _errorHeader;
@synthesize isRefreshing = _isRefreshing;
@synthesize cartStockSubscription = _cartStockSubscription;

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"MY CART"; 
    }
    return self;
}

- (void)dealloc {
    self.cartTable.delegate = nil;
    self.cartTable.dataSource = nil;
    [self.cartStockSubscription cancel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.cartTable.delegate = nil;
    self.cartTable.dataSource = nil;
    self.cartTable = nil;
    self.numberItemsLabel = nil;
    self.subtotalLabel = nil;
}


#pragma mark - View lifecycle

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[self defaultFrame]];
    
    self.view.backgroundColor = kPlndrBgGrey;
    
    [self setupNavBar];
    
    self.cartTable = [[UITableView alloc] initWithFrame:self.view.frame];
    self.cartTable.delegate = self;
    self.cartTable.dataSource = self;
    self.cartTable.backgroundColor = [UIColor clearColor];
    self.cartTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cartTable.allowsSelectionDuringEditing = YES;
    [self.view addSubview:self.cartTable];
    
    [self initPullDownViewOnParentView:self.cartTable];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    if (!self.isPresentingAuthenticationDueToInterruption && !self.isPresentingConnectionErrorPopup) {
        if ([ModelContext instance].isCartStockStale) {
            [self pullPullDownView];
        } else {
            [self updateView:YES];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isPresentingAuthenticationDueToInterruption) {
        [self presentAuthRequired];
    } else {
        [[GANTracker sharedTracker] trackPageview:kGANPageMyCart withError:nil];     
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [self.cartTable setEditing:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSIndexPath *)getIndexPathForCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.cartTable indexPathForCell:cell];
    if (!indexPath) {
        indexPath = [NSIndexPath indexPathForRow:cell.tag inSection:0];
    }
    return indexPath;
}

#pragma mark - private

- (void)setupNavBar {
    if (self.cartTable.isEditing) {
        self.navigationItem.leftBarButtonItem = nil;
        
        // Setup the right nav button

        UIButton *doneButton = [PlndrBaseViewController createNavBarButtonWithText:@"DONE" withNormalColor:kPlndrTextGold withHighlightColor:kPlndrBlack];
        [doneButton setTitleColor:kPlndrMediumGreyTextColor forState:UIControlStateDisabled];
        [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    } else {
        // Setup the left nav button
        UIButton *editButton = [PlndrBaseViewController createNavBarButtonWithText:@"EDIT"];
        [editButton setTitleColor:kPlndrMediumGreyTextColor forState:UIControlStateDisabled];
        [editButton addTarget:self action:@selector(editButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
        
        // Setup the right nav button
        UIButton *checkoutButton = [PlndrBaseViewController createNavBarButtonWithText:@"CHECKOUT" withNormalColor:kPlndrTextGold withHighlightColor:kPlndrBlack];
        [checkoutButton setTitleColor:kPlndrMediumGreyTextColor forState:UIControlStateDisabled];
        [checkoutButton addTarget:self action:@selector(checkoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkoutButton];
        [self updateNavBarButtonStates];
    }
}

- (void)doneButtonPressed {
    [self.cartTable setEditing:NO animated:YES];
    [self updateView:NO];
}

- (void)editButtonPressed {
    if (self.cartTable.editing) {
       [self.cartTable setEditing:NO animated:YES]; 
    }
    [self.cartTable setEditing:YES animated:YES];
    [self updateView:NO];
}

- (void)checkoutButtonPressed {
    if ([[ModelContext instance] loginSession].isLoggedIn) { 
        [self pushPurchaseFlowIfLoggedIn];
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginDelegate:self hasSessionExpired:NO];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentModalViewController:navController animated:YES];
    }
}

- (void)pushPurchaseFlowIfLoggedIn {
    if ([[ModelContext instance] loginSession].isLoggedIn) {
        [[GANTracker sharedTracker] trackEvent:kGANEventCheckout action:kGANActionCheckoutStart label:nil value:-1 withError:nil];
        
        // Shipping methods could change as a result of changing cart items.
        // Keep it simple by always starting a checkout without shipping methods
        [[[ModelContext instance] plndrPurchaseSession] resetShippingMethods];
        
        CheckoutViewController *checkoutViewController = [[CheckoutViewController alloc] init];
        [self.navigationController pushViewController:checkoutViewController animated:YES];
    }
}

- (void)updateView:(BOOL)reloadTable {
    [self setupNavBar];

    if (reloadTable) {
       [self.cartTable reloadData]; 
    }
    
    [self updateSectionHeader];    
}

- (void) updateSectionHeader {
    int numberOfItems = [[ModelContext instance] getNumberOfItemsInCart];
    self.numberItemsLabel.text = [NSString stringWithFormat:@"%d Item%@", numberOfItems, (numberOfItems == 1) ? @"" : @"s"];
    self.subtotalLabel.text = [NSString stringWithFormat:@"Subtotal: %@", [Utility currencyStringForFloat:[[ModelContext instance] getTotalCostOfItemsInCart]]];
}

- (void)updateNavBarButtonStates {
    if( [ModelContext instance].cartItems.count == 0) {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    } else {
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
        [self.navigationItem.rightBarButtonItem setEnabled:[[ModelContext instance] isCartValid]];
    }
}

- (UIView*)createErrorView {
    UIView *errorHeader = nil;
    
    if (![[ModelContext instance] isCartValid]) {
        NSString *errorMessage = kMyCartGreyHeaderErrorMessage;
        UIImage *blackBannerImage = [[UIImage imageNamed:@"message_banner.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
        errorHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, blackBannerImage.size.width, kMyCartSectionErrorHeaderHeight)];
        UIImageView *blackBanner = [[UIImageView alloc] initWithImage:blackBannerImage];
        blackBanner.frame = CGRectMake(0, 0, errorHeader.frame.size.width, errorHeader.frame.size.height);
        UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(kErrorHeaderMargin, 0, kDeviceWidth - 2*kErrorHeaderMargin, blackBanner.frame.size.height)];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textColor = kPlndrWhite;
        headerLabel.font = kFontHeaderErrorMessage;
        headerLabel.lineBreakMode = UILineBreakModeTailTruncation;
        headerLabel.numberOfLines = 1;
        headerLabel.text = errorMessage;
        [blackBanner addSubview:headerLabel];
        [errorHeader addSubview:blackBanner];
        errorHeader.backgroundColor = kPlndrBgGrey;
    }
    
    return errorHeader;
}

- (void)createCartStockSubscription {
    [_cartStockSubscription cancel]; //Cancel any previously set up subscription
    _cartStockSubscription = [[CartStockSubscription alloc] initWithContext:[ModelContext instance]];
    _cartStockSubscription.delegate = self;
    [self subscriptionUpdatedState:_cartStockSubscription];
}

- (void)handleCartStockSubscriptionError {
    PopupViewController *popup;
    NSString *errorStr = [Utility getDefaultErrorStringFromSubscription:self.cartStockSubscription];
    [self displayAPIErrorWithTitle:kCartErrorTitle message:errorStr usingPopup:&popup];
    self.defaultErrorPopup = popup;
}

- (void)handleAbortForAuthentication {
    self.isPresentingAuthenticationDueToInterruption = YES;
    if (self.modalViewController) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)handleConnectionError:(PlndrBaseViewController *)vc {
    if ([vc isKindOfClass:[StepOneViewController class]]) {
        self.isPresentingConnectionErrorPopup = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource/Delegate

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartItem *cartItem = [[[ModelContext instance] cartItems] objectAtIndex:indexPath.row];
    if (![cartItem containsError]) {
        return kMyCartTableCellHeight;
    } else {
        return kMyCartTableCellHeight + kMyCartTableCellErrorFooterHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ModelContext instance].cartItems.count;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    int sectionHeaderMargin = 10;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kMyCartSectionHeaderHeight)];
    headerView.backgroundColor = kPlndrBgGrey;
    
    if (!self.numberItemsLabel) {
        self.numberItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(sectionHeaderMargin, 0, (kDeviceWidth - sectionHeaderMargin*3)*2.0/5.0, kMyCartSectionHeaderHeight)];
        self.numberItemsLabel.font = kFontMedium15;
        self.numberItemsLabel.textColor = kPlndrBlack;
        self.numberItemsLabel.backgroundColor = [UIColor clearColor];
    }
    [headerView addSubview:self.numberItemsLabel];
    
    if (!self.subtotalLabel) {
        int subtotalLabelWidth = (kDeviceWidth - sectionHeaderMargin*3)*3.0/5.0;
        self.subtotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - subtotalLabelWidth - sectionHeaderMargin, 0, subtotalLabelWidth, kMyCartSectionHeaderHeight)];
        self.subtotalLabel.font = kFontBold15;
        self.subtotalLabel.textColor = kPlndrBlack;
        self.subtotalLabel.textAlignment = UITextAlignmentRight;
        self.subtotalLabel.backgroundColor = [UIColor clearColor];
    }
    [headerView addSubview:self.subtotalLabel];
    
    UIView *darkBorder = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 2, kDeviceWidth, 2)];
    darkBorder.backgroundColor = kPlndrMediumGreyTextColor;
    [headerView addSubview:darkBorder];
    
    [self updateSectionHeader];

    UIView *errorHeader = [self createErrorView];
    
    UIView *headerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height + errorHeader.frame.size.height)];
    [headerContainerView addSubview:errorHeader];
    headerView.frame = CGRectMake(headerView.frame.origin.x, errorHeader.frame.size.height, headerView.frame.size.width, headerView.frame.size.height);
    [headerContainerView addSubview:headerView];
    
    return headerContainerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = [[ModelContext instance] isCartValid] ? kMyCartSectionHeaderHeight : kMyCartSectionHeaderHeight + kMyCartSectionErrorHeaderHeight;
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cartItemCell";
    
    MyCartTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyCartTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.myCartDelegate = self;
    }
    
    cell.tag = indexPath.row;
    
    [cell updateWithCartItem:((CartItem*)[[ModelContext instance].cartItems objectAtIndex:indexPath.row])];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CartItem *cartItem = (CartItem*)[[ModelContext instance].cartItems objectAtIndex:indexPath.row];
    
    ProductViewController *productVC = [[ProductViewController alloc] initWithProduct:cartItem.product saleId:cartItem.saleId];
    [self.navigationController pushViewController:productVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL wasCartValid = [[ModelContext instance] isCartValid];
    [[ModelContext instance] removeAllQuantityOfCartItemAtIndex:indexPath.row];
    
	[self.cartTable beginUpdates];
	BOOL cartIsEmpty = [[ModelContext instance] cartItems].count == 0;
    [self.cartTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:cartIsEmpty ? UITableViewRowAnimationTop : UITableViewRowAnimationNone];
    [self updateSectionHeader];
    if (cartIsEmpty){
        [self.cartTable setEditing:NO animated:YES];
        [self updateView:YES];
    } else if ([[ModelContext instance] isCartValid] && !wasCartValid) { // When going from invalid to valid, the header changes. We need to reload the table in order for that to actually happen.
        [self updateView:YES];
    }
    
	[self.cartTable endUpdates];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateView:YES];
}



#pragma mark - MyTableCellDelegate

- (void) addQuantity:(id)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    CartItem *cartItem = [[ModelContext instance].cartItems objectAtIndex:indexPath.row];
    [[ModelContext instance] addCartItemToCart:cartItem];
    [self updateView:YES];
}

- (void) subtractQuantity:(id)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    [[ModelContext instance] decrementQuantityOfCartItemAtIndex:indexPath.row];
    [self updateView:YES];
}

- (BOOL) minusButtonEnabled:(id)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    CartItem *cartItem = [[ModelContext instance].cartItems objectAtIndex:indexPath.row];
    return cartItem.quantity > 1;
}

- (BOOL) plusButtonEnabled:(id)sender {
    NSIndexPath *indexPath = [self getIndexPathForCell:sender];
    CartItem *cartItem = [[ModelContext instance].cartItems objectAtIndex:indexPath.row];
    return cartItem.quantity < cartItem.size.stock.intValue;
}

#pragma mark - LoginViewControllerDelegate

- (void) loginModalDidDisappear {
    [self pushPurchaseFlowIfLoggedIn];
}

#pragma mark - SimplifiedEGORefreshTableHeaderDelegate Methods

- (void)pullDownToRefreshContent {
    [self createCartStockSubscription];
}

- (BOOL)pullDownIsLoading{
    return (self.cartStockSubscription.state == SubscriptionStatePending);
}

#pragma mark - SubscriptionDelegate

- (void)subscriptionUpdatedState:(ModelSubscription *)subscription {
    if(subscription.state == SubscriptionStateNoConnection) {
        [self resetPullDownView];
        [self hideLoadingView];
        [self handleConnectionError];
    } else if (subscription.state == SubscriptionStateAvailable || subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
        [subscription cancel];
        [self.cartTable reloadData];
        [self resetPullDownView];
        [self hideLoadingView];
        if (subscription.state == SubscriptionStateAvailable) {
            [self updateView:YES];
        } else if (subscription.state == SubscriptionStateUnknown || subscription.state == SubscriptionStateUnavailable) {
            [self handleCartStockSubscriptionError];
        }
    } else { // Pending
        // We are doing pull down instead
    }
}

@end
