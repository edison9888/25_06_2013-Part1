//
//  WellDetail.h
//  SQLBI_AFE
//
//  Created by Ajeesh T S on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WellDetail : NSObject

@property (nonatomic,strong) NSString *wellName;
@property (nonatomic,strong) NSString *api;
@property (nonatomic,strong) NSString *unitLease;
@property (nonatomic,strong) NSString *district;
@property (nonatomic,strong) NSString *subArea;
@property (nonatomic,strong) NSString *businessUnit;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *afeClassName;
@property (nonatomic,assign) BOOL operated;
@property (nonatomic,assign) double workingInterest;
@property (nonatomic,strong) NSDate *spudDate;
@property (nonatomic,assign) double oilNri;
@property (nonatomic,assign) double gasNri;


-(BOOL) isEqualTo:(WellDetail*) objectToCompare;

@end
