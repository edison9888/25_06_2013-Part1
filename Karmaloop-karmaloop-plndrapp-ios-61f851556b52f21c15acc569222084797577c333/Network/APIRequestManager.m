#import "APIRequestManager.h"
#import "Constants.h"
#import "Utility.h"
#import "APIRequestController.h"
#import "ModelContext.h"
#import "NSString+HTML.h"
#import "LoginSession.h"
#import "SBJsonWriter.h"
#import "CartItem.h"
#import "ProductSku.h"
#import "PlndrPurchaseSession.h"
#import "ShippingDetails.h"
#import "DiscountCode.h"
#import "NSNumber+JSON.h"

@interface APIRequestManager ()

- (APIRequestController*) getFromURL:(NSString*)url withParameters:(NSDictionary*)parameters delegate:(id)theDelegate requestType: (RequestType)requestType startImmediately:(BOOL)immediately;
- (APIRequestController*) postToURL:(NSString*)url withParameters:(NSDictionary*)parameters delegate:(id)theDelegate requestType: (RequestType)requestType startImmediately:(BOOL)immediately;
- (APIRequestController*) putToURL:(NSString*)url withParamaters:(NSDictionary*)parameters delegate:(id)theDelegate requestType: (RequestType)requestType startImmediately:(BOOL)immediately;
- (APIRequestController*) deleteToURL:(NSString*)url withParamaters:(NSDictionary*)parameters delegate:(id)theDelegate requestType: (RequestType)requestType startImmediately:(BOOL)immediately;

- (APIRequestController*) sendToURL:(NSString*)url withParameters:(NSDictionary*)paramaters delegate:(id)theDelegate requestType: (RequestType)requestType startImmediately:(BOOL)immediately httpVerb:(HTTPVerb)httpVerb;

- (APIRequestController*) startConnectionWithRequest: (NSMutableURLRequest*) theRequest requestType: (RequestType) requestType delegate: (id) theDelegate startImmediately:(BOOL)immediately;

- (NSData*)jsonDataWithParamDictionary:(NSDictionary*)parameters;
//- (NSData*)dataWithParams:(NSDictionary *)dictionary;
- (NSString*)urlWithParams:(NSDictionary *)dictionary andUrl: (NSString*) url;
- (void) cancelAllRequestsOfType:(RequestType) isDoing;

// API endpoints
- (NSString*) getPlndrDomain;

- (NSString*) getPlndrCheckoutOptionsUrl;
- (NSString*) getPlndrCheckoutSummaryUrl;
- (NSString*) getPlndrCheckoutCompleteUrl;
- (NSString*) getPlndrCartStockUrl;
- (NSString*) getPlndrCountriesUrl;
- (NSString*) getPlndrSalesUrl;
- (NSString*) getPlndrProductsUrl;
- (NSString*) getPlndrSaleCategoriesUrl;
- (NSString*) getPlndrProductDetailUrl;
- (NSString*) getPlndrLoginUrl;
- (NSString*) getPlndrForgotPasswordUrl;
- (NSString*) getPlndrAccountUrl;
- (NSString*) getPlndrAddressBookUrl;
- (NSString*) getPlndrAddressBookUrlForDelete;
- (NSString*) getPlndrCreditCardOptionUrl;

@end


@implementation APIRequestManager

static NSString * const kPlndrStagingDomain =           @"api.karmaloop.com";//staging.api.karmaloop.com
static NSString * const kPlndrProductionDomain =        @"api.karmaloop.com";
static NSString * const kHTTP =                         @"http://";
static NSString * const kHTTPS =                        @"https://";

static NSString * const kPlndrCheckoutOptionsUrl =       @"/plndr/checkout/options";
static NSString * const kPlndrCheckoutSummaryUrl =       @"/plndr/checkout/summary";
static NSString * const kPlndrCheckoutCompleteUrl =      @"/plndr/checkout";
static NSString * const kPlndrCartStockUrl =             @"/plndr/checkout/cart-stock";
static NSString * const kPlndrCountriesUrl =             @"/plndr/shipping/countries";
static NSString * const kPlndrSalesUrl =                 @"/plndr/home";
static NSString * const kPlndrProductsUrl =              @"/plndr/sales/%d/products";
static NSString * const kPlndrSaleCategoriesUrl =        @"/plndr/sales/%d/filters";
static NSString * const kPlndrProductDetailUrl =         @"/plndr/products/%d";
static NSString * const kPlndrLoginUrl =                 @"/plndr/login";
static NSString * const kPlndrForgotPasswordUrl =        @"/plndr/account/resend-password";
static NSString * const kPlndrAccountUrl =               @"/plndr/account";
static NSString * const kPlndrAddressBookUrl =           @"/plndr/account/address-book";
static NSString * const kPlndrAddressBookUrlForDelete =  @"/plndr/account/address-book/%d";
static NSString * const kPlndrCreditCardOptionUrl =      @"/plndr/checkout/credit-card-options";

