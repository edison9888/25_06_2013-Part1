//
//  TDMBusinessIDService.m
//  TheDailyMeal
//
//  Created by Apple on 26/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMBusinessIDService.h"
#import "BussinessModel.h"
#import "Reachability.h"
#import "TDMBusinessViewController.h"

@implementation TDMBusinessIDService
@synthesize businessIDdelegate;

-(void) getBusinessVenueIDFofBusiness:(BussinessModel *)businessDetails
{
    
    NSLog(@"%@",businessDetails.fourSquareId);
    if([Reachability connected])
    {
    NSString *url = [NSString stringWithFormat:@"%@%@",DAILYMEAL_SEVER_PROD,@"/rest/app/tdm_foursquare"];
 
    NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [dictionary setObject:@"foursquare" forKey:@"type"];
    if([businessDetails.name isKindOfClass:NSClassFromString(@"NSString")]) {
        
        [dictionary setObject:businessDetails.name forKey:@"name"];
    }
    else {
        [dictionary setObject:@"" forKey:@"name"];
    }
    if([businessDetails.fourSquareId isKindOfClass:NSClassFromString(@"NSString")]) {
        [dictionary setObject:businessDetails.fourSquareId forKey:@"id"];
    }
    else {
        [dictionary setObject:@"" forKey:@"id"];
    }
    
    if([businessDetails.locationAddress isKindOfClass:NSClassFromString(@"NSString")]) {
        [dictionary setObject:businessDetails.locationAddress forKey:@"address"];
    }
    else {
        [dictionary setObject:@"" forKey:@"address"];
    }
    if([businessDetails.locationStreet isKindOfClass:NSClassFromString(@"NSString")]) {
        [dictionary setObject:businessDetails.locationStreet forKey:@"crossStreet"];
    }
    else {
        [dictionary setObject:@"" forKey:@"crossStreet"];
    }
    if([businessDetails.locationCity isKindOfClass:NSClassFromString(@"NSString")]) {
        [dictionary setObject:businessDetails.locationCity forKey:@"city"];
    }
    else {
        [dictionary setObject:@"" forKey:@"city"];
    }
    if([businessDetails.locationState isKindOfClass:NSClassFromString(@"NSString")]) {
        [dictionary setObject:businessDetails.locationState forKey:@"state"];
    }
    else{
        [dictionary setObject:@"" forKey:@"state"];
    }
    if([businessDetails.locationPostalCode isKindOfClass:NSClassFromString(@"NSString")]) {
        [dictionary setObject:businessDetails.locationPostalCode forKey:@"postalCode"];
    }
    else{
        [dictionary setObject:@"" forKey:@"postalCode"];
    }
    if([businessDetails.locationCountry isKindOfClass:NSClassFromString(@"NSString")]) {
        [dictionary setObject:businessDetails.locationCountry forKey:@"country"];
    }
    else {
        [dictionary setObject:@"" forKey:@"country"];
    }
    if([businessDetails.locationLongitude isKindOfClass:NSClassFromString(@"NSString")]) {
        [dictionary setObject:businessDetails.locationLongitude forKey:@"lat"];
    }
    else {
        [dictionary setObject:@"" forKey:@"lat"];
    }
    if([businessDetails.locationLongitude isKindOfClass:NSClassFromString(@"NSString")]) {
        [dictionary setObject:businessDetails.locationLongitude forKey:@"lng"];
    }
    else {
        [dictionary setObject:@"" forKey:@"lng"];
    }
    if([businessDetails.contactPhone isKindOfClass:NSClassFromString(@"NSString")]) {
        [dictionary setObject:businessDetails.contactPhone forKey:@"phone"];
    }
    else {
        [dictionary setObject:@"" forKey:@"phone"];
    }
    if([businessDetails.categoryID isKindOfClass:NSClassFromString(@"NSString")]) {
                
        [dictionary setObject:businessDetails.categoryID forKey:@"primary_category_id"];
    }
    else {
        [dictionary setObject:@"" forKey:@"primary_category_id"];
    }
    if([businessDetails.categoryName isKindOfClass:NSClassFromString(@"NSString")]) {
        [dictionary setObject:businessDetails.categoryName forKey:@"primary_category_name"];
    }
    else{
        [dictionary setObject:@"" forKey:@"primary_category_name"];
    }
    NSString *dictionaryString = [dictionary JSONRepresentation];
    
    [self postRequest:url RequestBody:dictionaryString];
    }
    
    else
    {
        if(self.businessIDdelegate && [self.businessIDdelegate respondsToSelector:@selector(failedTOFetchBusinessID)])
        {
            [self.businessIDdelegate failedTOFetchBusinessID];
        }
    }
}

-(void)clearDelegate{
    bCheck=YES;
    self.businessIDdelegate=nil;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{

    if(bCheck){
        self.businessIDdelegate=nil;

    }
    if(request.responseStatusCode ==200)
    {
        int venueID =0;
        if([[request.responseString JSONValue] isKindOfClass:NSClassFromString(@"NSArray")])
        {
            NSArray *responseArray = [request.responseString JSONValue];
            if([responseArray count]>0)
            {
                //if([[responseArray objectAtIndex:0] isKindOfClass:NSClassFromString(@"NSDictionary")])
                {
                    NSMutableDictionary *responseDictionary = [responseArray objectAtIndex:0];
                    //if([[responseDictionary objectForKey:@""] isKindOfClass:NSClassFromString(@"NSString")])
                    {
                        venueID = [[responseDictionary objectForKey:@"vid"] intValue];
                        //if(venueID>0)
                        {
                            if(self.businessIDdelegate && [self.businessIDdelegate respondsToSelector:@selector(businessIDFetchedWithVenueID:)])
                            {
                                [businessIDdelegate businessIDFetchedWithVenueID:venueID];
                            }
                        }
                    }
                }
            }
        }
        else
        {
            if(self.businessIDdelegate && [self.businessIDdelegate respondsToSelector:@selector(failedTOFetchBusinessID)])
            {
                [self.businessIDdelegate failedTOFetchBusinessID];
            }
        }
    }

    else
    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"The Daily Meal" message:@"Please Try Again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release]; 
        if(self.businessIDdelegate && [self.businessIDdelegate respondsToSelector:@selector(failedTOFetchBusinessID)])
        {
            [self.businessIDdelegate failedTOFetchBusinessID];
        }
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    [super requestFailed:request];
    
    if(self.businessIDdelegate && [self.businessIDdelegate respondsToSelector:@selector(failedTOFetchBusinessID)])
    {
        [self.businessIDdelegate failedTOFetchBusinessID];
    }
}

- (void)dealloc {
    
    self.businessIDdelegate = nil;
    [super dealloc];
}

@end
