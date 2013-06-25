//
//  ModelContext.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModelContext.h"
#import "APIRequestController.h"
#import "SubscriptionManager.h"
#import "ShippingMethod.h"
#import "Country.h"
#import "Sale.h"
#import "Product.h"
#import "ProductSku.h"
#import "CartItem.h"
#import "PlndrPurchaseSession.h"
#import "LoginSession.h"
#import "SignupSession.h"
#import "SaleFilterCategory.h"
#import "SaleDetail.h"
#import "Constants.h"
#import "HomeNavBarView.h"
#import "PlndrAppDelegate.h"
#import "CheckoutSummary.h"
#import "AccountDetails.h"
#import "SavedAddress.h"
#import "CheckoutCompleteResponse.h"
#import "CreditCardType.h"
#import "SkuStock.h"
#import "Utility.h"

NSString* kCartArchiverKey = @"kCartArchiverKey";
NSString* kGenderArchiverKey = @"kGenderArchiverKey";
NSString* kLoginSessionArchiverKey = @"kLoginSessionArchiverKey";

@interface ModelContext () 

- (NSArray*)loadSales:(NSDictionary*)salesData forKey:(NSString*)key;
- (void)loadAccountDetails:(NSDictionary*)accountDetailsData request:(AsyncRequestController*)request;
- (BOOL)loadCheckoutOptions:(NSDictionary*)checkoutOptionsData request:(AsyncRequestController *)request;
- (void)loadCreditCardOptions:(NSArray*)creditCardOptionData request:(AsyncRequestController *)request;
- (void)loadCountries:(NSArray*)countriesData request:(AsyncRequestController *)request;
- (void)loadSales:(NSDictionary*)salesData request:(AsyncRequestController *)request;
- (void)loadSavedAddresses:(NSDictionary*)savedAddressesData request:(AsyncRequestController*)request;
- (void)loadProducts:(NSArray*)productsData request:(AsyncRequestController *)request;
- (void)loadProductDetail:(NSDictionary*)productData request:(AsyncRequestController *)request;
- (void)loadSaleCategories:(NSDictionary *)filterDictionary request:(AsyncRequestController *)request;
- (void)loadCategorySizes:(NSDictionary *)filterDictionary request:(AsyncRequestController *)request;
- (void)doLoginWithAuthToken:(NSDictionary *)authTokenDictionary request:(AsyncRequestController *)request;
- (BOOL)loadCheckoutSummary:(NSDictionary *)checkoutSummaryDictionary request:(AsyncRequestController *)request;
- (BOOL)loadCheckoutComplete:(NSDictionary *)checkoutCompleteDictionary request:(AsyncRequestController *)request;
- (void)loadCartStock:(NSArray *)cartStockData request:(AsyncRequestController *)request;
- (void) saveCartToDisk;
- (NSString*) getCartFilePath;

- (NSString*) getLoginSessionFilePath;

- (void) saveItemToDisk:(NSObject*)item encodingKey:(NSString*)encodingKey filePath:(NSString*) filePath;

- (SaleFilterCategory*) getCategoryForSaleId:(NSNumber*)saleId categoryId:(NSString*)categoryId;
- (void) loadPersisitedInitialValues;
- (void) updateCartAndState;
- (void) saveItemToDisk:(NSObject *)item encodingKey:(NSString *)encodingKey filePath:(NSString *)filePath;
- (NSString *)getGenderFilePath;
- (NSArray*)grabCategorySizesFromDictionary:(NSDictionary*) filterDictionary;

@end

@implementation ModelContext

@synthesize mensSales = _mensSales, womensSales = _womensSales, allSales = _allSales;
@synthesize saleIdToSaleDetail = _saleIdToSaleDetail;
@synthesize productIdToProduct = _productIdToProduct;
@synthesize cartItems = _cartItems;
@synthesize isCartStockStale = _isCartStockStale;
@synthesize plndrPurchaseSession = _plndrPurchaseSession;
@synthesize loginSession = _loginSession;
@synthesize signupSession = _signupSession;

