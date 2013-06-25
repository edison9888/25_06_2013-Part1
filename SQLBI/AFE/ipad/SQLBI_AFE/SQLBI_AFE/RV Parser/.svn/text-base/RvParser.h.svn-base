//
//  RvParser.h
//  RvParser
//
//  Created by Elbin John on 31/05/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>



#define DEBUG 1

#define DEBUG_MESSAGE 0

#ifdef DEBUG
#    define DLog(...) //NSLog(__VA_ARGS__)
#else
#    define DLog(...) /* */
#endif


#ifdef DEBUG_MESSAGE 
#define SHOW_ALERT(msg) { \
\
UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil]; \
[_alert show]; \
}
#endif

 
//Plist file name where json relations are mapped foe parsing
#define JSON_MAPPING_PLIST    @"ClassMap"

#define AttributeElements     @"attributes"
#define AttributeRelations    @"relation"

#define AttributeMapTo        @"mapTo"
#define AttributeField        @"field"
#define AttributeType         @"type"


@interface RvParser : NSObject

-(NSArray*)mapptoModelClass:(NSString*)rootClassName:(id)jsonObject;

@end
