//
//  TDMCoreDataManager.m
//  TheDailyMeal
//
//  Created by Anandlal on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMCoreDataManager.h"
#import <CoreData/CoreData.h>
#import "SyncTable.h"
#import "Business.h"
#import "CityGuide.h"
#import "Criteria.h"
#import "Review.h"
#import "SignatureDish.h"
#import "User.h"

@interface TDMCoreDataManager()
//private
@property (retain,nonatomic) NSManagedObjectContext *context;

- (void)addCriteriaCoreData;
- (void)addReviewCoreData;
- (void)addBusinessCoreData;
- (void)addCityGuideCoreData;
- (void)addSignatureDishCoreData;
- (NSString *)applicationDocumentsDirectory;
- (NSManagedObjectContext *)getManagedObjectContext;

@end

#define kARRAY_BUSINESS_NAME [NSArray arrayWithObjects:@"Alpha Restaurants",@"Cobra Bar",@"SunRise Restaurant",@"McDonalds",@"Dreams Pub", nil]
#define kARRAY_BUSINESS_ID [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil]
#define kARRAY_BUSINESS_ADDRESS [NSArray arrayWithObjects:@"Area 112,N.CA",@"Mission St. Peak 1",@"Clock Mirror Avenue",@"Master Avenue, 113 Side",@"Geek Street, North East Way", nil]
#define kARRAY_BUSINESS_CITYID [NSArray arrayWithObjects:@"10",@"20",@"30",@"40",@"50", nil]
#define kARRAY_BUSINESS_RATING [NSArray arrayWithObjects:@"0",@"2",@"5",@"0",@"1", nil] 
#define kARRAY_BUSINESS_REVIEWCOUNT [NSArray arrayWithObjects:@"0",@"2",@"5",@"0",@"1", nil]
#define kARRAY_BUSINESS_TYPE [NSArray arrayWithObjects:@"restaurant",@"bar",@"restaurant",@"restaurant",@"bar", nil]
#define kARRAY_BUSINESS_CHEAP [NSArray arrayWithObjects:@"0",@"0",@"1",@"0",@"1", nil]
#define kARRAY_BUSINESS_HOTLIST [NSArray arrayWithObjects:@"0",@"0",@"1",@"0",@"1", nil]
#define kARRAY_BUSINESS_TOPRESTAURANT [NSArray arrayWithObjects:@"3",@"19",@"5",@"65",@"100", nil]
#define kARRAY_BUSINESS_TOP101RESTAURANT [NSArray arrayWithObjects:@"3",@"19",@"5",@"65",@"100", nil]
#define kARRAY_BUSINESS_FAVORITE [NSArray arrayWithObjects:@"0",@"0",@"1",@"0",@"1", nil]

#define kARRAY_CITYGUIDE_NAME [NSArray arrayWithObjects:@"Austin",@"Boston",@"Miami",@"Austin",@"New York", nil]
#define KARRAY_CRITERIA_TYPE [NSArray arrayWithObjects:@"Italian",@"Indian",@"Italian",@"Italian",@"American", nil]
#define kARRAY_REVIEW_DATE [NSArray arrayWithObjects:@"1 Jan 2012",@"4 Jan 2012",@"7 Jan 2012",@"9 Jan 2012",@"11 Jan 2012", nil]
#define kARRAY_REVIEW_DESCRIPTION [NSArray arrayWithObjects:@"Description 1",@"Description 2",@"Description 3",@"Description 4",@"Description 5", nil]
#define kARRAY_REVIEW_HEADING [NSArray arrayWithObjects:@"Heading 1",@"Heading 2",@"Heading 3",@"Heading 4",@"Heading 5", nil]
#define kARRAY_REVIEW_ID [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil]
#define kARRAY_REVIEW_NAME [NSArray arrayWithObjects:@"Review 1",@"Review 2",@"Review 3",@"Review 4",@"Review 5", nil]
#define kARRAY_REVIEW_USERNAME [NSArray arrayWithObjects:@"reviewMonster",@"Black Eye",@"reviewMonster",@"Bond",@"reviewMonster", nil]

#define kARRAY_SIGNATUREDISH_DESCRIPTION [NSArray arrayWithObjects:@"Description 1",@"Description 2",@"Description 3",@"Description 4",@"Description 5", nil]
#define kARRAY_SIGNATUREDISH_ID [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil]
#define kARRAY_SIGNATUREDISH_RATING [NSArray arrayWithObjects:@"0",@"2",@"5",@"0",@"1", nil]
#define kARRAY_SIGNATUREDISH_USERNAME [NSArray arrayWithObjects:@"reviewMonster",@"Black Eye",@"reviewMonster",@"Bond",@"reviewMonster", nil]

#define kARRAY_COUNT 5
#define kINITIAL_COUNT 0

@implementation TDMCoreDataManager
static TDMCoreDataManager* _sharedCoreDataManager; // self
@synthesize context;

//static class
+(TDMCoreDataManager *)sharedCoreDataManager{
    @synchronized(self) {
        if (_sharedCoreDataManager == nil) {
			_sharedCoreDataManager = [[[TDMCoreDataManager alloc] init] autorelease];
        }
	}
    return _sharedCoreDataManager;
}

