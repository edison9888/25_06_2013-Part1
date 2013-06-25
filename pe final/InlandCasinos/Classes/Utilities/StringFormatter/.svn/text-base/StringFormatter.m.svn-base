//
//  StringFormatter.m
//  PE
//
//  Created by Nithin George on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StringFormatter.h"


@implementation NSString (StringFormatter)

-(NSString *)removeAllHtmlTags {
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:self];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<img" intoString:NULL] ;
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        self = [self stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@" "];
        
    }
    
    return self;
    
}

-(NSString *)getStringFromHtml {
   
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:self];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        self = [self stringByReplacingOccurrencesOfString:
                       [NSString stringWithFormat:@"%@>", text]
                                                             withString:@" "];
        
    }
    
    self = [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self =[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return self;
    
}



@end
