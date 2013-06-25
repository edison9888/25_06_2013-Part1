//
//  TDMCityListService.m
//  TheDailyMeal
//
//  Created by Apple on 02/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMCityListService.h"
#import "Reachability.h"

@implementation TDMCityListService
@synthesize cityListDelegate;

-(void) getListOfCities
{
    NSString *url = [NSString stringWithFormat:@"%@%@",DAILYMEAL_SEVER_PROD,@"/rest/app/taxonomy_vocabulary/getTree"];
    
    NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [dictionary setObject:@"27" forKey:@"vid"];
    [dictionary setObject:@"0" forKey:@"parent"];
    NSString *loginAPIJSONBody = [dictionary JSONRepresentation];
    
    
    if([Reachability connected])
    {
        [self postRequest:url RequestBody:loginAPIJSONBody];
    }
    else
    {
        if(self.cityListDelegate && [cityListDelegate respondsToSelector:@selector(networkError)])
        {
            [self.cityListDelegate networkError];
        }
    }

}

- (void)requestFinished:(ASIHTTPRequest *)request 
{
    if(request.responseStatusCode == 200)
    {
        NSMutableArray *finalArray =[[NSMutableArray alloc]init];
        if([[request.responseString JSONValue] isKindOfClass:NSClassFromString(@"NSArray")])
        {
            NSArray *responseArray = [request.responseString JSONValue];
            if([responseArray count]>0)
            {
                for (int i=0; i<[responseArray count]; i++) {
                    if([[responseArray objectAtIndex:i] isKindOfClass:NSClassFromString(@"NSDictionary")])
                    {
                        NSDictionary *responseDictionary = [responseArray objectAtIndex:i];
                        if([[responseDictionary objectForKey:@"name"] isKindOfClass:NSClassFromString(@"NSString")])
                        {
                            [finalArray addObject:[responseDictionary objectForKey:@"name"]];
                        }
                    }
                }
            }
        }
        if(self.cityListDelegate && [self.cityListDelegate respondsToSelector:@selector(gotCityList:)])
        {
            [self.cityListDelegate gotCityList:finalArray];
        }
    }
    else
    {
        if(self.cityListDelegate && [self.cityListDelegate respondsToSelector:@selector(failedToGetCityList)])
            [self.cityListDelegate failedToGetCityList];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    [super requestFailed:request];
    if(self.cityListDelegate && [self.cityListDelegate respondsToSelector:@selector(failedToGetCityList)])
        [self.cityListDelegate failedToGetCityList];
}

- (void)dealloc {
    
    self.cityListDelegate = nil;
    [super dealloc];
}

@end
