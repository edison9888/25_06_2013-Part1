//
//  ClassFinder.h
//
//  TheDailyMeal
//
//  Created by Nithin George on 06/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOCATE(__classname__) (__classname__ *)[ClassFinder locate:@#__classname__]
//#define UNLOAD(__classname__) (__classname__ *)[ClassFinder unload:@#__classname__]
 
@interface ClassFinder : NSObject 
{
   
}

+(id)locate:(NSString *)className;
+(void)unload:(NSString *)className;

+(void)releaseInstances;
+ (NSString *)urlEncodedParamStringFromString:(NSString *)original;

@end
