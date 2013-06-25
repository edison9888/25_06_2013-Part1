//
//  ALDefaultsWrapper.m
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RBDefaultsWrapper.h"


@implementation RBDefaultsWrapper

NSString * const DEFAULTS_USERNAME = @"USER_NAME";
NSString * const DEFAULTS_USERPWD = @"USER_PWD";


+ (RBDefaultsWrapper *)standardWrapper
{
	return [[[RBDefaultsWrapper alloc] init] autorelease];
}

/*- (BOOL)setFirstAppLaunchDefaults
{
	
	[[NSUserDefaults standardUserDefaults] synchronize];
	return YES;
}
    
- (BOOL)isAnonymous
{
    NSLog(@"Username = %@, Password = %@", self.currentUserName, self.currentPassword);
    
    if (self.currentUserName == nil || self.currentPassword == nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


-(void)clearUserInformation
{
    [self updateUserName:nil];
    [self updatePassword:nil];

    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(NSString *)currentPassword
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_USERPWD];
}

-(void)updatePassword:(NSString *)newPassword
{
	[[NSUserDefaults standardUserDefaults] setObject:newPassword forKey:DEFAULTS_USERPWD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}*/

- (void)updateUserName:(NSString *)newUserName
{
	[[NSUserDefaults standardUserDefaults] setObject:newUserName forKey:DEFAULTS_USERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)currentUserName
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_USERNAME];
}

-(void)clearUserInformation
{
    [self updateUserName:nil];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end

