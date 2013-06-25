/*
 * Copyright 2009 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

#import "FBSession.h"
#import "FBRequest.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark global

static NSString* kAPIRestURL = @"http://api.facebook.com/restserver.php";
static NSString* kAPIRestSecureURL = @"https://api.facebook.com/restserver.php";

static const int kMaxBurstRequests = 3;
static const NSTimeInterval kBurstDuration = 2;

static FBSession* sharedSession = nil;

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation FBSession

@synthesize delegates = _delegates, apiKey = _apiKey, apiSecret = _apiSecret,
  getSessionProxy = _getSessionProxy, uid = _uid, userName = _userName, sessionKey = _sessionKey,
  sessionSecret = _sessionSecret, expirationDate = _expirationDate;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark class public

+ (FBSession*)session {
  return sharedSession;
}

+ (void)setSession:(FBSession*)session {
  sharedSession = session;
}

+ (FBSession*)sessionForApplication:(NSString*)key secret:(NSString*)secret
    delegate:(id<FBSessionDelegate>)delegate {
    
  FBSession* session = [[[FBSession alloc] initWithKey:key secret:secret
    getSessionProxy:nil] autorelease];
  [session.delegates addObject:delegate];
    
  return session;
}

+ (FBSession*)sessionForApplication:(NSString*)key getSessionProxy:(NSString*)getSessionProxy
    delegate:(id<FBSessionDelegate>)delegate {
    
  FBSession* session = [[[FBSession alloc] initWithKey:key secret:nil
    getSessionProxy:getSessionProxy] autorelease];
  [session.delegates addObject:delegate];
    
  return session;
}

#pragma mark - Initialization

- (FBSession*)initWithKey:(NSString*)key secret:(NSString*)secret
          getSessionProxy:(NSString*)getSessionProxy {
    
    self = [super init];
    if (self) {
        
        sharedSession = self;
        
        _delegates = FBCreateNonRetainingArray();    
        _apiKey = [key copy];
        _apiSecret = [secret copy];
        _getSessionProxy = [getSessionProxy copy];
        _uid = 0;
        _userName = nil;
        _sessionKey = nil;
        _sessionSecret = nil;
        _expirationDate = nil;
        _requestQueue = [[NSMutableArray alloc] init];
        _lastRequestTime = nil;
        _requestBurstCount = 0;
        _requestTimer = nil;    
    }
    return self;
}

#pragma mark - Public methods

- (NSString*)apiURL {
    return kAPIRestURL;
}

- (NSString*)apiSecureURL {
    return kAPIRestSecureURL;
}

- (BOOL)isConnected {
    return !!_sessionKey;
}

#pragma mark - Private Methods

-(void)sendUserNameRequest  {
    
    if (self.uid) {
        NSString* fql = [NSString stringWithFormat:
                         @"select uid,name from user where uid == %lld", self.uid];
        
        NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
        [[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
    }
}

- (void)save {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (_uid) {
    [defaults setObject:[NSNumber numberWithLongLong:_uid] forKey:@"FBUserId"];
  } else {
    [defaults removeObjectForKey:@"FBUserId"];
  }
    
    if (_userName) {
        [defaults setObject:_userName forKey:@"FBUserName"];
    } else {
        [defaults removeObjectForKey:@"FBUserName"];
        //to get user name 
        [self sendUserNameRequest];
    }

  if (_sessionKey) {
    [defaults setObject:_sessionKey forKey:@"FBSessionKey"];
  } else {
    [defaults removeObjectForKey:@"FBSessionKey"];
  }

  if (_sessionSecret) {
    [defaults setObject:_sessionSecret forKey:@"FBSessionSecret"];
  } else {
    [defaults removeObjectForKey:@"FBSessionSecret"];
  }

  if (_expirationDate) {
    [defaults setObject:_expirationDate forKey:@"FBSessionExpires"];
  } else {
    [defaults removeObjectForKey:@"FBSessionExpires"];
  }
  
  [defaults synchronize];
}

- (void)unsave {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults removeObjectForKey:@"FBUserId"];
  [defaults removeObjectForKey:@"FBUserName"];
  [defaults removeObjectForKey:@"FBSessionKey"];
  [defaults removeObjectForKey:@"FBSessionSecret"];
  [defaults removeObjectForKey:@"FBSessionExpires"];
  [defaults synchronize];
}

- (void)startFlushTimer {
  if (!_requestTimer) {
    NSTimeInterval t = kBurstDuration + [_lastRequestTime timeIntervalSinceNow];
    _requestTimer = [NSTimer scheduledTimerWithTimeInterval:t target:self
      selector:@selector(requestTimerReady) userInfo:nil repeats:NO];
  }
}

- (void)enqueueRequest:(FBRequest*)request {
  [_requestQueue addObject:request];
  [self startFlushTimer];
}

- (BOOL)performRequest:(FBRequest*)request enqueue:(BOOL)enqueue {
  // Stagger requests that happen in short bursts to prevent the server from rejecting
  // them for making too many requests in a short time
  NSTimeInterval t = [_lastRequestTime timeIntervalSinceNow];
  BOOL burst = t && t > -kBurstDuration;
  if (burst && ++_requestBurstCount > kMaxBurstRequests) {
    if (enqueue) {
      [self enqueueRequest:request];
    }
    return NO;
  } else {
    [request performSelector:@selector(connect)];

    if (!burst) {
      _requestBurstCount = 1;
      [_lastRequestTime release];
      _lastRequestTime = [[request timestamp] retain];
    }
  }
  return YES;
}

- (void)flushRequestQueue {
  while (_requestQueue.count) {
    FBRequest* request = [_requestQueue objectAtIndex:0];
    if ([self performRequest:request enqueue:NO]) {
      [_requestQueue removeObjectAtIndex:0];
    } else {
      [self startFlushTimer];
      break;
    }
  }
}

- (void)requestTimerReady {
  _requestTimer = nil;
  [self flushRequestQueue];
}


#pragma mark -

- (void)begin:(FBUID)uid UserName:(FBUserName *)name sessionKey:(NSString*)sessionKey sessionSecret:(NSString*)sessionSecret
      expires:(NSDate*)expires{
    
    _uid = uid;
    _userName = [name copy];
  _sessionKey = [sessionKey copy];
  _sessionSecret = [sessionSecret copy];
  _expirationDate = [expires retain];
  
  [self save];
}

- (BOOL)resume {
    
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  FBUID uid = [[defaults objectForKey:@"FBUserId"] longLongValue];
  if (uid) {
      
    NSDate* expirationDate = [defaults objectForKey:@"FBSessionExpires"];
    if (!expirationDate || [expirationDate timeIntervalSinceNow] > 0) {
        
      _uid = uid;
        _userName = [[defaults stringForKey:@"FBUserName"] copy];
      _sessionKey = [[defaults stringForKey:@"FBSessionKey"] copy];
      _sessionSecret = [[defaults stringForKey:@"FBSessionSecret"] copy];
      _expirationDate = [expirationDate retain];

      for (id<FBSessionDelegate> delegate in _delegates) {
        [delegate session:self didLogin:_uid];
      }
      return YES;
    }
  }
    
  return NO;
}

- (void)cancelLogin {
  if (![self isConnected]) {
    for (id<FBSessionDelegate> delegate in _delegates) {
      if ([delegate respondsToSelector:@selector(sessionDidNotLogin:)]) {
        [delegate sessionDidNotLogin:self];
      }
    }
  }
}

- (void)logout {
  if (_sessionKey) {
    for (id<FBSessionDelegate> delegate in _delegates) {
      if ([delegate respondsToSelector:@selector(session:willLogout:)]) {
        [delegate session:self willLogout:_uid];
      }
    }

    [self deleteFacebookCookies];
    

    _uid = 0;
      [_userName release];
      _userName = nil;
    [_sessionKey release];
    _sessionKey = nil;
    [_sessionSecret release];
    _sessionSecret = nil;
    [_expirationDate release];
    _expirationDate = nil;
    [self unsave];

    for (id<FBSessionDelegate> delegate in _delegates) {
      if ([delegate respondsToSelector:@selector(sessionDidLogout:)]) {
        [delegate sessionDidLogout:self];
      }
    }
  } else {
    [self deleteFacebookCookies];
    [self unsave];
  }
}

- (void)send:(FBRequest*)request {
  [self performRequest:request enqueue:YES];
}

- (void)deleteFacebookCookies {
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:
      [NSURL URLWithString:@"http://login.facebook.com"]];
    for (NSHTTPCookie* cookie in facebookCookies) {
				[cookies deleteCookie:cookie];
    }
}

#pragma mark - FBRequest delegate

- (void)request:(FBRequest*)request didLoad:(id)result {
	if ([request.method isEqualToString:@"facebook.fql.query"]) {
		NSArray* users = result;
		NSDictionary* user = [users objectAtIndex:0];
		NSString* name = [user objectForKey:@"name"];
        
        NSLog(@"name : %@",name);
        if (name) {
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"FBUserName"];
        }

	}
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
    //	_label.text = [NSString stringWithFormat:@"Error(%d) %@", error.code,
    //				   error.localizedDescription];
}


#pragma mark - Memory Management

- (void)dealloc {
    if (sharedSession == self) {
        sharedSession = nil;
    }
    
    [_delegates release];
    _delegates = nil;
    [_requestQueue release];
    _requestQueue = nil;
    [_apiKey release];
    _apiKey = nil;
    [_apiSecret release];
    _apiSecret = nil;
    [_getSessionProxy release];
    _getSessionProxy = nil;
    [_sessionKey release];
    _sessionKey = nil;
    [_sessionSecret release];
    _sessionSecret = nil;
    [_expirationDate release];
    _expirationDate = nil;
    [_lastRequestTime release];
    _lastRequestTime = nil;
    
    [super dealloc];
}


@end
