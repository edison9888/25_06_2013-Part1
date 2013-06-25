//
//  Helper.m
//  PE
//
//  Created by Nibin_Mac on 25/06/11.
//  Copyright 2011 Rapidvalue Inc. All rights reserved.
//

#import "Helper.h"

static Helper *helper;

//static NSString *selectedCasinoName;
//static NSString *selectedSubItems;

@implementation Helper

+(Helper *)share{
    
    if (helper==nil) {
        helper=[ [Helper alloc]init];
        
    }
    
    return helper;
}


/*-(void)setSelectedCasinoName:(NSString*)name {
    
    selectedCasinoName=name;
	
	[selectedCasinoName retain];
}

-(NSString*)getCasinoName {
    
    return selectedCasinoName;
}

-(void)setSelectedSubItems:(NSString*)itemName {
    
    selectedSubItems=itemName;
	
	[selectedSubItems retain];
    
}

-(NSString*)getSelectedSubItems {
    
    return selectedSubItems;
    
}
*/

- (NSMutableDictionary *)readLayoutItems:(NSString *)rootName {
    //Loding the particular dictionary from confic.plist
    NSString *path = [[NSBundle mainBundle] bundlePath];
    
    NSString *finalPath = [path stringByAppendingPathComponent:@"PEConfig.plist"];
    
    NSDictionary *plistDictionary = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
    
    [plistDictionary autorelease];
    
    return [plistDictionary objectForKey:rootName];    
}

@end
