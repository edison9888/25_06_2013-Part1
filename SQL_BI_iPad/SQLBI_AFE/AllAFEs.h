//
//  AllAFEs.h
//  SQLBI_AFE
//
//  Created by Anilkumar Pillai on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllAFEs : NSObject

@property (nonatomic,strong) NSString  *afeID;
@property (nonatomic,strong) NSString  *afeName;
@property (nonatomic,strong) NSString  *afeNumber;

-(BOOL) isEqualTo:(AllAFEs*) objectToCompare;

@end
