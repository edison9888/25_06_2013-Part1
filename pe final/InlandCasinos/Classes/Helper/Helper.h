//
//  Helper.h
//  PE
//
//  Created by Nibin_Mac on 25/06/11.
//  Copyright 2011 Rapidvalue Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Helper : NSObject {
    
}
+(Helper *)share;

/*-(void)setSelectedCasinoName:(NSString*)name;
-(NSString*)getCasinoName;

-(void)setSelectedSubItems:(NSString*)itemName;
-(NSString*)getSelectedSubItems;*/

//Method for p[assing the corresponding dictionary from the PEconfig.plist
- (NSMutableDictionary *)readLayoutItems:(NSString *)rootName;

@end
