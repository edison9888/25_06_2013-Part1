//
//  ImageCrop.h
//  PE
//
//  Created by Nithin George on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (ImageCrop)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