static APIRequestManager *shared;

+(APIRequestManager*) sharedInstance {
	@synchronized(shared) {		
		if (shared == nil) {
			shared = [[APIRequestManager alloc] init];			
		}
	}
	return shared;	
}

- (id)init{
	if((self = [super init])){
		_requests = [[NSMutableArray alloc] init];
		_queuedRequests = [[NSMutableArray alloc] init];
        _isResetting = NO; // This flag combined with @synchronized's fixes a crash when online->offline while requests are still being processed/requested.
        
	}
	return self;
}

- (void) reset {
    _isResetting = YES;
    
    @synchronized(_requests) {
        for (APIRequestController *req in _requests) {
            req.cancel = YES;
        }
        [_requests removeAllObjects];
	}
    	
	for (APIRequestController *req in _queuedRequests) {
		req.cancel = YES;
	}
	[_queuedRequests removeAllObjects];
	    
    _isResetting = NO;
}

- (void) removeDelegate:(id)theDelegate {
    if (_isResetting == NO){ 
        @synchronized(_requests) {
            for ( APIRequestController *req in _requests ) {
                if ( req.delegate == theDelegate ) {
                    req.delegate = nil;
                    req.cancel = YES;
                }
            }
        }
    }
}

- (BOOL)isRequestAuthenticated:(RequestType)request {
    switch (request) {
        case PostCheckoutSummary:
        case PostCheckoutComplete:
        case PutChangePassword:
        case PostCheckoutOptions:
        case GetAccountDetails:
        case GetSavedAddresses:
        case CreateSavedAddress:
        case PutUpdateSavedAddress:
        case DeleteSavedAddress:
            return YES;
        default:
            return NO;
    }
}

