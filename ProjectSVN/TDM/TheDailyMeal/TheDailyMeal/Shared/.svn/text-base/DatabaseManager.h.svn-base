//
//  BrightonAppDelegate.h
//  Brighton
//
//  Created by Timmi on 09/06/10.
//  Copyright RVS 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sqlite.h"
#import "SignatureDish.h"

@protocol DatabaseManagerDelegate <NSObject>
@end

@interface DatabaseManager : NSObject {
	Sqlite *m_objSqlite;
	NSMutableArray *m_objResultArray;	
}
@property(nonatomic,retain)	Sqlite *m_objSqlite;
+ (DatabaseManager*)sharedManager;

//DELEGATES
//==========
+(id)delegate;	
+(void)setDelegate:(id)newDelegate;

//DATABASE FUCTIONS
//===================================================

- (BOOL) CREATEDATABASE :(NSString*)strdbname; 
- (void) CREATETABLES;
- (void) INSERT_VALUES;
- (void)COPY_DB_TO_DOCUMENT_FOLDER;



//Insert functions...
-(void)insertIntoUserTable:(NSString *)userName
                     email:(NSString *)email
                    userID:(NSString *)uid
                 sessionID:(NSString *)sessionID
                 userImage:(NSString *)uImage;

-(NSDictionary *)getUserDetailsFromDataBase;

-(NSMutableArray *)getCurrentLocationSignatureDishDetails:(double)lattitude longitude:(double)longitude;

-(void)deleteUserDataBase;

- (SignatureDish *)addSignatureDishDetails:(NSDictionary *)dic;

-(void)insertIntoWishList:(NSString *) userID VenueID:(NSString *) venueID venueName:(NSString *) venueName address:(NSString *) venueAddress venuePhone:(NSString *) venuePhone;
-(NSDictionary *)getWishListItemsForUser:(NSString *) uid;
- (NSDictionary *)getFavoritesFromDataBase:(NSString *)uid;
- (void)insertIntoFavoritesTable:(NSString *)userId businessId:(NSString *)bid foursquareId:(NSString *)foursquareId name:(NSString *)businessName address:(NSString *)address phno:(NSString *)phno category:(NSString *)categoryName website:(NSString *)website note:(NSString *)note hours:(NSString *)hours lat:(NSString *)latitude lon:(NSString *)longitude type:(NSString *)businessType;

- (NSArray *)getAllBusinessIDForUserID:(NSString *)uid;
@end
