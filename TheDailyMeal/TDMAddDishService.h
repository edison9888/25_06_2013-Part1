//
//  TDMAddDishService.h
//  TheDailyMeal
//
//  Created by Aswathy Bose on 24/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TDMAddDishServiceDelegate <NSObject>
@required
-(void)failedToAddSignatureDish;
-(void)signatureDishAddedSuccessFully;
-(void) networkErrorInAddingBusinessReview;
@end
@interface TDMAddDishService : TDMBaseHttpHandler
{
    id <TDMAddDishServiceDelegate> addDishServicedelegate;
}
@property (nonatomic, assign) id <TDMAddDishServiceDelegate> addDishServicedelegate;
-(void)addSignatureDishWithBody:(NSString *)body andTitle:(NSString *)title forVenue:(NSString *) vid withPhotoFID:(NSString *)photoFID;
@end