- (void) removeRequest:(APIRequestController*)req {	
    if (_isResetting == NO){ 
        @synchronized(_requests) {
            req.cancel = YES;
            [_requests removeObject:req];
        }
        if ([self getNumberOfRequests] == 0) {
            // Try starting a queued connection
            if ([_queuedRequests count] > 0) {
                APIRequestController *req = [_queuedRequests objectAtIndex:0];
                [req.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                [req.connection start];
                
                @synchronized(_requests) {
                    [_requests addObject:req];
                }
                [_queuedRequests removeObject:req];
            }
        }
//        [[UIApplication sharedApplication] updateNetworkActivityIndicator];
    }
}

- (int) getNumberOfRequests {
    if (_isResetting == NO){ 
        @synchronized(_requests) {
            return _requests.count;
        }
    }
    return 0;
}

- (void) cancelAllRequestsOfType: (RequestType) isDoing {
    if (_isResetting == NO){ 
        @synchronized(_requests) {
            for (APIRequestController* req in [NSArray arrayWithArray: _requests]) {
                if (req.requestType == isDoing) {
                    [self removeRequest:req];
                }
            }
        }
//        [[UIApplication sharedApplication] updateNetworkActivityIndicator];
    }
}

#pragma mark -
#pragma mark Parameter Methods

- (NSData *)jsonDataWithParamDictionary:(NSDictionary *)parameters {
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString* jsonString = [jsonWriter stringWithObject:parameters];
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

//- (NSData*)dataWithParams:(NSDictionary *)dictionary {
//	NSMutableArray *postArray = [[NSMutableArray alloc] init];
//	for(id key in dictionary) {
//		[postArray addObject:[NSString stringWithFormat:@"%@=%@", key, [dictionary objectForKey:key]]];
//	}
//	NSString *postString = [postArray componentsJoinedByString:@"&"];
//	return [postString dataUsingEncoding:NSUTF8StringEncoding];
//}

- (NSString*)urlWithParams:(NSDictionary *)dictionary andUrl: (NSString*) url {
	NSString *separator = nil;
    NSString *urlString = [NSString stringWithString:url]; 
    for(id key in dictionary) {
        separator = (separator == nil) ? @"?" : @"&";
		urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@%@=%@", separator, key, [dictionary objectForKey:key]]];
	}
	return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - API enpoints

- (NSString*) getPlndrDomain {
    return kUseStaginUrls ? kPlndrStagingDomain : kPlndrProductionDomain;
}

- (NSString*) getPlndrCheckoutOptionsUrl {
    return [NSString stringWithFormat:@"%@%@%@", kHTTPS, [self getPlndrDomain], kPlndrCheckoutOptionsUrl];
}

- (NSString*) getPlndrCheckoutSummaryUrl {
    return [NSString stringWithFormat:@"%@%@%@", kHTTPS, [self getPlndrDomain], kPlndrCheckoutSummaryUrl];
}

- (NSString*) getPlndrCheckoutCompleteUrl {
    return [NSString stringWithFormat:@"%@%@%@", kHTTPS, [self getPlndrDomain], kPlndrCheckoutCompleteUrl];
}

- (NSString*) getPlndrCartStockUrl {
    return [NSString stringWithFormat:@"%@%@%@", kHTTPS, [self getPlndrDomain], kPlndrCartStockUrl];
}

- (NSString*) getPlndrCountriesUrl {
    return [NSString stringWithFormat:@"%@%@%@", kHTTP, [self getPlndrDomain], kPlndrCountriesUrl];
}

- (NSString*) getPlndrSalesUrl {
    return [NSString stringWithFormat:@"%@%@%@", kHTTP, [self getPlndrDomain], kPlndrSalesUrl];
}

- (NSString*) getPlndrProductsUrl {
    return [NSString stringWithFormat:@"%@%@%@", kHTTP, [self getPlndrDomain], kPlndrProductsUrl];
}

- (NSString*) getPlndrSaleCategoriesUrl {
    return [NSString stringWithFormat:@"%@%@%@", kHTTP, [self getPlndrDomain], kPlndrSaleCategoriesUrl];
}

- (NSString*) getPlndrProductDetailUrl; {
    return [NSString stringWithFormat:@"%@%@%@", kHTTP, [self getPlndrDomain], kPlndrProductDetailUrl];
}

- (NSString*) getPlndrLoginUrl {
    return [NSString stringWithFormat:@"%@%@%@", kHTTPS, [self getPlndrDomain], kPlndrLoginUrl];
}

- (NSString*) getPlndrForgotPasswordUrl {
    return [NSString stringWithFormat:@"%@%@%@", kHTTPS, [self getPlndrDomain], kPlndrForgotPasswordUrl];
}

- (NSString*) getPlndrAccountUrl {
    return [NSString stringWithFormat:@"%@%@%@", kHTTPS, [self getPlndrDomain], kPlndrAccountUrl];
}

- (NSString*) getPlndrAddressBookUrl {
    return [NSString stringWithFormat:@"%@%@%@", kHTTPS, [self getPlndrDomain], kPlndrAddressBookUrl];
}

- (NSString*) getPlndrAddressBookUrlForDelete {
    return [NSString stringWithFormat:@"%@%@%@", kHTTPS, [self getPlndrDomain], kPlndrAddressBookUrlForDelete];
}

- (NSString*) getPlndrCreditCardOptionUrl {
    return [NSString stringWithFormat:@"%@%@%@", kHTTP, [self getPlndrDomain], kPlndrCreditCardOptionUrl];
}

#pragma mark -
#pragma mark GET and POST Helpers

- (APIRequestController*) getFromURL:(NSString*)url withParameters:(NSDictionary*)parameters delegate:(id)theDelegate requestType: (RequestType)requestType startImmediately:(BOOL)immediately {
	NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:parameters];	
	NSString *requestUrl = [self urlWithParams:mutableParams andUrl:url];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: requestUrl]];
	if ([self isRequestAuthenticated:requestType]) {
        [request setValue:[[ModelContext instance] loginSession].authToken forHTTPHeaderField:@"X-KL-Authorize"];
    }
	NSLog(@"Get request with URL: %@", requestUrl);
	return [self startConnectionWithRequest:request requestType:requestType delegate:theDelegate startImmediately:immediately];
}

