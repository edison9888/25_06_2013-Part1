    //
//  TDMMakeReservationService.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 20/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMMakeReservationService.h"
#import "TDMMakeReservationModel.h"
#import "Reachability.h"

@implementation TDMMakeReservationService
@synthesize makeReservationDelegate;

- (void)makeReservationCall:(NSString *)businessId
{
    NSString *reservationAPIURLString = [NSString stringWithFormat:@"%@/rest/app/tdm_node/%@/opentable",DAILYMEAL_SEVER_PROD,businessId];
    if([Reachability connected])
    {
        [self getRequest:reservationAPIURLString];
    }
    else
    {
        if(self.makeReservationDelegate && [self.makeReservationDelegate respondsToSelector:@selector(makeReservationResponse)])
        {
            [self.makeReservationDelegate makeReservationResponse];
            kSHOW_ALERT_WITH_MESSAGE(TDM_TITLE, NO_NETWORK_CONNECTIVITY);
        }
    }
}

-(void)clearDelegate{
    bCheck = YES;
    self.makeReservationDelegate=nil;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(bCheck){
        self.makeReservationDelegate=nil;
    }
    if (request.responseStatusCode == 200) 
    {
        NSMutableArray *finalDictionaryArray  =[[[NSMutableArray alloc]init]autorelease];
        id jsonResponse = [request.responseString JSONValue];
        if ([jsonResponse count]>=1)
        {
            if ([jsonResponse isKindOfClass:[NSArray class]]) 
            {
                for(NSDictionary * currentDictionary in jsonResponse)
                {
                    TDMMakeReservationModel *reservationModel = [[[TDMMakeReservationModel alloc]init]autorelease];
                   
                    if ([[currentDictionary objectForKey:@"restaurant_id"] isKindOfClass:NSClassFromString(@"NSString")]) 
                    {
                        reservationModel.businessId = [currentDictionary objectForKey:@"restaurant_id"];
                    }
                    if ([[currentDictionary objectForKey:@"city"] isKindOfClass:NSClassFromString(@"NSString")]) 
                    {
                        reservationModel.cityName = [currentDictionary objectForKey:@"city"];
                    }

                    
                    [finalDictionaryArray addObject:reservationModel];
                }
            }
            
            if (self.makeReservationDelegate && [self.makeReservationDelegate respondsToSelector:@selector(makeReservationServiceResponse:)] ) 
            {
                [makeReservationDelegate makeReservationServiceResponse:finalDictionaryArray];
            }
        }
        else
        {
            if (self.makeReservationDelegate && [self.makeReservationDelegate respondsToSelector:@selector(makeReservationResponse)] ) 
            {
                [makeReservationDelegate makeReservationResponse];
            }

        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [super requestFailed:request];
    if (self.makeReservationDelegate && [self.makeReservationDelegate respondsToSelector:@selector(makeReservationResponse)] ) 
    {
    [makeReservationDelegate makeReservationResponse];
    }
}

- (void)dealloc {
    
    self.makeReservationDelegate = nil;
    [super dealloc];
}

@end
