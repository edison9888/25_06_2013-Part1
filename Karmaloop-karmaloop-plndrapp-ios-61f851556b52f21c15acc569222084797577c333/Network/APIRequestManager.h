#import <Foundation/Foundation.h>
#import "Address.h"
#import "SavedAddress.h"

typedef enum {
	Nothing,
    GetSales,
    GetProducts,
    GetProductDetail,
    GetCategoryFilters,
    GetSizeFilters,
    PostLogin,
    PutChangePassword,
    PostSignup,
    GetCountries,
    PostCheckoutOptions,
    ResendPassword,
    PostCheckoutSummary,
    PostCheckoutComplete,
    GetAccountDetails,
    GetSavedAddresses,
    CreateSavedAddress,
    PutUpdateSavedAddress,
    DeleteSavedAddress,
    GetCreditCardOptions,
    PostCartStock
} RequestType;

typedef enum {
    HTTPPut,
    HTTPPost,
    HTTPDelete
}HTTPVerb;

@protocol AsyncRequestDelegate;

@class APIRequestController, ShippingDetails;

@interface APIRequestManager : NSObject {
	NSMutableArray *_requests;
	
	// APIRequestController objects that aren't to be started until the network is idle
	NSMutableArray *_queuedRequests;
    
    // synchronize
    BOOL _isResetting;
}

+ (APIRequestManager*) sharedInstance;

- (void) reset;

- (int)getNumberOfRequests;
- (void)removeRequest:(APIRequestController*)req;
- (void)removeDelegate:(id)theDelegate;
- (BOOL)isRequestAuthenticated:(RequestType)request;

// Plndr API calls
- (APIRequestController*) requestPasswordWithEmail:(NSString *)email  delegate:(id)delegate;
- (APIRequestController*) requestCheckoutOptionsWithAddress:(Address*)address cartItems:(NSArray*)cartItems delegate:(id)delegate;
- (APIRequestController*) requestAccountDetailsWithDelegate:(id)delegate;
- (APIRequestController*) requestCountriesWithDelegate:(id)delegate;
- (APIRequestController*) requestSalesWithDelegate:(id)delegate;
- (APIRequestController*) requestProductsWithSaleId:(NSNumber*)saleId categoryId:(NSString*)categoryId sizeValue:(NSString*)sizeValue genderCategoryString:(NSString*)genderCategoryString page:(int)page delegate:(id)delegate;
- (APIRequestController*) requestProductDetailWithProductId:(NSNumber*)productId delegate:(id)delegate;
- (APIRequestController*) requestCategoryFiltersWithSaleId:(NSNumber*)saleId genderCategoryString:(NSString*)genderCategoryString delegate:(id)delegate;
- (APIRequestController*) requestSizeFiltersWithSaleId:(NSNumber*)saleId categoryId:(NSString*)categoryId genderCategoryString:(NSString*)genderCategoryString delegate:(id)delegate;
- (APIRequestController*) postLoginUsername:(NSString*)username password:(NSString*)password delegate:(id)delegate;
- (APIRequestController*) postSignUpWithEmail:(NSString*)email withPassword:(NSString*)password withConfirmPassword:(NSString*)confirmpassword withFirstName:(NSString*) firstname withLastName:(NSString*) lastname delegate:(id)delegate ;
- (APIRequestController*) putChangePassword:(NSString*)oldPassword neuePassword:(NSString *) neuePassword confirmPassword:(NSString*)confirmPassword delegate:(id)delegate;
- (APIRequestController*) postCheckoutSummaryWithDiscounts:(NSArray*)discounts shippingDetails:(ShippingDetails*)shippingDetails isIntermediateValidation:(BOOL)isIntermediateValidation delegate:(id)delegate;
- (APIRequestController*) postCheckoutCompleteWithDelegate:(id)delegate;
- (APIRequestController*) requestSavedAddressesWithDelegate:(id)delegate;
- (APIRequestController*) postCreateSavedAddressesWithAddress:(Address*)address name:(NSString*)name isPrimary:(NSNumber*)isPrimary type:(NSString*)type delegate:(id)delegate;
- (APIRequestController*) putUpdateSavedAddress:(SavedAddress*)savedAddress delegate:(id)delegate;
- (APIRequestController*) deleteSavedAddressWithSavedAddressId:(NSNumber*)savedAddressId  delegate:(id)delegate;
- (APIRequestController*) requestCreditCardOptionsWithDelegate:(id)delegate;
- (APIRequestController*) postCartStockSubscriptionWithDelegate:(id)delegate;

- (BOOL) hasOutstandingRequests;

// Store in UserDefaults the current time when a network request successfully completes
+ (void) updateLastConnectionTime;

@end