- (APIRequestController*) postToURL:(NSString*)url withParameters:(NSDictionary*)parameters delegate:(id)theDelegate requestType: (RequestType)requestType startImmediately:(BOOL)immediately {
    return [self sendToURL:url withParameters:parameters delegate:theDelegate requestType:requestType startImmediately:immediately httpVerb:HTTPPost];
}

- (APIRequestController*) putToURL:(NSString *)url withParamaters:(NSDictionary *)parameters delegate:(id)theDelegate requestType:(RequestType)requestType startImmediately:(BOOL)immediately {
    return [self sendToURL:url withParameters:parameters delegate:theDelegate requestType:requestType startImmediately:immediately httpVerb:HTTPPut];
}

- (APIRequestController*) deleteToURL:(NSString *)url withParamaters:(NSDictionary *)parameters delegate:(id)theDelegate requestType:(RequestType)requestType startImmediately:(BOOL)immediately {
    return [self sendToURL:url withParameters:parameters delegate:theDelegate requestType:requestType startImmediately:YES httpVerb:HTTPDelete];
}

- (APIRequestController *)sendToURL:(NSString *)url withParameters:(NSDictionary*)paramaters delegate:(id)theDelegate requestType:(RequestType)requestType startImmediately:(BOOL)immediately httpVerb:(HTTPVerb)httpVerb {	
	NSString *requestUrl = [self urlWithParams:nil andUrl:url];
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	[request setTimeoutInterval:10];
	
    NSData *postData = [self jsonDataWithParamDictionary:paramaters];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    switch (httpVerb) {
        case HTTPPost: {
            [request setHTTPMethod:@"POST"];
            break;
        }
        case HTTPPut: {
            [request setHTTPMethod:@"PUT"];
             break;
          }             
        case HTTPDelete: {
            [request setHTTPMethod:@"DELETE"];
             break;
           }
            
        default:
            break;
    }
    // Apperently this is necessary for PUT to work... but we also need application/json
    // So, if ever PUT doesn't seem to work, investigate this further
    // [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if ([self isRequestAuthenticated:requestType]) {
        [request setValue:[[ModelContext instance] loginSession].authToken forHTTPHeaderField:@"X-KL-Authorize"];
    }
    
    [request setHTTPBody:postData];
    
    NSLog(@"%@ request with URL: %@", [request HTTPMethod], requestUrl);
	return [self startConnectionWithRequest:request requestType:requestType delegate:theDelegate startImmediately:immediately];
}

- (APIRequestController*) startConnectionWithRequest: (NSMutableURLRequest*) theRequest requestType: (RequestType)requestType delegate: (id) theDelegate startImmediately:(BOOL)immediately {
	APIRequestController *rc = [[APIRequestController alloc] initWithOwner:self];
	rc.delegate = theDelegate;

    [theRequest setValue:[Utility userAgentString] forHTTPHeaderField:@"User-Agent"];
    
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:rc startImmediately:NO];
	
	if (connection) {
		rc.connection = connection;
		rc.requestType = requestType;
        
        @synchronized(_requests) {
            if (immediately || [_requests count] == 0) {
                    [_requests addObject:rc];
                [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
                [connection start];
                
            } else {
                // Queue the request to be started on idle
                [_queuedRequests addObject:rc];
            }
        }
		
//		[[UIApplication sharedApplication] updateNetworkActivityIndicator];
	}
	
	return rc;
}


#pragma mark -
#pragma mark Plndr API Methods

- (APIRequestController *)requestPasswordWithEmail:(NSString *)email  delegate:(id)delegate {
    NSDictionary *bodyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Utility safeStringWithString:email], @"email",
                                    nil];
    
    APIRequestController *request = [self postToURL:[self getPlndrForgotPasswordUrl] withParameters:bodyDictionary delegate:delegate requestType:ResendPassword startImmediately:YES];
    return request;
}