#pragma mark  - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"TDMCoreData.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	//	abort();
    }    
	
    return persistentStoreCoordinator;
}

#pragma mark  - Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -Helper Functions
- (NSManagedObjectContext *)getManagedObjectContext{
    if (!context) {
        self.context = [self managedObjectContext];
    }
    return self.context;
}

#pragma mark - LastModifiedData operations
//inserts the default data into the SyncTable of CoreData
- (void)insertInitialLastModifiedData{
    NSError *error = nil;
    [self getManagedObjectContext];
    SyncTable *sync = [NSEntityDescription insertNewObjectForEntityForName:@"SyncTable" inManagedObjectContext:self.context];
    sync.lastModifiedDate = @"123456";
    [self.context save:&error];
    if (error!=nil) {
        NSLog(@"error im if: %@   user error: %@", error, [error userInfo]);
    }
}

//this will return the last modified Data from the CoreData
- (NSString *)getLastModifiedDate{
    
    NSError *error = nil;
    [self getManagedObjectContext];
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SyncTable" inManagedObjectContext:self.context];
    NSString *lastModifiedDateString = [NSString string];
    [fetchReq setEntity:entity];
    NSArray *results = [context executeFetchRequest:fetchReq error:&error];
    if ([results count]) {
        for (SyncTable *syncTable in results) {
           lastModifiedDateString = syncTable.lastModifiedDate;
        }    
    }
    REMOVE_FROM_MEMORY(fetchReq)
    return lastModifiedDateString;
}

-(void)wipeDatabase {
    
}

//this will fill up the data to the CoreData DB
- (void)fillDataToCoreDataDatabase{
    
    [self addCriteriaCoreData];
    [self addCityGuideCoreData];
    [self addSignatureDishCoreData];
    [self addReviewCoreData];
    [self addBusinessCoreData];
    
}

//this will populate up the Criteria table
-(void)addUserDetails:(NSString *)userName {
    

    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Business" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
 
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSLog(@"%@",fetchedObjects);
    REMOVE_FROM_MEMORY(fetchRequest);
}
- (void)addCriteriaCoreData{
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Criteria" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (![fetchedObjects count]) {
       for (int i = kINITIAL_COUNT; i<kARRAY_COUNT; i++) {
            [self getManagedObjectContext];
            
            NSManagedObject *criteria = [NSEntityDescription insertNewObjectForEntityForName:@"Criteria" inManagedObjectContext:self.context];
            int ID = [[kARRAY_BUSINESS_ID objectAtIndex:i] intValue];
            [criteria setValue:[NSNumber numberWithInt:ID] forKey:@"businessId"];
            [criteria setValue:[KARRAY_CRITERIA_TYPE objectAtIndex:i] forKey:@"type"];
        }
        [self.context save:&error];
    }
    REMOVE_FROM_MEMORY(fetchRequest)
}

//this will populate up the CityGuide table
- (void)addCityGuideCoreData{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CityGuide" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    REMOVE_FROM_MEMORY(fetchRequest)
    if (![fetchedObjects count]) {
        for (int i = kINITIAL_COUNT; i<kARRAY_COUNT; i++) {
            [self getManagedObjectContext];
            
            NSManagedObject *criteria = [NSEntityDescription insertNewObjectForEntityForName:@"CityGuide" inManagedObjectContext:self.context];
            int ID = [[kARRAY_BUSINESS_CITYID objectAtIndex:i] intValue];
            [criteria setValue:[NSNumber numberWithInt:ID] forKey:@"id"];
            [criteria setValue:[kARRAY_CITYGUIDE_NAME objectAtIndex:i] forKey:@"name"];
        }
       [self.context save:&error];
    }
    REMOVE_FROM_MEMORY(fetchRequest)    
}

//this will populate up the SignatureDish table
- (void)addSignatureDishCoreData{
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SignatureDish" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (![fetchedObjects count]) {
        for (int i = kINITIAL_COUNT; i<kARRAY_COUNT; i++) {
            [self getManagedObjectContext];
            
            NSManagedObject *criteria = [NSEntityDescription insertNewObjectForEntityForName:@"SignatureDish" inManagedObjectContext:self.context];
            int ID = [[kARRAY_BUSINESS_ID objectAtIndex:i] intValue];
            int rating = [[kARRAY_SIGNATUREDISH_RATING objectAtIndex:i] intValue];
            [criteria setValue:[NSNumber numberWithInt:ID] forKey:@"businessId"];
            [criteria setValue:[NSNumber numberWithInt:ID] forKey:@"id"];
            [criteria setValue:[kARRAY_SIGNATUREDISH_DESCRIPTION objectAtIndex:i] forKey:@"name"];
            [criteria setValue:[NSNumber numberWithInt:rating] forKey:@"rating"];
            [criteria setValue:[kARRAY_SIGNATUREDISH_USERNAME objectAtIndex:i] forKey:@"userName"];
            [criteria setValue:[kARRAY_SIGNATUREDISH_DESCRIPTION objectAtIndex:i] forKey:@"desc"];
        }
        [self.context save:&error];
    }
    REMOVE_FROM_MEMORY(fetchRequest)
}

