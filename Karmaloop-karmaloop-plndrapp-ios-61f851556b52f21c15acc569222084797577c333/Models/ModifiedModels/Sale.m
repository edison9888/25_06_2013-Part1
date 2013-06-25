//
//  Sale.m
//  karmaloop-plndrapp-ios
//
//  Created by DX079 on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Sale.h"
#import "Utility.h"

@implementation Sale

@synthesize startDate = _startDate, endDate = _endDate;

NSString *kStartDateCodingKey = @"kStartDateCodingKey";
NSString *kEndDateCodingKey = @"kEndDateCodingKey";

- (void)postProcessData {
    _startDate = [Utility dateFromISO8601:self.startDateRaw];
    _endDate = [Utility dateFromISO8601:self.endDateRaw];
    _tileImagePathMedium = self.tileImagePathMedium;
    _tileImagePathLarge = self.tileImagePathLarge;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_startDate forKey:kStartDateCodingKey];
    [aCoder encodeObject:_endDate forKey:kEndDateCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    _startDate = [aDecoder decodeObjectForKey:kStartDateCodingKey];
    _endDate = [aDecoder decodeObjectForKey:kEndDateCodingKey];
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@: id=%@ name=%@", [self class], self.saleId, self.name];
}

- (id)copyWithZone:(NSZone *)zone {
    Sale *sale = [super copyWithZone:zone];
    sale.startDate = self.startDate;
    sale.endDate = self.endDate;
    return sale;
}

@end
