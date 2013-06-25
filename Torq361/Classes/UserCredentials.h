//
//  UserCredentials.h
//  Torq361
//
//  Created by Binoy on 07/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserCredentials : NSObject {

}

+(UserCredentials*)sharedManager;
+(void)copyObject:(UserCredentials*)usercredentials;

-(void)setUserID:(NSString*)uid;
-(NSString*)getUserID;

-(void)setPassword:(NSString*)userPassword;
-(NSString*)getPassword;

-(void)setFirstName:(NSString*)name;
-(NSString*)getFirstName;

-(void)setLastName:(NSString*)name;
-(NSString*)getLastName;

-(void)setCompanyID:(NSString*)companyid;
-(NSString*)getCompanyID;

-(void)setRollID:(NSString*)rollid;
-(NSString*)getRollID;

//- (void)setAuthToken:(NSString *)authtoken;
//- (NSString*)getAuthToken;


-(void)saveUserCredentials;
-(void)clearUserCredentials;


@end
