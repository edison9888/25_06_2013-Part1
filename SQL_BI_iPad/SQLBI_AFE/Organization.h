//
//  Organization.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Organization : NSObject

@property (nonatomic,strong) NSString *orgID;
@property (nonatomic,strong) NSString *orgName;


-(BOOL) isEqualTo:(Organization*) objectToCompare;

@end
