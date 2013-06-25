//
//  UserCredentials.m
//  Torq361
//
//  Created by Binoy on 07/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserCredentials.h"
#import "Constants.h"


@implementation UserCredentials

static UserCredentials *userCredentials;

static NSString *userID;
static NSString *firstName;
static NSString *lastName;
static NSString *password;
static NSString *companyID;
static NSString *rollID;
//static NSString *authToken;


+(UserCredentials*)sharedManager {

	if (!userCredentials) {
		
		userCredentials=[[UserCredentials alloc] init];
		
	}
	return userCredentials;

}

+(void)copyObject:(UserCredentials*)usercredentials {

	if (!userCredentials) {
		
		userCredentials=[[UserCredentials alloc] init];
		userCredentials=[usercredentials mutableCopy];
		
	}	
	
}

-(void)setUserID:(NSString*)uid {

	userID=uid;
	
	[userID retain];
	
}
-(NSString*)getUserID {
	
	return userID;
	
}

-(void)setPassword:(NSString*)userPassword {
	
	password=userPassword;
	
	[password retain];
}

-(NSString*)getPassword {

	return password;
	
}

-(void)setFirstName:(NSString*)name {
	
	firstName = name;
	
	[firstName retain];
	
}
-(NSString*)getFirstName {
	
	return firstName;
}

-(void)setLastName:(NSString*)name {
	
	lastName = name;
	
	[lastName retain];
}
-(NSString*)getLastName {
	
	return lastName;
	
}

-(void)setCompanyID:(NSString*)companyid {
	
	companyID = companyid;
	
	[companyID retain];
	
}

-(NSString*)getCompanyID {
	
	return companyID;
}

-(void)setRollID:(NSString*)rollid {
	
	rollID = rollid;
	
	[rollID retain];
}

-(NSString*)getRollID {
	
	return rollID;
	
}

/*
- (void)setAuthToken:(NSString *)authtoken {

	authToken = authtoken;
	
	[authToken retain];
	
}

- (NSString *) getAuthToken {
	
	return authToken;
	
}
*/

-(void)saveUserCredentials {
	
	if (userCredentials) {
		
		NSMutableArray *tmpArr=[[NSMutableArray alloc] init];
		
		[tmpArr addObject:userCredentials];		
		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tmpArr];
		
		[[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserCredentials];		
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoginStatus];
		
		[tmpArr release];
	}
}

-(void)clearUserCredentials {
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserCredentials];
	[[NSUserDefaults standardUserDefaults]setBool:NO forKey:kLoginStatus];
	
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
	[coder encodeObject:userID forKey:@"UserID"];
	[coder encodeObject:firstName forKey:@"FirstName"];
	[coder encodeObject:lastName forKey:@"LastName"];
	[coder encodeObject:password forKey:@"Password"];
	[coder encodeObject:rollID forKey:@"RollID"];
	[coder encodeObject:companyID forKey:@"CompanyID"];
	//[coder encodeObject:authToken forKey:@"authToken"];
	
    
}

- (id)initWithCoder:(NSCoder *)coder;
{
    userCredentials = [[UserCredentials alloc] init];
    if (userCredentials != nil)
    {
		[self setUserID:[coder decodeObjectForKey:@"UserID"]];		
		[self setFirstName:[coder decodeObjectForKey:@"FirstName"]];
		[self setLastName:[coder decodeObjectForKey:@"LastName"]];		
		[self setPassword:[coder decodeObjectForKey:@"Password"]];		
		[self setRollID:[coder decodeObjectForKey:@"RollID"]];		
		[self setCompanyID:[coder decodeObjectForKey:@"CompanyID"]];
		//[self setCompanyID:[coder decodeObjectForKey:@"authToken"]];
        
    }   
    return self;
}


@end