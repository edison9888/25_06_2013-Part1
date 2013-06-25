//
//  TDMFilePUTHelper.h
//  TheDailyMeal
//
//  Created by Vivek Raj on 05/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "TDMBaseHttpHandler.h"

@interface TDMFilePUTHelper : TDMBaseHttpHandler
-(void)putFileWithFID:(NSString *)fid ;
@end
