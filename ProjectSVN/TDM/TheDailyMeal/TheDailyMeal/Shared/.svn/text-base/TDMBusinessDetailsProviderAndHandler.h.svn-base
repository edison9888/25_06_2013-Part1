//
//  TDMBusinessDetailsProviderAndHandler.h
//  TheDailyMeal
//
//  Created by Nithin George on 06/02/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDMURLHandler.h"
#import "ASIHTTPRequest.h"
#import "TDMBaseHttpHandler.h"
#import "SBJson.h"

@protocol TDMBusinessDetailsProviderAndHandlerDelegate <NSObject>

-(void)gotRestaurantDetails;
-(void)failedToFetchRestaurantDetails;

@end

@interface TDMBusinessDetailsProviderAndHandler : TDMBaseHttpHandler
{
    NSArray *groups;
    NSDictionary * responseDictionary;
    NSDictionary *response     ;
    NSDictionary *insideDictionary;
    NSArray *itemsArray ;
    NSDictionary *itemDictionary;    
    NSDictionary *contacts;
    NSMutableDictionary *location;
    NSDictionary *categories; 
    NSDictionary *categoryInsideCategories;
    NSArray *parentArray;
    NSDictionary *stats;
    NSArray *specials;
    NSDictionary *hereNow;        
    NSMutableArray *businessDetailsArary;
    NSString *searchCriteria;
    
    id <TDMBusinessDetailsProviderAndHandlerDelegate> businessDetailsDelegate;
}

@property (nonatomic,retain) id <TDMBusinessDetailsProviderAndHandlerDelegate> businessDetailsDelegate;


@property(nonatomic,retain)NSArray *groups;
@property(nonatomic,retain)NSDictionary * responseDictionary;
@property(nonatomic,retain)NSDictionary *response     ;
@property(nonatomic,retain)NSDictionary *insideDictionary;
@property(nonatomic,retain)NSArray *itemsArray ;
@property(nonatomic,retain)NSDictionary *itemDictionary;    
@property(nonatomic,retain)NSDictionary *contacts;
@property(nonatomic,retain)NSDictionary *location;
@property(nonatomic,retain)NSDictionary *categories; 
@property(nonatomic,retain)NSDictionary *categoryInsideCategories;
@property(nonatomic,retain)NSArray *parentArray;
@property(nonatomic,retain)NSDictionary *stats;
@property(nonatomic,retain)NSArray *specials;
@property(nonatomic,retain)NSDictionary *hereNow;        
@property(nonatomic,retain)NSMutableArray *businessDetailsArary;
@property(nonatomic,retain)NSString *searchCriteria;

@end
