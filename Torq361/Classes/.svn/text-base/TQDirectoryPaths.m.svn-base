//
//  TQDirectoryPaths.m
//  Torq361
//
//  Created by Jayahari V on 21/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TQDirectoryPaths.h"
#import "UserCredentials.h"

@implementation TQDirectoryPaths

//returns the application documents directory
+ (NSString*)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

//returns the directory where we downloads the images for category
+ (NSString*)downloadedCategoryImagesDirectory {
    NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
    NSString * pathComponents = [NSString stringWithFormat:@"%@%@/CategoryThumb",@"CompanyId",companyid];
    return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:pathComponents];
}

//returns the directory where we downloads the images for products
+ (NSString*)downloadedProductImagesDirectory {
    NSString *companyid = [[UserCredentials sharedManager]getCompanyID];
    NSString * pathComponents = [NSString stringWithFormat:@"%@%@/ProductThumb",@"CompanyId",companyid];
    return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:pathComponents];
}

@end
