//
//  BrightonAppDelegate.h
//  Brighton
//
//  Created by Timmi on 09/06/10.
//  Copyright RVS 2010. All rights reserved.
//

#import "DatabaseManager.h"
#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "BussinessModel.h"

@implementation DatabaseManager
@synthesize m_objSqlite;


static __weak id<DatabaseManagerDelegate> _delegate;
static DatabaseManager* _sharedManager; // self

- (void)dealloc {
	
	[_sharedManager release];
	[super dealloc];
}

+ (id)delegate {
	
    return _delegate;
}

+ (void)setDelegate:(id)newDelegate {
	
    _delegate = newDelegate;	
}

+ (DatabaseManager*)sharedManager
{
	@synchronized(self) {
		
        if (_sharedManager == nil) {
			
            [[[self alloc] init]autorelease]; 
			_sharedManager.m_objSqlite = [[[Sqlite alloc] init] autorelease];
							
		  }
	}
    return _sharedManager;
}
	

#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_sharedManager == nil) {
			
            _sharedManager = [super allocWithZone:zone];			
            return _sharedManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;	
}

#pragma mark==============================================================================================================================================
//Database Creations

#pragma mark Database Initialization Methods
- (BOOL) CREATEDATABASE :(NSString*)strdbname{
   
	NSString *writableDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TDM.db"];
    
    BOOL success;
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *defaultDBPath = [documentsDirectory stringByAppendingPathComponent:@"TDM.db"];
	
    
	success = [fileManager fileExistsAtPath:defaultDBPath];
	if (!success) {
		success = [fileManager copyItemAtPath:writableDBPath toPath:defaultDBPath error:&error];
	}

	if (![m_objSqlite open:defaultDBPath])
		return NO;
	
	NSArray *arrSqliteMaster;
	arrSqliteMaster = [m_objSqlite executeQuery:@"SELECT * FROM sqlite_master;"];
	
	//Checking Table Count
	if([arrSqliteMaster count] == 0){		
		[self CREATETABLES];
        //Insert Values
		return YES;
	}	
	return NO;
}

-(BOOL)checkForVersionTable:(float)fVersion{
	
	float fVersionNumber=0.0f;
	
	NSArray *results = [m_objSqlite executeQuery: @"SELECT name FROM sqlite_master WHERE type='table' AND name='version';"];   
    for (NSDictionary *dictionary in results) {
		NSString *strcount  =  [dictionary objectForKey:@"name"];
		if([strcount isEqualToString:@"version"]){
			
			NSArray *tmpResults = [m_objSqlite executeQuery:@"SELECT version from version;"];
			
			for (NSDictionary *tmpDictionary in tmpResults) {
				
				fVersionNumber = [[tmpDictionary objectForKey:@"version"] floatValue];
				
				if (fVersionNumber < fVersion) {
					return NO;
				}
				else {
					return YES;
				}

			}
			
		}
		else {
			return NO;
		}

    }   
	return NO;
	
}



