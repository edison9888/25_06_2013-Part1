//
//  TDMPhotoUploadService.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 17/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TDMPhotoUploadServiceDelegate <NSObject>
@required
-(void) photoUploadedSuccessFully;
-(void) photoUploadedFailed;
-(void) noPhoto;
-(void) networkErrorInAddinBusinessReview;
@end

@interface TDMPhotoUploadService : TDMBaseHttpHandler {
    
    id <TDMPhotoUploadServiceDelegate> photoUploadServicedelegate;
    BOOL isFromUserLogin;
    BOOL isFromAddDish;
    BOOL isFromReview;
}
@property (assign) BOOL isFromReview;
@property (nonatomic, retain) id <TDMPhotoUploadServiceDelegate> photoUploadServicedelegate;
@property (assign) BOOL isFromAddDish;;
- (void)uploadPhotoToTheReviewWithUID:(NSString *)uid withData:(NSData *)data withFileName:(NSString *)fileName;
-(void)uploadPhotoFromPath:(NSString *)filePath withFileName:(NSString *)fileName andUploadType:(int)fileType ;
@end