static ModelContext *instance = nil;
+ (ModelContext*)instance {
	if (!instance) {
		instance = [[ModelContext alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	}
	return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.saleIdToSaleDetail = [NSMutableDictionary dictionary];
        self.productIdToProduct = [NSMutableDictionary dictionary];

        [self loadPersisitedInitialValues];
    }
    return self;
}

- (void) didReceiveMemoryWarning {
    
    NSLog(@"WARNING: Model Context received memory warning: dumping sale and product caches");
    [self clearSales];
    self.productIdToProduct = [NSMutableDictionary dictionary];
}

- (void)clearSales {
    self.mensSales = nil;
    self.womensSales = nil;
    self.allSales = nil;
    self.saleIdToSaleDetail = [NSMutableDictionary dictionary];
}

- (SaleDetail*) getSaleDetailForSale:(Sale *)sale genderCategory:(GenderCategory)genderCategory {
    SaleDetail *saleDetail = [self.saleIdToSaleDetail objectForKey:sale.saleId];
    if (!saleDetail || (saleDetail && saleDetail.genderCategory != genderCategory)) {
        saleDetail = [[SaleDetail alloc] initFromSale:sale];
        saleDetail.genderCategory = genderCategory;
        [self.saleIdToSaleDetail setObject:saleDetail forKey:sale.saleId];
    }
    return saleDetail;
}

- (void) addSaleDetailToCache:(SaleDetail*)saleDetail {
    SaleDetail *existingSaleDetail = [self.saleIdToSaleDetail objectForKey:saleDetail.sale.saleId];
    if (!existingSaleDetail) {
        // If this had to be added to the cache, then it can't possibly know that it doesn't have more
        // products to fetch.
        saleDetail.hasMoreProductsToFetch = YES;
        [self.saleIdToSaleDetail setObject:saleDetail forKey:saleDetail.sale.saleId];
    }
}

- (NSArray *)getProductsForSaleId:(NSNumber*)saleId {
    NSArray *productIds = ((SaleDetail*)[self.saleIdToSaleDetail objectForKey:saleId]).productIds;
    NSMutableArray *products = [NSMutableArray arrayWithCapacity:productIds.count];
    for (NSNumber* productId in productIds) {
        Product *product = [self getProduct:productId];
        if (product) {
            [products addObject:product];
        }
    }
    return [NSArray arrayWithArray:products];
}

- (GenderCategory) genderCategory {
    return _genderCategory;
}

- (void) setGenderCategory:(GenderCategory)genderCategory {
    _genderCategory = genderCategory;
    [self saveItemToDisk:[NSNumber numberWithInt:_genderCategory] encodingKey:kGenderArchiverKey filePath:[self getGenderFilePath]];
}

- (Product*) getProduct:(NSNumber*)productId {
    return [self.productIdToProduct objectForKey:productId];
}

- (void)addProductToCache:(Product *)product {
    [self.productIdToProduct setObject:product forKey:product.productId];
}

- (NSArray*) getCategoryFiltersForSaleId:(NSNumber*)saleId {
    return ((SaleDetail*)[self.saleIdToSaleDetail objectForKey:saleId]).filterCategories;
}

- (NSArray *)getSizeFiltersForSaleId:(NSNumber *)saleId categoryId:(NSString *)categoryId {
    return [self getCategoryForSaleId:saleId categoryId:categoryId].sizes;
}

- (int)getCurrentCategoryFilterIndexForSaleId:(NSNumber *)saleId {
    return ((SaleDetail*)[[[ModelContext instance] saleIdToSaleDetail] objectForKey:saleId]).currentFilterCategoryIndex;
}

- (int)getCurrentSizeFilterIndexForSaleId:(NSNumber*)saleId {
    return ((SaleDetail*)[[[ModelContext instance] saleIdToSaleDetail] objectForKey:saleId]).currentFilterSizeIndex;
}

- (NSString*) getCurrentCategoryIdFilterForSaleId:(NSNumber*)saleId {
    SaleDetail *saleDetail = [[[ModelContext instance] saleIdToSaleDetail] objectForKey:saleId];
    if (saleDetail.currentFilterCategoryIndex < 0) {
        return nil;
    }
    SaleFilterCategory *category = [saleDetail.filterCategories objectAtIndex:saleDetail.currentFilterCategoryIndex];
    return category.categoryId;
}

- (NSString *)getCurrentGenderCategoryStringForSaleId:(NSNumber *)saleId {
    SaleDetail *saleDetail = [[[ModelContext instance] saleIdToSaleDetail] objectForKey:saleId];
    return [self getGenderCategoryStringForGenderCategory:saleDetail.genderCategory];
}

- (NSString*)getGenderCategoryStringForGenderCategory:(GenderCategory)genderCategory {
    switch (genderCategory) {
        case GenderCategoryAll:
            return @"0";
        case GenderCategoryMen:
            return @"1";
        case GenderCategoryWomen:
            return @"2";
    }
}

- (SaleFilterCategory *)getCategoryForSaleId:(NSNumber *)saleId categoryId:(NSString *)categoryId {
    NSArray *categories = [self getCategoryFiltersForSaleId:saleId];
    for (SaleFilterCategory *category in categories) {
        if ([categoryId isEqualToString:category.categoryId]) {
            return category;
        }
    }
    return nil;
}

- (int)getNumberOfItemsInCart {
    int numberOfItems = 0;
    for (CartItem* cartItem in [ModelContext instance].cartItems) {
        numberOfItems += cartItem.quantity;
    }
    return numberOfItems;
}

- (double)getTotalCostOfItemsInCart {
    double subtotal = 0;
    for (CartItem* cartItem in [ModelContext instance].cartItems) {
        subtotal += [cartItem.product.checkoutPrice doubleValue] * cartItem.quantity;
    }
    return subtotal;
}

- (NSMutableArray *)cartItems {
    if (!_cartItems) {
        // Retrieve cartItems from disk.
        NSData *codedData = [[NSData alloc] initWithContentsOfFile:[self getCartFilePath]];
        if (codedData == nil) {
            _cartItems = [NSMutableArray array];
            [self saveCartToDisk];
        } else {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
            _cartItems = [unarchiver decodeObjectForKey:kCartArchiverKey];   
            [unarchiver finishDecoding];
            
            // Add all of the products in the cart to the cached products:
            for (CartItem *cartItem in _cartItems) {
                [self.productIdToProduct setObject:cartItem.product forKey:cartItem.product.productId];
            }
            
        }
    }
    return _cartItems;
}

- (PlndrPurchaseSession *)plndrPurchaseSession {
    if (!_plndrPurchaseSession) {
        _plndrPurchaseSession = [[PlndrPurchaseSession alloc] init];
    }
    return _plndrPurchaseSession;
}


- (LoginSession*)loginSession {
    if (!_loginSession) {
        NSData *codedData = [[NSData alloc] initWithContentsOfFile:[self getLoginSessionFilePath]];
        if (codedData == nil){
            _loginSession = [[LoginSession alloc] init];
            [self saveLoginSessionToDisk];
        } else {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
            _loginSession = [unarchiver decodeObjectForKey:kLoginSessionArchiverKey];
            [unarchiver finishDecoding];
        }
    }
    return _loginSession;
}

- (SignupSession*)signupSession {
    if (!_signupSession) {
        _signupSession = [[SignupSession alloc] init];
    }
    return _signupSession;
}

- (int)additionalStockAvailableForProduct:(Product *)product sku:(ProductSku*)sku {
    // If the sku is in the cart, check remaining stock
    // Otherwise, return all available stock
    
    for (CartItem *cartItem in [[ModelContext instance] cartItems]) {
        if ([cartItem.product.productId isEqual:product.productId] && [cartItem.size.size isEqualToString:sku.size]) {
            return sku.stock.intValue - cartItem.quantity;
        }
    }
    
    return sku.stock.intValue;
}

- (BOOL) isProductSoldOut:(Product*) product {
    if (product.skus.count == 0) {
        return product.stock.intValue <= 0;
    }
    for (ProductSku *sku in product.skus) {
        if([self additionalStockAvailableForProduct:product sku:sku] > 0) {
            return NO;
        }
    }
    return YES;
}

- (void)updateCartItemWithSkuStocks:(NSArray *)skuStocks {
    NSMutableArray *newCartItems = [NSMutableArray array];
    for (SkuStock *skuStock in skuStocks) {
        for (CartItem *cartItem in self.cartItems) {
            if ([cartItem.size.skuId isEqualToNumber:skuStock.skuId]) {
                ProductSku *newProductSku = [[ProductSku alloc] initWithskuId:cartItem.size.skuId stock:skuStock.stock size:cartItem.size.size color:cartItem.size.color] ;
                CartItem *newCartItem = [[CartItem alloc] initWithProduct:cartItem.product size:newProductSku saleId:[cartItem.saleId copy]];
                newCartItem.isUnavailableDueToError = cartItem.isUnavailableDueToError;
                newCartItem.quantity = cartItem.quantity;
                [newCartItems addObject:newCartItem];
            }
        }
    }
    self.cartItems = newCartItems;
    self.isCartStockStale = NO;
}

#pragma mark - private MyCart Functions

- (NSString *)getCartBadgeString {
    int numOfItemsInCart = [self getNumberOfItemsInCart];
    if (numOfItemsInCart >0) {
        return [NSString stringWithFormat:@"%d", numOfItemsInCart];
    } else {
        return nil;
    }
}

- (void) addCartItemToCart:(CartItem *)cartItem {
    BOOL itemAdded = NO;
    for (CartItem *item in self.cartItems) {
        if ([item isEqual:cartItem]) {
            item.quantity++;
            itemAdded = YES;
            break;
        }
    }
    if (!itemAdded) {
        [self.cartItems addObject:cartItem];
    }
    [self updateCartAndState];
}

- (CartItem *)getCartItemWithSkuId:(NSNumber *)skuId {
    for (CartItem *item in self.cartItems) {
        if (item.size.skuId.intValue == skuId.intValue) {
            return item;
        }
    }
    return nil;
}

- (void) removeAllQuantityOfCartItemFromCart:(CartItem *)cartItem {
    [self.cartItems removeObject:cartItem];
    [self updateCartAndState];
    
}

- (void) removeAllQuantityOfCartItemAtIndex:(int)index {
    if (index < self.cartItems.count && index > -1) {
        [self.cartItems removeObjectAtIndex:index];
    }
    [self updateCartAndState];
}

- (void)decrementQuantityOfCartItemFromCart:(CartItem *)cartItem {
    CartItem *matchingCartItem = nil;
    for (CartItem *item in self.cartItems) {
        if (item == cartItem) {
            matchingCartItem = item;
        }
    }
    matchingCartItem.quantity--;
    [self updateCartAndState];
}

- (void)decrementQuantityOfCartItemAtIndex:(int)index{
    CartItem *cartItem = [self.cartItems objectAtIndex:index];
    if (cartItem.quantity > 1) {
        cartItem.quantity--;
    }
    [self updateCartAndState];
}

- (void)deleteCart {
    _cartItems = [NSMutableArray array];
    [self updateCartAndState];
}

- (NSArray *)getCartItemsForAPI {
    NSMutableArray *cartArray = [NSMutableArray array];
    for (CartItem *cartItem in self.cartItems) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
        [mutableDictionary setObject:[Utility safeStringWithString:[NSString stringWithFormat:@"%d", cartItem.size.skuId.intValue]] forKey:@"skuId"];
        [mutableDictionary setObject:[NSNumber numberWithInt:cartItem.quantity] forKey:@"quantity"];
        [mutableDictionary setObject:[Utility safeStringWithString:[NSString stringWithFormat:@"%d", cartItem.saleId.intValue]] forKey:@"trackingId"];
        [cartArray addObject:mutableDictionary];
    }
    return cartArray;
}