- (APIRequestController *)requestCheckoutOptionsWithAddress:(Address*)address cartItems:(NSArray*)cartItems delegate:(id)delegate {
    NSDictionary *bodyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [address getAPIDictionary], @"shippingAddress",
                                    [[ModelContext instance] getCartItemsForAPI], @"cart",
                                    nil];

    APIRequestController *request = [self postToURL:[self getPlndrCheckoutOptionsUrl] withParameters:bodyDictionary delegate:delegate requestType:PostCheckoutOptions startImmediately:YES];
    return request;
}

- (APIRequestController *)requestAccountDetailsWithDelegate:(id)delegate {
    APIRequestController *request = [self getFromURL:[self getPlndrAccountUrl] withParameters:nil delegate:delegate requestType:GetAccountDetails startImmediately:YES];
    return request;
}

- (APIRequestController*) requestSavedAddressesWithDelegate:(id)delegate {
    APIRequestController *request = [self getFromURL:[self getPlndrAddressBookUrl] withParameters:nil delegate:delegate requestType:GetSavedAddresses startImmediately:YES];
    return request;    
}

- (APIRequestController *)requestCreditCardOptionsWithDelegate:(id)delegate {
    APIRequestController *request = [self getFromURL:[self getPlndrCreditCardOptionUrl] withParameters:nil delegate:delegate requestType:GetCreditCardOptions startImmediately:YES];
    return request;
}

- (APIRequestController *)requestCountriesWithDelegate:(id)delegate {
    APIRequestController *request = [self getFromURL:[self getPlndrCountriesUrl] withParameters:nil delegate:delegate requestType:GetCountries startImmediately:YES];
    return request;
}

- (APIRequestController *)requestSalesWithDelegate:(id)delegate {
    APIRequestController *request = [self getFromURL:[self getPlndrSalesUrl] withParameters:nil delegate:delegate requestType:GetSales startImmediately:YES];
    return request;
}

- (APIRequestController*) requestProductsWithSaleId:(NSNumber*)saleId categoryId:(NSString*)categoryId sizeValue:(NSString*)sizeValue genderCategoryString:(NSString*)genderCategoryString page:(int)page delegate:(id)delegate {
    NSMutableDictionary *parameters = nil;
    
    parameters = [[NSMutableDictionary alloc] init];
    
    if (categoryId.length > 0) {
        [parameters setObject:categoryId forKey:@"subcategory"];
    }
    
    if (sizeValue.length > 0) {
        [parameters setObject:sizeValue forKey:@"size"];
    }
    
    if (genderCategoryString.length > 0) {
        [parameters setObject:genderCategoryString forKey:@"gender"];
    }
    
    [parameters setObject:[NSString stringWithFormat:@"%d", page*kProductPageSize] forKey:@"$skip"];
    [parameters setObject:[NSString stringWithFormat:@"%d", kProductPageSize] forKey:@"$top"];
   
    NSString *productUrl = [self getPlndrProductsUrl];
    APIRequestController *request = [self getFromURL:[NSString stringWithFormat:productUrl, [saleId intValue]] withParameters:parameters delegate:delegate requestType:GetProducts startImmediately:YES];
    [request.userInfo setObject:saleId forKey:@"saleId"];
    [request.userInfo setObject:[NSNumber numberWithBool:page > 0] forKey:@"isFetchingMore"];
    
    return request;
}

- (APIRequestController *)requestProductDetailWithProductId:(NSNumber *)productId delegate:(id)delegate   {
    APIRequestController *request = [self getFromURL:[NSString stringWithFormat:[self getPlndrProductDetailUrl], [productId intValue]] withParameters:nil delegate:delegate requestType:GetProductDetail startImmediately:YES];
    [request.userInfo setObject:productId forKey:@"productId"];
    return request;
}

- (APIRequestController *)requestCategoryFiltersWithSaleId:(NSNumber *)saleId genderCategoryString:(NSString*)genderCategoryString delegate:(id)delegate {
    
    NSDictionary *parameters = nil;
    if (genderCategoryString.length > 0) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:genderCategoryString, @"gender", nil];
    }
    
    APIRequestController *request = [self getFromURL:[NSString stringWithFormat:[self getPlndrSaleCategoriesUrl], [saleId intValue]] withParameters:parameters delegate:delegate requestType:GetCategoryFilters startImmediately:YES];
    [request.userInfo setObject:saleId forKey:@"saleId"];
    return request;
}