-(void)deleteDB:(NSString *)str_filename{
	//************************************Delete**********************************************
	// For error information
	NSError *error;
	// Create file manager
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	
	// Point to Document directory
	NSString *documentsDirectory = [NSHomeDirectory() 
									stringByAppendingPathComponent:@"Documents"];			
	
	
	NSString *filePath = [documentsDirectory 
						  stringByAppendingPathComponent:str_filename];
	
	if ([fileMgr removeItemAtPath:filePath error:&error] != YES)
		NSLog(@"Unable to delete file: %@", [error localizedDescription]);
	
	// Show contents of Documents directory
	NSLog(@"Documents directory: %@",
		  [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
}

-(void)removeOldDbAndCreateNewOne{
	
	[self deleteDB:@"TDM.db"];
	[self CREATEDATABASE:@"TDM.db"];
	
}

//Copy Db to document folder if Db not found
- (void)COPY_DB_TO_DOCUMENT_FOLDER {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"TDM.db"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TDM.db"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

- (void) CREATETABLES {
    
    [m_objSqlite executeNonQuery:@"CREATE TABLE [Business] (businessid varchar NOT NULL PRIMARY KEY,businesstype varchar,name varchar,address varchar,logo varchar,favflag varchar,rating integer,hot boolean,top boolean,cheap boolean,res100 boolean,reviewcount integer);"];
    [m_objSqlite executeNonQuery:@"CREATE TABLE [City] (cityid varchar NOT NULL PRIMARY KEY,cityname varchar);"];
    [m_objSqlite executeNonQuery:@"CREATE TABLE [Reviews] (reviewid varchar NOT NULL PRIMARY KEY,businessid varchar REFERENCES Business (businessid),reviewname varchar,reviewheading varchar,reviewimage varchar,reviewdescription varchar,reviewdate date);"];
    [m_objSqlite executeNonQuery:@"CREATE TABLE [SignatureDish] (signaturedishid varchar NOT NULL PRIMARY KEY,businessid varchar,signaturedishname varchar,image varchar,description varchar,rating varchar,foursquareid varchar,latitude varchar,longitude varchar,username varchar);"];
    [m_objSqlite executeNonQuery:@"CREATE TABLE [User] (userid varchar NOT NULL PRIMARY KEY,username varchar NOT NULL,email varchar,sessionid text,userimage varchar);"];
    [m_objSqlite executeNonQuery:@"CREATE TABLE [Version] (version text PRIMARY KEY);"];
    [m_objSqlite executeNonQuery:@"CREATE TABLE [favorites](businessid varchar NOT NULL,userid varchar NOT NULL);"];
    [m_objSqlite executeNonQuery:@"CREATE TABLE [WishList] (uid varchar,venueid varchar,venuename varchar,venueaddress varchar,venuephone varchar);"];
	NSLog(@"Tables Created");
}


-(void)insertIntoWishList:(NSString *)userID VenueID:(NSString *)venueID venueName:(NSString *)venueName address:(NSString *)venueAddress venuePhone:(NSString *)venuePhone {
    [m_objSqlite executeNonQuery:@"INSERT INTO WishList (uid, venueid, venuename, venueaddress, venuephone) VALUES (?,?,?,?,?);",userID,venueID,venueName,venueAddress, venuePhone];
}



-(void)insertIntoUserTable:(NSString *)userName email:(NSString *)email userID:(NSString *)uid sessionID:(NSString *)sessionID userImage:(NSString *)uImage {
    
    @try {
       [m_objSqlite executeNonQuery:@"DROP TABLE if exists User;"];
        [m_objSqlite executeNonQuery:@"CREATE TABLE [User] (userid varchar NOT NULL PRIMARY KEY,username varchar NOT NULL,email varchar,sessionid text,userimage varchar);"];

        [m_objSqlite executeNonQuery:@"INSERT INTO User (userid,username,email,sessionid,userimage) VALUES(?,?,?,?,?);",uid,userName,email,sessionID,uImage];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
        
    }

}
- (void)updateUserTable:(NSString *)image
{
    @try {
        [m_objSqlite executeNonQuery:@"UPDATE User SET userimage = ?",image];
         }
         @catch (NSException *exception) {
             NSLog(@"%@",exception.description);
         }
         @finally {
             
         }

}

- (void)insertIntoFavoritesTable:(BussinessModel *)model userId:(NSString *)userId type:(NSString *)businessType
{
     @try{
        
         NSString *bid = [NSString stringWithFormat:@"%@",model.venueId];
         NSString *foursquareId = model.fourSquareId; 
         NSString *businessName = model.name; 
         NSString *address;
         if (model.locationAddress) 
         {
             address = model.locationAddress; 
         }
         else
         {
             address = @" ";
         }
        // NSString *address = model.locationAddress; 
         NSString *phno;
         if (model.contactPhone) 
         {
            phno = model.contactPhone; 
         }
         else
         {
             phno = @" ";
         }
         NSString *categoryName = model.categoryName; 
         NSString *website;
         if (model.url) 
         {
             website = model.url;
         }
         else
         {
             website = @" ";
         }
         NSString *note = @" "; 
         NSString *hours = @" "; 
         NSString *latitude = model.locationLatitude;
         NSString *longitude = model.locationLongitude; 
         NSString *urlpath= @"";
         if([model.categoryImages count]>0)
         {
             urlpath = [model.categoryImages lastObject];
         }
         else if (model.imageURL)
         {
             urlpath = model.imageURL;
         }
         else
         {
             urlpath = @" ";
         }
     
         [m_objSqlite executeNonQuery:@"INSERT INTO favorites (userid,businessid,foursquareid,name,address,phoneNumber,category,website,note,hours,latitude,longitude,type,image) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?);",userId,bid,foursquareId,businessName,address,phno,categoryName,website,note,hours,latitude,longitude,businessType,urlpath];
     }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
        
    }

    
}

-(NSDictionary *)getWishListForFoursquareId:(NSString *)foursquareid
{
    NSDictionary *userInfo = [self getUserDetailsFromDataBase];
    NSString *userId = [userInfo objectForKey:@"userid"];
    
    NSArray *results = [m_objSqlite executeQuery:@"SELECT * FROM favorites WHERE foursquareid = ? AND userid = ?",foursquareid,userId];
    if (results.count == 0) {
        return nil;
    }
    NSDictionary * retDictionary = [results objectAtIndex:0];  

    return retDictionary;
}

-(NSDictionary *)getWishListForBusinessId:(NSString *)businessid
{
    NSDictionary *userInfo = [self getUserDetailsFromDataBase];
    NSString *userId = [userInfo objectForKey:@"userid"];
    
    NSArray *results = [m_objSqlite executeQuery:@"SELECT * FROM favorites WHERE businessid = ? AND userid = ?",businessid,userId];
    if (results.count == 0) {
        return nil;
    }
    NSDictionary * retDictionary = [results objectAtIndex:0];  
    
    return retDictionary;
}



-(NSDictionary *)getWishListItemsForUser:(NSString *)uid {
    
    NSArray * results = [m_objSqlite executeQuery:@"SELECT * from WishList WHERE uid=?",uid];
    
    if (results.count == 0) {
        return nil;
    }
    
    NSDictionary * retDictionary = [results objectAtIndex:0];
    
    return retDictionary;
}

- (NSDictionary *)getFavoritesFromDataBase:(NSString *)uid 
{
    NSArray *results = [m_objSqlite executeQuery:@"SELECT * FROM favorites WHERE userid = ?",uid];
    if (results.count == 0) {
        return nil;
    }
    NSDictionary * retDictionary = [results objectAtIndex:0];  

    return retDictionary;
}

- (NSArray *)getAllBusinessIDForUserID:(NSString *)uid 
{
    NSArray *results = [m_objSqlite executeQuery:@"SELECT * FROM favorites WHERE userid = ?",uid];
    if (results.count == 0)
    {
        return nil;
    }    
    return results;
}
-(NSMutableArray *)getBusinessIDForFourSquareID:(NSString *)foursquareID
{
    NSArray *businessID = [m_objSqlite executeQuery:@"SELECT * FROM SignatureDish where foursquare_id = ?",foursquareID];
    
    return (NSMutableArray *)businessID;
}
-(NSDictionary *)getUserDetailsFromDataBase
{
    NSArray *results = [m_objSqlite executeQuery:@"SELECT * FROM User;"];
    if (results.count == 0)
    {
        return nil;
    }
    
    NSDictionary * retDictionary = [results objectAtIndex:0];  

    return retDictionary;
}
-(NSMutableArray *)getSignatureDishdetailsFromDB{
    NSArray *resultSet = [m_objSqlite executeQuery:@"SELECT * FROM SignatureDish"];

    return (NSMutableArray *)resultSet;

}
-(NSMutableArray *)getCurrentLocationSignatureDishDetails:(double)lattitude longitude:(double)longitude {
    
    
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
    
     NSArray *resultSet = [m_objSqlite executeQuery:@"SELECT * FROM SignatureDish"];

    for (int i = 0; i< [resultSet count]; i++) 
    {
        
        NSDictionary *tempDict = [resultSet objectAtIndex:i];
        
        double dbLattitude = [[tempDict valueForKey:@"latitude"] doubleValue];
        double dbLongitude = [[tempDict valueForKey:@"longitude"] doubleValue];
  
        CLLocation *currentLocationDiff = [[CLLocation alloc] initWithLatitude:lattitude longitude:longitude];
        CLLocation *dbLocationDiff = [[CLLocation alloc] initWithLatitude:dbLattitude longitude:dbLongitude];
        
        [currentLocationDiff release];
        [dbLocationDiff release];
        
        
        if ([results count] == 10) {
            
            break;
        }

    }
    return results;
}

- (NSMutableArray *)getDetailsOfNearByRestaurants:(double)latitude longitude:(double)longitude
{
    NSMutableArray *results=[[[NSMutableArray alloc] init]autorelease];
    
    NSArray *resultSet = [m_objSqlite executeQuery:@"SELECT * FROM favorites"];

    for (int i = 0; i< [resultSet count]; i++) 
    {
        
        NSDictionary *tempDict = [resultSet objectAtIndex:i];
        
        double dbLatitude = [[tempDict valueForKey:@"latitude"] doubleValue];
        double dbLongitude = [[tempDict valueForKey:@"longitude"] doubleValue];
        NSString *businessId = [tempDict valueForKey:@"foursquareid"] ;
        NSString *businessName = [tempDict valueForKey:@"name"];
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        CLLocation *dbLocation = [[CLLocation alloc] initWithLatitude:dbLatitude longitude:dbLongitude];
        
        float distance = [currentLocation distanceFromLocation:dbLocation];
        if (distance <= 1000) 
        {
            NSMutableDictionary *locationDict = [[[NSMutableDictionary alloc]init]autorelease];
            [locationDict setObject:[NSNumber numberWithFloat:distance] forKey:@"distance"];
            [locationDict setObject:businessId forKey:@"bid"];
            [locationDict setObject:businessName forKey:@"bname"];
            [results addObject:locationDict];
        }
        
        
        
        [currentLocation release];
        [dbLocation release];
        
    
        
    }
    //Dummy signature dishes. If there is no near by signature dishes    
    return results;

}

- (NSMutableArray *)getBusinessInWishListFromDataBase{
    NSArray *resultSet = [m_objSqlite executeQuery:@"SELECT * FROM favorites"];
    
    return (NSMutableArray *)resultSet;
    
}

-(void)deleteUserDataBase {
    [m_objSqlite executeNonQuery:@"DROP TABLE User;"];
}

@end