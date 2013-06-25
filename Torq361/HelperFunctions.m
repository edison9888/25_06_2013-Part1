//
//  HelperFunctions.m
//  Brighton
//
//  Created by Timmi on 09/06/10.
//  Copyright 2010 RVS. All rights reserved.
//

#import "HelperFunctions.h"


@implementation HelperFunctions

+(NSString *)trimTxtField:(NSString *)strTxtField{
	
	return [strTxtField stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
}

+(BOOL)checkTxtFieldLength:(NSString *)strTxtField{
	
	strTxtField= [strTxtField stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([strTxtField length]>0){
		return YES;
	}
	
	return NO;
	
}

+(NSArray*)getDictionaryKeys:(NSDictionary *)Dictionary{
	NSMutableArray *keyArr=[[[NSMutableArray alloc] init]autorelease];
	for(id key in [Dictionary allKeys])
    {
		[keyArr addObject:key];
        //id value = [dict valueForKey:key];
	}
	return keyArr;
}

/*+(void)mainCategoryViewAnimation:(UIView *)superView:(UIView *)subView {
	
	SUB_VIEW.transform = CGAffineTransformMakeScale(0.1,0.1);
	SUB_VIEW.alpha = 0.0f;
	[SUPER_VIEW addSubview:SUB_VIEW];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	SUB_VIEW.alpha = 1.0f;
	SUB_VIEW.transform = CGAffineTransformMakeScale(1.0,1.0);
	[UIView commitAnimations];
}*/

+(BOOL)emailValidate :( NSString *)email{
	
    if([email rangeOfString:@"@"].location==NSNotFound || [email rangeOfString:@"."].location==NSNotFound){		
        return YES;
	}
	
    //Break email address into its components
    NSString *accountName=[email substringToIndex: [email rangeOfString:@"@"].location];
    email=[email substringFromIndex:[email rangeOfString:@"@"].location+1];
	
    //’.’ not present in substring
    if([email rangeOfString:@"."].location==NSNotFound){		
        return YES;
	}
    NSString *domainName=[email substringToIndex:[email rangeOfString:@"."].location];
    NSString *subDomain=[email substringFromIndex:[email rangeOfString:@"."].location+1];
	
    //username, domainname and subdomain name should not contain the following charters below
    //filter for user name
    NSString *unWantedInUName = @" ~!@#$^&*()={}[]|;’:<>,?/`";
    //filter for domain
    NSString *unWantedInDomain = @" ~!@#$%^&*()={}[]|;’:<>,+?/`";
    //filter for subdomain
    NSString *unWantedInSub = @" `~!@#$%^&*()={}[]:;’<>,?/1234567890";
	
    //subdomain should not be less that 2 and not greater 6
    if(!(subDomain.length>=2 && subDomain.length<=6)) return NO;
	
    if([accountName isEqualToString:@""] || [accountName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInUName]].location!=NSNotFound || [domainName isEqualToString:@""] || [domainName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInDomain]].location!=NSNotFound || [subDomain isEqualToString:@""] || [subDomain rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInSub]].location!=NSNotFound){
        
		return YES;
	}
	
    return NO;
}



@end