//this will populate up the Review table
- (void)addReviewCoreData{
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Review" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (![fetchedObjects count]) {
        for (int i = kINITIAL_COUNT; i<kARRAY_COUNT; i++) {
            [self getManagedObjectContext];
            
            NSManagedObject *criteria = [NSEntityDescription insertNewObjectForEntityForName:@"Review" inManagedObjectContext:self.context];
            int ID = [[kARRAY_BUSINESS_ID objectAtIndex:i] intValue];
            [criteria setValue:[NSNumber numberWithInt:ID] forKey:@"businessId"];
            [criteria setValue:[NSNumber numberWithInt:ID] forKey:@"id"];
            [criteria setValue:[kARRAY_REVIEW_NAME objectAtIndex:i] forKey:@"name"];
            [criteria setValue:[kARRAY_REVIEW_HEADING objectAtIndex:i] forKey:@"heading"];
            [criteria setValue:[kARRAY_REVIEW_USERNAME objectAtIndex:i] forKey:@"userName"];
            [criteria setValue:[kARRAY_REVIEW_DESCRIPTION objectAtIndex:i] forKey:@"desc"];
            [criteria setValue:[kARRAY_REVIEW_DATE objectAtIndex:i] forKey:@"date"];
        }
        [self.context save:&error];
    }
    REMOVE_FROM_MEMORY(fetchRequest)
}

//this will populate up the Business table
- (void)addBusinessCoreData{
    
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Business" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (![fetchedObjects count]) {
        for (int i = kINITIAL_COUNT; i<kARRAY_COUNT; i++) {
            [self getManagedObjectContext];
            
            NSManagedObject *criteria = [NSEntityDescription insertNewObjectForEntityForName:@"Business" inManagedObjectContext:self.context];
            int ID = [[kARRAY_BUSINESS_ID objectAtIndex:i] intValue];
            int rating = [[kARRAY_BUSINESS_RATING objectAtIndex:i] intValue];
            int cityId = [[kARRAY_BUSINESS_CITYID objectAtIndex:i] intValue];
            int restaurant101 = [[kARRAY_BUSINESS_TOP101RESTAURANT objectAtIndex:i] intValue];
            int topRestaurant = [[kARRAY_BUSINESS_TOPRESTAURANT objectAtIndex:i] intValue];
            int reviewCount = [[kARRAY_BUSINESS_REVIEWCOUNT objectAtIndex:i] intValue];
            int cheap = [[kARRAY_BUSINESS_CHEAP objectAtIndex:i] intValue];
            int hotList = [[kARRAY_BUSINESS_HOTLIST objectAtIndex:i] intValue];
           
            [criteria setValue:[kARRAY_BUSINESS_ADDRESS objectAtIndex:i] forKey:@"address"];
            [criteria setValue:[NSNumber numberWithInt:ID] forKey:@"businessId"];
            [criteria setValue:[NSNumber numberWithInt:cheap] forKey:@"cheap"];
            [criteria setValue:[NSNumber numberWithInt:cityId] forKey:@"cityId"];
            [criteria setValue:[NSNumber numberWithInt:hotList] forKey:@"hotList"];
            [criteria setValue:[kARRAY_BUSINESS_NAME objectAtIndex:i] forKey:@"name"];
            [criteria setValue:[NSNumber numberWithInt:rating] forKey:@"rating"];
            [criteria setValue:[NSNumber numberWithInt:restaurant101] forKey:@"restaurant101"];
            [criteria setValue:[NSNumber numberWithInt:reviewCount] forKey:@"reviewCount"];
            [criteria setValue:[NSNumber numberWithInt:topRestaurant] forKey:@"topRestaurant"];
            [criteria setValue:[kARRAY_BUSINESS_TYPE objectAtIndex:i] forKey:@"type"];
        }
        [self.context save:&error];
    }
    REMOVE_FROM_MEMORY(fetchRequest)

}

#pragma mark  - DB Fetching
- (NSMutableArray *)getBusinessWithType:(NSString *)aBusinessType{
    NSError *error;
    [self getManagedObjectContext];
    NSFetchRequest *fetchReq = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:@"Business" inManagedObjectContext:self.context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", aBusinessType];
    NSMutableArray *resultArray = [NSMutableArray array];
    [fetchReq setPredicate:predicate];
    [fetchReq setEntity:entity];
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchReq error:&error];
    
    if ([fetchedObjects count]) {
        for (Business *dict in fetchedObjects) {
           NSLog(@"the result Dict will be:%@",[dict valueForKey:@"criteriaRelation"]);
            [resultArray addObject:dict];
        }
    }    
    REMOVE_FROM_MEMORY(fetchReq)
    return resultArray;

}

#pragma mark  - Memory Management
- (void)dealloc{
 
    REMOVE_FROM_MEMORY(context)
    [super dealloc];
    
}


@end
