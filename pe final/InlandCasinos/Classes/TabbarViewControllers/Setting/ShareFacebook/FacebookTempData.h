//
//  FacebookTempData.h
//  InlandCasinos
//
//  Created by Sagar S. Kadookkunnan on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FacebookTempData : NSObject
{
    
}

+(FacebookTempData *)sharedManager;

-(void)setFBShareImageURL :(NSString *)strUrl;
-(NSString *)getFBShareImageURL;

-(void)setFBDescription :(NSString *)strDescription;
-(NSString *)getFBDescription;

-(void)setFBShareUrl :(NSString *)strUrl;
-(NSString *)getFBShareUrl;

@end
