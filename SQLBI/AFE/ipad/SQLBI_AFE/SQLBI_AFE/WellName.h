//
//  WellName.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 23/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WellName : NSObject



@property (nonatomic,strong) NSString *propertyID;
@property (nonatomic,strong) NSString *propertyName;
@property (nonatomic,strong) NSString *status;

-(BOOL) isEqualTo:(WellName*) objectToCompare;

@end
