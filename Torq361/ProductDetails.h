//
//  ProductDetails.h
//  Torq361
//
//  Created by Binoy on 08/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProductDetails : NSObject {

	
	NSString *idProduct;
	
	NSString *idCategory;
	
	NSString *Name;
	
	NSString *Description;
	
	NSString *ThumbNailImgPath;
	
	NSString *downloadStatus;
	
	NSString *newStatus;
	
	NSString *prodDetails;
	
	NSString *techDetails;
	
}

@property (nonatomic,retain) NSString *idProduct;
@property (nonatomic,retain) NSString *idCategory;
@property (nonatomic,retain) NSString *Name;
@property (nonatomic,retain) NSString *Description;
@property (nonatomic,retain) NSString *ThumbNailImgPath;
@property (nonatomic,retain) NSString *downloadStatus;
@property (nonatomic,retain) NSString *newStatus;
@property (nonatomic,retain) NSString *prodDetails;
@property (nonatomic,retain) NSString *techDetails;

@end