- (BOOL)isCartValid {
    for (CartItem *cartItem in self.cartItems) {
        if ([cartItem containsError]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - private

- (NSString *)getCartFilePath {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [rootPath stringByAppendingPathComponent:@"shoppingCartFile"];
}

- (NSString *)getGenderFilePath {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [rootPath stringByAppendingPathComponent:@"genderCategoryFile"];
}

- (void)updateCartAndState {
    [self saveCartToDisk];
    [((PlndrAppDelegate*)[UIApplication sharedApplication].delegate) updateCartBadge];
}

- (void) saveCartToDisk {
    // write cart to disk
    [self saveItemToDisk:_cartItems encodingKey:kCartArchiverKey filePath:[self getCartFilePath]];
}
- (NSString *)getLoginSessionFilePath {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [rootPath stringByAppendingPathComponent:@"loginSessionFile"];
}

- (void)saveLoginSessionToDisk {
    [self saveItemToDisk:_loginSession encodingKey:kLoginSessionArchiverKey filePath:[self getLoginSessionFilePath]];
}

- (void) saveItemToDisk:(NSObject *)item encodingKey:(NSString *)encodingKey filePath:(NSString *)filePath {
    if (item == nil) return;
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];          
    [archiver encodeObject:item forKey:encodingKey];
    [archiver finishEncoding];
    
    [data writeToFile:filePath atomically:YES];
}

- (void)loadPersisitedInitialValues {
        NSData *codedData = [[NSData alloc] initWithContentsOfFile:[self getGenderFilePath]];
        if (codedData == nil){
            self.genderCategory = [HomeNavBarView defaultGenderCategory];
        } else {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
            self.genderCategory = ((NSNumber*)[unarchiver decodeObjectForKey:kGenderArchiverKey]).intValue;
            [unarchiver finishDecoding];
        } 
}

#pragma mark - Parsing

- (BOOL)loadCheckoutOptions:(NSDictionary*)checkoutOptionsData request:(AsyncRequestController *)request {   
    NSMutableArray *tempErrorArray = [NSMutableArray array];
    for (NSDictionary *errorDictionary in [checkoutOptionsData objectForKey:@"errors"]) {
        CheckoutError *checkoutError = [[CheckoutError alloc] initFromDictionary:errorDictionary];

        [tempErrorArray addObject:checkoutError];

    }
    self.plndrPurchaseSession.checkoutErrors = tempErrorArray;
    
    if (tempErrorArray.count == 0) {
        NSMutableArray *tempMutableArray = [NSMutableArray array];
        for (NSDictionary *checkoutOptionDict in [checkoutOptionsData objectForKey:@"shippingMethods"]) {
            ShippingMethod *shippingMethod = [[ShippingMethod alloc] initFromDictionary:checkoutOptionDict];
            
            if (shippingMethod.isAvailable.boolValue) {
                [tempMutableArray addObject:shippingMethod];
            }
        }
        self.plndrPurchaseSession.shippingMethods = tempMutableArray;
    } else {
        self.plndrPurchaseSession.shippingMethods = nil;
    }

    return self.plndrPurchaseSession.checkoutErrors.count == 0;
}

- (void)loadAccountDetails:(NSDictionary *)accountDetailsData request:(AsyncRequestController *)request {
    AccountDetails *accountDetails = [[AccountDetails alloc] initFromDictionary:accountDetailsData];
    [[ModelContext instance] loginSession].accountDetails = accountDetails;
}

- (void)loadCreditCardOptions:(NSArray *)creditCardOptionData request:(AsyncRequestController *)request {
    NSMutableArray *tempMutableArray = [NSMutableArray array];
    for (NSDictionary *creditCardTypeDict in creditCardOptionData) {
        CreditCardType *creditCardType = [[CreditCardType alloc] initFromDictionary:creditCardTypeDict];
        [tempMutableArray addObject:creditCardType];
    }
    self.plndrPurchaseSession.creditCardOptions = tempMutableArray;
}

- (void)loadCountries:(NSArray*)countriesData request:(AsyncRequestController *)request {
    NSMutableArray *tempMutableArray = [NSMutableArray array];
    for (NSDictionary *countryDict in countriesData) {
        Country *country = [[Country alloc] initFromDictionary:countryDict];
        [tempMutableArray addObject:country];
    }
    self.plndrPurchaseSession.countries = tempMutableArray;
}

- (NSArray*) loadSales:(NSDictionary *)salesData forKey:(NSString*)key {
    NSMutableArray *tempMutableArray = [NSMutableArray array];
    
    int index = 0;
    for (NSDictionary *saleDict in [salesData objectForKey:key]) {
        Sale *sale = [[Sale alloc] initFromDictionary:saleDict];
        
        //This is testing code that causes the first and second sales to expire shortly
        // Note that it only affects anything if we are pointed at staging.
        if (kUseStaginUrls) {
            if (index == 0) {
                sale.endDate = [NSDate dateWithTimeInterval:10 sinceDate:[NSDate date]];
            } else if (index == 1) {
                sale.endDate = [NSDate dateWithTimeInterval:86430 sinceDate:[NSDate date]];
            }
        }
        
        index++;
        [tempMutableArray addObject:sale]; 
    }
    return [NSArray arrayWithArray:tempMutableArray];
}

- (void)loadSales:(NSDictionary*)salesData request:(AsyncRequestController *)request {
    self.mensSales = [self loadSales:salesData forKey:@"men"];
    self.womensSales = [self loadSales:salesData forKey:@"women"];
    self.allSales = [self loadSales:salesData forKey:@"all"];
}

- (void)loadSavedAddresses:(NSArray *)savedAddressesData request:(AsyncRequestController *)request {
    NSMutableArray *tempMutableArray = [NSMutableArray array];
    for (NSDictionary *savedAddressesDict in savedAddressesData) {
        SavedAddress *savedAddress = [[SavedAddress alloc] initFromDictionary:savedAddressesDict];
        [tempMutableArray addObject:savedAddress];
    }
    self.loginSession.addresses = tempMutableArray;
    self.loginSession.defaultShippingAddressIndex = [SavedAddress getIndexOfDefaultSavedAddressOfType:SavedAddressShipping inArray:tempMutableArray];
    self.loginSession.defaultBillingAddressIndex = [SavedAddress getIndexOfDefaultSavedAddressOfType:SavedAddressBilling inArray:tempMutableArray];
    
    SavedAddress *defaultShippingAddress = nil;
    if (self.loginSession.defaultShippingAddressIndex >= 0) {
        defaultShippingAddress = [tempMutableArray objectAtIndex:self.loginSession.defaultShippingAddressIndex];
    }
    
    SavedAddress *defaultBillingAddress = nil;
    if (self.loginSession.defaultBillingAddressIndex >= 0) {
        defaultBillingAddress = [tempMutableArray objectAtIndex:self.loginSession.defaultBillingAddressIndex];
    }
    
    [self.plndrPurchaseSession initializeShippingAddress:defaultShippingAddress.address billingAddress:defaultBillingAddress.address];
    
    self.loginSession.lastTimeSavedAddressesWereFetched = [NSDate date];
}

- (void)loadProducts:(NSArray *)productsData request:(AsyncRequestController *)request {
    SaleDetail *saleDetail = [self.saleIdToSaleDetail objectForKey:[request.userInfo objectForKey:@"saleId"]];
    BOOL isFetchingMore = ((NSNumber*)[request.userInfo objectForKey:@"isFetchingMore"]).boolValue;
    
    if (!isFetchingMore) {
        [saleDetail removeAllProducts];
    }

    //TODO 31045973: Remove all code surrounding the index variable (it's hardcoded data)
    int index = 0;
    for (NSDictionary *productDict in productsData) {
        Product *product = [[Product alloc] initFromDictionary:productDict];
        
        // This is testing code that causes the first and second products to expire shortly
        // Note that it only affects anything if we are pointed at staging.
        if (kUseStaginUrls) {
            if (index == 0) {
                product.availabilityEndDate = [NSDate dateWithTimeInterval:10 sinceDate:[NSDate date]];
            } else if (index == 1) {
                product.availabilityEndDate = [NSDate dateWithTimeInterval:86430 sinceDate:[NSDate date]];
            } 
        }

        index++;
        [self.productIdToProduct setObject:product forKey:product.productId];
        [saleDetail addProductId:product.productId];
    }
    if (index < kProductPageSize) {
        // Reached the end of the available data
        saleDetail.hasMoreProductsToFetch = NO;
    } else {
        saleDetail.hasMoreProductsToFetch = YES;
    }
    
    saleDetail.lastTimeProductsWereFetched = [NSDate date];
}

- (void)loadProductDetail:(NSDictionary*)productData request:(AsyncRequestController *)request {
    Product *product = [self getProduct:[request.userInfo objectForKey:@"productId"]];
    if (product) {
        [product loadDetailsFromProductDetailsDictionary:productData];
    }
    product.lastTimeProductDetailsWereFetched = [NSDate date];
}

- (NSArray*)grabCategorySizesFromDictionary:(NSDictionary*) filterDictionary {
    NSArray *sizeDictionaries = [NSArray arrayWithArray:[filterDictionary objectForKey:@"sizes"]];
    NSMutableArray *sizeObjects = [NSMutableArray array];
    for (NSDictionary *sizeDictionary in sizeDictionaries) {
        SaleFilterSize *size = [[SaleFilterSize alloc] initFromDictionary:sizeDictionary];
        [sizeObjects addObject:size];
    }
    return sizeObjects;
}

- (void)loadSaleCategories:(NSDictionary *)filterDictionary request:(AsyncRequestController *)request {
    // Parse the category dictionary
    NSMutableArray *mutableCategories = [NSMutableArray array];
    for (NSDictionary *categoryDict in [filterDictionary objectForKey:@"categories"]) {
        SaleFilterCategory *saleFilterCategory = [[SaleFilterCategory alloc] initFromDictionary:categoryDict];
        [mutableCategories addObject:saleFilterCategory];
    }
    
    // Get the sale for this category dictionary
    SaleDetail *saleDetail = [self.saleIdToSaleDetail objectForKey:[request.userInfo objectForKey:@"saleId"]];
    
    // Get the old size array, to apply to the new categories array
    NSArray *oldFilterCategories = saleDetail.filterCategories;
    NSArray *oldSizes;
    if (saleDetail.currentFilterCategoryIndex >= 1) { // Don't record old sizes for ALL (index 0) - we're going to get that back from this call anyway
        oldSizes = [((SaleFilterCategory*)[oldFilterCategories objectAtIndex:saleDetail.currentFilterCategoryIndex]) sizes];
    } else {
        oldSizes = nil;
    }
    
    // Set categories on the sale, and copy the returned sizes to the category All (the first category)
    saleDetail.filterCategories = [NSArray arrayWithArray:mutableCategories];
    if (saleDetail.filterCategories.count > 0) {
        SaleFilterCategory *category = [mutableCategories objectAtIndex:0];
        [category setSizes:[self grabCategorySizesFromDictionary:filterDictionary]];
    }
    
    // Update the selected category index (the number of categories may have changed - this may not be correct, but it will be safe)
    if (saleDetail.currentFilterCategoryIndex >= saleDetail.filterCategories.count) {
        if (saleDetail.filterCategories.count > 0) {
            saleDetail.currentFilterCategoryIndex = 0;
        } else {
            saleDetail.currentFilterCategoryIndex = -1;
        }
    }
    
    // Set the old sizes array to the new category
    if (oldSizes.count > 0) {
        [((SaleFilterCategory*)[saleDetail.filterCategories objectAtIndex:saleDetail.currentFilterCategoryIndex]) setSizes:oldSizes];
    }
}

- (void)loadCategorySizes:(NSDictionary *)filterDictionary request:(AsyncRequestController *)request {
    NSArray *sizeObjects = [self grabCategorySizesFromDictionary:filterDictionary];
    
    SaleFilterCategory *category = [self getCategoryForSaleId:[request.userInfo objectForKey:@"saleId"] categoryId:[request.userInfo objectForKey:@"categoryId"]];
    [category setSizes:[NSArray arrayWithArray:sizeObjects]];
    
    // Update the selected size
    SaleDetail *saleDetail = [self.saleIdToSaleDetail objectForKey:[request.userInfo objectForKey:@"saleId"]];
    if (saleDetail.currentFilterSizeIndex >= category.sizes.count) {
        if (category.sizes.count > 0) {
            saleDetail.currentFilterSizeIndex = 0;
        } else {
            saleDetail.currentFilterSizeIndex = -1;
        }
    }
}

- (void)doLoginWithAuthToken:(NSDictionary *)authTokenDictionary request:(AsyncRequestController *)request {
    [[ModelContext instance] loginSession].authToken = [authTokenDictionary objectForKey:@"token"];
    [[ModelContext instance] loginSession].username = [[request userInfo] objectForKey:@"email"];
    
    // Since we just logged in, destroy the signup session
    [ModelContext instance].signupSession = nil;
    
    // save to disk
    [self saveLoginSessionToDisk];
}

- (BOOL)loadCheckoutSummary:(NSDictionary *)checkoutSummaryDictionary request:(AsyncRequestController *)request {
    BOOL isIntermediateValidation = [[[request userInfo] objectForKey:@"isIntermediateValidation"] boolValue];
    CheckoutSummary *checkoutSummary = [[CheckoutSummary alloc] initFromDictionary:checkoutSummaryDictionary];
    
    NSMutableArray *tempErrorArray = [NSMutableArray array];
    for (NSDictionary *errorDictionary in [checkoutSummaryDictionary objectForKey:@"errors"]) {
        CheckoutError *checkoutError = [[CheckoutError alloc] initFromDictionary:errorDictionary];
        
        [tempErrorArray addObject:checkoutError];
    }
    
    if (isIntermediateValidation) {
        self.plndrPurchaseSession.intermediateCheckoutSummary = tempErrorArray.count == 0 ? checkoutSummary : nil;
        self.plndrPurchaseSession.intermediateCheckoutErrors = [NSArray arrayWithArray:tempErrorArray];
    } else {
        self.plndrPurchaseSession.checkoutSummary = tempErrorArray.count == 0 ? checkoutSummary : nil;
        self.plndrPurchaseSession.checkoutErrors = [NSArray arrayWithArray:tempErrorArray];
    }
    return tempErrorArray.count == 0;
}

- (BOOL)loadCheckoutComplete:(NSDictionary *)checkoutCompleteDictionary request:(AsyncRequestController *)request {
   
    NSMutableArray *tempErrorArray = [NSMutableArray array];
    for (NSDictionary *errorDictionary in [checkoutCompleteDictionary objectForKey:@"errors"]) {
        CheckoutError *checkoutError = [[CheckoutError alloc] initFromDictionary:errorDictionary];
        
        [tempErrorArray addObject:checkoutError];
    }
    
    self.plndrPurchaseSession.checkoutErrors = [NSArray arrayWithArray:tempErrorArray];
    
    self.plndrPurchaseSession.checkoutComplete = tempErrorArray.count == 0 ? [[CheckoutCompleteResponse alloc] initFromDictionary:checkoutCompleteDictionary] : nil;
    
    return (self.plndrPurchaseSession.checkoutErrors.count == 0);
}

- (void)loadCartStock:(NSArray *)cartStockData request:(AsyncRequestController *)request {
    NSMutableArray *tempMutableArray = [NSMutableArray array];
    for (NSDictionary *skuStockDict in cartStockData) {
        SkuStock *skuStock = [[SkuStock alloc] initFromDictionary:skuStockDict];
        [tempMutableArray addObject:skuStock];
    }
    [self updateCartItemWithSkuStocks:tempMutableArray];
}

#pragma mark - AsyncRequestDelegate

- (void)asyncRequest:(AsyncRequestController *)request didLoad:(id)result {
    APIRequestController *apiRequest = (APIRequestController*) request;
	RequestType requestType = apiRequest.requestType;
    
	//TODO error check on status code
	
	switch (requestType) {
        case ResendPassword:
        {
            // No parsing. Just fall through to inform subscription of success.
            if (apiRequest.statusCode != kHTTP_200_OK) {
                NSLog(@"ModelContext::asyncRequest: ResendPassword expected empty result with 200 status, got %@, Data: %@, status: %d", [result class], result, apiRequest.statusCode);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
		}
        case PostCheckoutOptions:
		{
            if ([result isKindOfClass:[NSDictionary class]]) {
                BOOL success = [self loadCheckoutOptions:result request:request];
                if (!success) {
                    [self asyncRequest:request didFailWithError:[self.plndrPurchaseSession.checkoutErrors objectAtIndex:0] result:result];
                    return;
                }
            } else {
                NSLog(@"ModelContext::asyncRequest: GetCheckoutOptions expected NSDictionary, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
			break;
		}
        case GetAccountDetails: {
            if ([result isKindOfClass:[NSDictionary class]]) {
                [self loadAccountDetails:result request:request];
            } else {
                NSLog(@"ModelContext::asyncRequest: GetAccountDetails expected NSDictionary, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        }
        case GetCountries:
		{
            if ([result isKindOfClass:[NSArray class]]) {
                [self loadCountries:result request:request];
            } else {
                NSLog(@"ModelContext::asyncRequest: GetCountries expected NSArray, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
			break;
		}
        case GetCreditCardOptions:
		{
            if ([result isKindOfClass:[NSArray class]]) {
                [self loadCreditCardOptions:result request:request];
            } else {
                NSLog(@"ModelContext::asyncRequest: GetCreditCardOptions expected NSArray, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
			break;
		}
		case GetSales:
		{
            if ([result isKindOfClass:[NSDictionary class]]) {
                [self loadSales:result request:request];
            } else {
                NSLog(@"ModelContext::asyncRequest: GetSales expected NSDictionary, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
			break;
		}
        case GetProducts:
        {
            if ([result isKindOfClass:[NSArray class]]) {
                [self loadProducts:result request:request];
            } else {
                NSLog(@"ModelContext::asyncRequest: GetProducts expected NSArray, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        }
        case GetProductDetail:
        {
            if ([result isKindOfClass:[NSDictionary class]]) {
                [self loadProductDetail:result request:request];
            } else {
                NSLog(@"ModelContext::asyncRequest: GetProductDetail expected NSDictionary, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        }
        case GetCategoryFilters:
        {
            if ([result isKindOfClass:[NSDictionary class]]) {
                [self loadSaleCategories:result request:request];
            } else {
                NSLog(@"ModelContext::asyncRequest: GetCategoryFilters expected NSDictionary, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        }
        case GetSizeFilters:
        {
            if ([result isKindOfClass:[NSDictionary class]]) {
                [self loadCategorySizes:result  request:request];
            } else {
                NSLog(@"ModelContext::asyncRequest: GetSizeFilters expected NSDictionary, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        }
        case GetSavedAddresses:
        {
            if (apiRequest.statusCode == kHTTP_200_OK || [result isKindOfClass:[NSArray class]]) {
                [self loadSavedAddresses:result  request:request];
            } else {
                NSLog(@"ModelContext::asyncRequest: GetSavedAddress expected NSArray, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        }
        case CreateSavedAddress:
        {
            if (apiRequest.statusCode == kHTTP_200_OK) {
                [self.loginSession resetAddressBook];
            } else {
                NSLog(@"ModelContext::asyncRequest: GetSavedAddress expected NSArray, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        }
        case PostLogin:
            if ([result isKindOfClass:[NSDictionary class]]) {
                [self doLoginWithAuthToken:result request:request];
            } else {
                NSLog(@"ModelContext::asyncRequest: PostLogin expected NSDictionary, got %@, Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        case PutChangePassword: {
            // No parsing. Just fall through to inform subscription of success.
            if (apiRequest.statusCode != kHTTP_200_OK) {
                NSLog(@"ModelContext::asyncRequest: PutChangePassword expected empty result with 200 status, got %@, Data: %@, status: %d", [result class], result, apiRequest.statusCode);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        }
        case PutUpdateSavedAddress: {
            if (apiRequest.statusCode == kHTTP_200_OK) {
                [self.loginSession resetAddressBook];
            } else {
                NSLog(@"ModelContext::asyncRequest: UpdateSavedAddress, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        }
        case PostSignup:
            if ([result isKindOfClass:[NSDictionary class]]) {
                [self doLoginWithAuthToken:result request:request];
            } else {
                NSLog(@"ModelContext::asyncRequest: PostSignup expected NSDictionary, got %@, Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        case PostCheckoutSummary:
            if ([result isKindOfClass:[NSDictionary class]]) {
                BOOL success = [self loadCheckoutSummary:result request:request];
                if (!success) {
                    BOOL isIntermediateValidation = [[[request userInfo] objectForKey:@"isIntermediateValidation"] boolValue];
                    NSArray *checkoutErrors = isIntermediateValidation ? self.plndrPurchaseSession.intermediateCheckoutErrors : self.plndrPurchaseSession.checkoutErrors;
                    [self asyncRequest:request didFailWithError:[checkoutErrors objectAtIndex:0] result:result];
                    return;
                }
            } else {
                NSLog(@"ModelContext::asyncRequest: PostCheckoutSummary expected NSDictionary, got %@, Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        case PostCheckoutComplete:
            if ([result isKindOfClass:[NSDictionary class]]) {
                BOOL success = [self loadCheckoutComplete:result request:request];
                if (!success) {
                    [self asyncRequest:request didFailWithError:[self.plndrPurchaseSession.checkoutErrors objectAtIndex:0] result:result];
                    return;
                }
            } else {
                NSLog(@"ModelContext::asyncRequest: PostCheckoutComplete expected NSDictionary, got %@, Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        case DeleteSavedAddress: {
            if (apiRequest.statusCode == kHTTP_200_OK) {
                [self.loginSession resetAddressBook];
            } else {
                NSLog(@"ModelContext::asyncRequest: DeleteSavedAddress, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        }
        case PostCartStock: {
            if (apiRequest.statusCode == kHTTP_200_OK) {
                [self loadCartStock:result request:request];
            } else {
                NSLog(@"ModelContext::asyncRequest: PostCartStock expected NSArray, got %@. Data: %@", [result class], result);
                [self asyncRequest:request didFailWithError:nil result:result];
                return;
            }
            break;
        }
		default:
            NSLog(@"Error!! Unexpected request type: %@", request);
			break;
	}
    
	[SubscriptionManager informSubscriptionsOfSuccess:request];
}


- (void)asyncRequest:(AsyncRequestController *)request didFailWithError:(NSError *)error result:(NSObject*)result{
    int statusCode = ((APIRequestController*)request).statusCode;
    NSLog(@"Network request failed for %@, statusCode = %d", error, statusCode); 
    
    NSObject *failureResult = result;
    if (statusCode == kHTTP_401_ERROR_AuthTokn) {
        failureResult = [NSError errorWithDomain:@"" code:kHTTP_401_ERROR_AuthTokn userInfo:nil];
    } else if([error isKindOfClass:[NSError class]] && (NSInteger)error.code == kHTTP_ERROR_NoConnection) {
        failureResult = [NSError errorWithDomain:@"" code:kHTTP_ERROR_NoConnection userInfo:nil];   
    }
    [SubscriptionManager informSubscriptionsOfFailure:request result:failureResult];
}



@end
