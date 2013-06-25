//
//  TQDirectoryPaths.h
//  Torq361
//
//  Created by Jayahari V on 21/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TQDirectoryPaths : NSObject {
    
}

//returns the application documents directory
+ (NSString*)applicationDocumentsDirectory;

//returns the directory where we downloads the images for category
+ (NSString*)downloadedCategoryImagesDirectory;

//returns the directory where we downloads the images for products
+ (NSString*)downloadedProductImagesDirectory;

@end
