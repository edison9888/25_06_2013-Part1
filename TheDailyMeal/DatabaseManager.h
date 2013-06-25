//
//  BrightonAppDelegate.h
//  Brighton
//
//  Created by Timmi on 09/06/10.
//  Copyright RVS 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sqlite.h"
#import "BussinessModel.h"

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
//- (void) INSERT_VALUES;
- (void)COPY_DB_TO_DOCUMENT_FOLDER;



//Insert functions...
-(void)insertIntoUserTable:(NSString *)userName
                     email:(NSString *)email
                    userID:(NSString *)uid
                 sessionID:(NSString *)sessionID
                 userImage:(NSString *)uImage;



-(NSMutableArray *)getBusinessIDForFourSquareID:(NSString *)foursquareID;
-(NSDictionary *)getUserDetailsFromDataBase;
-(NSMutableArray *)getSignatureDishdetailsFromDB;
-(NSMutableArray *)getCurrentLocationSignatureDishDetails:(double)lattitude longitude:(double)longitude;

-(void)deleteUserDataBase;

//- (SignatureDish *)addSignatureDishDetails:(NSDictionary *)dic;

-(void)insertIntoWishList:(NSString *) userID VenueID:(NSString *) venueID venueName:(NSString *) venueName address:(NSString *) venueAddress venuePhone:(NSString *) venuePhone;
-(NSDictionary *)getWishListItemsForUser:(NSString *) uid;
- (NSDictionary *)getFavoritesFromDataBase:(NSString *)uid;
-(NSDictionary *)getWishListForFoursquareId:(NSString *)foursquareid;
- (NSMutableArray *)getBusinessInWishListFromDataBase;
-(NSDictionary *)getWishListForBusinessId:(NSString *)businessid;

- (void)insertIntoFavoritesTable:(BussinessModel *)model userId:(NSString *)userId type:(NSString *)businessType;

- (NSArray *)getAllBusinessIDForUserID:(NSString *)uid;
- (NSMutableArray *)getDetailsOfNearByRestaurants:(double)latitude longitude:(double)longitude;
- (void)updateUserTable:(NSString *)image;
@end
