//
//  TDMCoreDataManager.h
//  TheDailyMeal
//
//  Created by Anandlal on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDMCoreDataManager : NSObject{
   
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic,retain,readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,retain,readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain,readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//static
+(TDMCoreDataManager  *)sharedCoreDataManager;

//public
- (void)insertInitialLastModifiedData;
- (NSString *)getLastModifiedDate;
- (void)wipeDatabase;
- (void)fillDataToCoreDataDatabase;

#pragma mark - DB Fetch Operations
- (NSMutableArray *)getBusinessWithType:(NSString *)aBusinessType;

//DB Write
-(void)addUserDetails:(NSString *)userName;
@end