- (APIRequestController *)requestSizeFiltersWithSaleId:(NSNumber *)saleId categoryId:(NSString *)categoryId genderCategoryString:(NSString*)genderCategoryString delegate:(id)delegate {
    
    NSMutableDictionary *parameters = nil;
    
    if (categoryId.length > 0 || genderCategoryString.length > 0) {
        parameters = [[NSMutableDictionary alloc] init];
        
        if (categoryId.length > 0) {
            [parameters setObject:categoryId forKey:@"subcategory"];
        }
        
        if (genderCategoryString.length > 0) {
            [parameters setObject:genderCategoryString forKey:@"gender"];
        }
    }
    
    APIRequestController *request = [self getFromURL:[NSString stringWithFormat:[self getPlndrSaleCategoriesUrl], [saleId intValue]] withParameters:parameters delegate:delegate requestType:GetSizeFilters startImmediately:YES];
    [request.userInfo setObject:saleId forKey:@"saleId"];
    [request.userInfo setObject:categoryId forKey:@"categoryId"];
    return request;
}

- (APIRequestController *)postLoginUsername:(NSString *)username password:(NSString *)password delegate:(id)delegate {
    if (username.length > 0) {
        if (!(password.length > 0)) {
            password = @"";
        }
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[username stringByEncodingHTMLEntities], @"username", [password stringByEncodingHTMLEntities], @"password", nil];
        APIRequestController *request = [self postToURL:[self getPlndrLoginUrl] withParameters:parameters delegate:delegate requestType:PostLogin startImmediately:YES];
        
        [request.userInfo setObject:[Utility safeStringWithString:username] forKey:@"email"];
        return request;
    }
    return nil;
}

- (APIRequestController *) postSignUpWithEmail:(NSString *)email withPassword:(NSString *)password withConfirmPassword:(NSString *)confirmpassword withFirstName:(NSString *)firstname withLastName:(NSString *)lastname delegate:(id)delegate {
    
    // API currently requires a shipping dictionary. Pass it in.
    NSDictionary *shippingDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Utility safeStringWithString:firstname], @"FirstName",
                                        [Utility safeStringWithString:lastname], @"LastName",
                                        @"", @"Attention",
                                        @"", @"Address1",
                                        @"", @"City",
                                        @"", @"State",
                                        @"", @"Country",
                                        @"", @"Postal Code",
                                        @"", @"Phone",
                                        nil];
                                         
    NSDictionary *bodyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Utility safeStringWithString:email], @"email",
                                    [Utility safeStringWithString:password], @"password",
                                    [Utility safeStringWithString:confirmpassword], @"passwordconfirm",
                                    shippingDictionary, @"shipping",
                                    nil];
    
    APIRequestController *request = [self postToURL:[self getPlndrAccountUrl] withParameters:bodyDictionary delegate:delegate requestType:PostSignup startImmediately:YES];
    
    [request.userInfo setObject:[Utility safeStringWithString:email] forKey:@"email"];
    return request;
}

- (APIRequestController *)postCreateSavedAddressesWithAddress:(Address *)address name:(NSString *)name isPrimary:(NSNumber *)isPrimary type:(NSString *)type delegate:(id)delegate {
    NSDictionary *bodyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [address getAPIDictionary], @"address",
                                    [Utility safeStringWithString:name], @"name",
                                    [isPrimary jsonBoolValue], @"isPrimary",
                                    [Utility safeStringWithString:type], @"type",
                                    nil];
    APIRequestController *request = [self postToURL:[self getPlndrAddressBookUrl] withParameters:bodyDictionary delegate:delegate requestType:CreateSavedAddress startImmediately:YES];
    return  request;
}


- (APIRequestController *)putChangePassword:(NSString *)oldPassword neuePassword:(NSString *)neuePassword confirmPassword:(NSString *)confirmPassword delegate:(id)delegate {
    if (oldPassword.length > 0 && neuePassword.length > 0 && confirmPassword.length > 0) {
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:oldPassword, @"originalPassword", neuePassword, @"newPassword", confirmPassword, @"newPasswordConfirm", nil];
        APIRequestController *request = [self putToURL:[self getPlndrAccountUrl] withParamaters:parameters delegate:delegate requestType:PutChangePassword startImmediately:YES];
        return request; 
    }
    return nil;
}

