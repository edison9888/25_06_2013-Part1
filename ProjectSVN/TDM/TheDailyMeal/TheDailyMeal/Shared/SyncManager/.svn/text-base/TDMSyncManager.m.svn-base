//
//  TDMSyncManager.m
//  TheDailyMeal
//
//  Created by Bittu Davis on 1/16/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMSyncManager.h"
#import "TDMCoreDataManager.h"
#import "JSONHandler.h"

@interface TDMSyncManager()
//private
@property (assign,nonatomic) BOOL isUpdateAvailable;
@property (nonatomic,retain) TDMCoreDataManager *coreDataManager;
//functions
- (void)assignCoreDataManager;
- (void)refreshDatabaseWithLatestUpdates;
- (void)insertInitialLastModifiedDataToCoreData;
- (NSString *)getLastModifiedDateFromCoreData;

@end

@implementation TDMSyncManager
@synthesize isUpdateAvailable;
@synthesize coreDataManager;

#pragma mark - Sync Startup
//this will check if there is any updates are done on the server.
- (void)checkForUpdates{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *lastModifiedDate = [self getLastModifiedDateFromCoreData];
    [dict setValue:lastModifiedDate forKey:@"lastModifiedDate"];
    isUpdateAvailable = YES;
    if (isUpdateAvailable) {
        NSLog(@"teh refresh is there. ");
        [self refreshDatabaseWithLatestUpdates];
    }
//    JSONHandler *jsonHandler = [[JSONHandler alloc]init];
//    [jsonHandler sendJSONRequest:dict RequestUrl:kSYNC_URL];
//    REMOVE_FROM_MEMORY(jsonHandler)
    lastModifiedDate = nil;
     
}

//this will insert the default entries to the CoreData
- (void)insertInitialLastModifiedDataToCoreData{
    [self assignCoreDataManager];
    [coreDataManager insertInitialLastModifiedData];
       
}

//this will fetch the last Modified Date from the CoreData
- (NSString *)getLastModifiedDateFromCoreData{
    [self assignCoreDataManager];
    return [coreDataManager getLastModifiedDate];
}

//this will refresh the Database with the latest updates on the server
- (void)refreshDatabaseWithLatestUpdates{

    [self assignCoreDataManager];
    [coreDataManager fillDataToCoreDataDatabase];
}


#pragma mark - Helpers
//this will assign the CoreDataManager
- (void)assignCoreDataManager{
    if (!coreDataManager) {
        self.coreDataManager = [[[TDMCoreDataManager alloc]init]autorelease];
    }
}

#pragma mark - Memory Management
- (void)dealloc {
    REMOVE_FROM_MEMORY(coreDataManager)
	[super dealloc];
}

@end
