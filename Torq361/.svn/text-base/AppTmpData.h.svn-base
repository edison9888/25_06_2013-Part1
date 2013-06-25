//
//  AppTmpData.h
//  Torq361
//
//  Created by Binoy on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppTmpData : NSObject {

}

+(AppTmpData *)sharedManager;

-(void)setDeviceTocken:(NSString*)token;
-(NSString*)getDeviceTocken;

-(void)setDeviceOrientation:(BOOL)orientation;
-(BOOL)getDeviceOrientation;

- (int)getPDFMode;	//For PDF Reader

-(void)setSelectedMainCategoryID:(int)categoryID name:(NSString *)categoryName;
-(int)getSelectedMainCategoryID;
-(NSString *)getSelectedMainCategoryName;

-(void)setSelectedSubCategoryID:(int)categoryID name:(NSString *)categoryName;
-(int)getSelectedSubCategoryID;
-(NSString *)getSelectedSubCategoryName;

-(void)setProductDetailsArray:(NSMutableArray *)Arr;
-(NSMutableArray*)getProductDetailsArray;

-(void)allocAppImages;
-(UIImage *)getImageByName:(NSString *)name;
-(void)clearAppImages;

@end