- (APIRequestController*)putUpdateSavedAddress:(SavedAddress *)savedAddress delegate:(id)delegate {
    if ([savedAddress.address isComplete]) {
        APIRequestController *request = [self putToURL:[self getPlndrAddressBookUrl] withParamaters:[savedAddress getAPIDictionary] delegate:delegate requestType:PutUpdateSavedAddress startImmediately:YES];
        return request;
    }
    return nil;
}

- (APIRequestController*) deleteSavedAddressWithSavedAddressId:(NSNumber *)savedAddressId delegate:(id)delegate {
    APIRequestController *request = [self deleteToURL:[NSString stringWithFormat:[self getPlndrAddressBookUrlForDelete], [savedAddressId intValue]] withParamaters:nil delegate:delegate requestType:DeleteSavedAddress startImmediately:YES];
    return request;
}

- (APIRequestController*) postCheckoutSummaryWithDiscounts:(NSArray*)discounts shippingDetails:(ShippingDetails*) shippingDetails isIntermediateValidation:(BOOL)isIntermediateValidation delegate:(id)delegate {
    
    NSDictionary *bodyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"english", @"culture",
                                    [[ModelContext instance] getCartItemsForAPI],   @"cart",
                                    [DiscountCode getAPIDiscountsFromDiscountCodes:discounts], @"discounts",
                                    [shippingDetails getAPIDictionary], @"shipping",
                                    nil];
    
    APIRequestController *request = [self postToURL:[self getPlndrCheckoutSummaryUrl] withParameters:bodyDictionary delegate:delegate requestType:PostCheckoutSummary startImmediately:YES];
    [request.userInfo setObject:[NSNumber numberWithBool:isIntermediateValidation] forKey:@"isIntermediateValidation"];
    return request;
}

- (APIRequestController*) postCheckoutCompleteWithDelegate:(id)delegate {
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [[[ModelContext instance] plndrPurchaseSession].purchaseBillingAddress getAPIDictionary], @"billing",
                                    @"english", @"culture",
                                    [[ModelContext instance] getCartItemsForAPI],   @"cart",
                                    [[[ModelContext instance] plndrPurchaseSession] getPaymentAPIDictionary], @"payment",
                                    [[[[ModelContext instance] plndrPurchaseSession] getShippingDetails] getAPIDictionary], @"shipping",
                                    [[NSNumber numberWithBool:kTestPurchase] jsonBoolValue], @"isTest",
                                    nil];
    
    NSArray *discounts = [[[ModelContext instance] plndrPurchaseSession] getDiscounts];
    if (discounts.count > 0) {
        [bodyDictionary setObject:[DiscountCode getAPIDiscountsFromDiscountCodes:discounts] forKey:@"discounts"];
    }
    
    // Note: giftCertificate is deliberately omitted. It is a poorly named API endpoint.
    // If the app ever supports purchasing gift Certificates (think iTunes gift cards), then we'll use this endpoint.
    // It is NOT for discounts.
    
    APIRequestController *request = [self postToURL:[self getPlndrCheckoutCompleteUrl] withParameters:bodyDictionary delegate:delegate requestType:PostCheckoutComplete startImmediately:YES];
    return request;
}

- (APIRequestController *)postCartStockSubscriptionWithDelegate:(id)delegate {
    NSMutableArray *skuIds = [NSMutableArray array];
    for (CartItem *cartItem in [[ModelContext instance] cartItems]) {
        [skuIds addObject:cartItem.size.skuId];
    }
    NSMutableDictionary *bodyDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           skuIds, @"skuIds",
                                           nil];
    APIRequestController *request = [self postToURL:[self getPlndrCartStockUrl] withParameters:bodyDictionary delegate:delegate requestType:PostCartStock startImmediately:YES];
    return request;
}


- (BOOL) hasOutstandingRequests {
    if (_isResetting == NO){ 
        int rCount;
        @synchronized(_requests) {
            rCount = [_requests count];
        }
        return rCount > 0 || [_queuedRequests count] > 0;
    }
    return NO;
}

#pragma mark -
#pragma mark Online Time Saving Methods

+ (void) updateLastConnectionTime {
	@synchronized([NSUserDefaults standardUserDefaults]) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastConnectionTimeKey];
		// Don't synchronize. If this doesn't get to disk occasionally, that shouldn't cause any problems
	}
}


#pragma mark -


@end
