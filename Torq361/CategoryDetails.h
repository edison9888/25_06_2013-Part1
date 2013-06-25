//
//  CategoryDetails.h
//  Torq361
//
//  Created by Binoy on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CategoryDetails : NSObject {
	
	NSString *idCategory;
	NSString *idCatalog;
	NSString *idParentCategory;
	NSString *Name;
	NSString *Description;
	NSString *ThumbNailImgPath;

}

@property (nonatomic,retain) NSString *idCategory;
@property (nonatomic,retain) NSString *idCatalog;
@property (nonatomic,retain) NSString *idParentCategory;
@property (nonatomic,retain) NSString *Name;
@property (nonatomic,retain) NSString *Description;
@property (nonatomic,retain) NSString *ThumbNailImgPath;

@end
