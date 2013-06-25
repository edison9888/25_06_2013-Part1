//
//  TDMBusinessImageService.m
//  TheDailyMeal
//
//  Created by Apple on 22/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TDMBusinessImageService.h"
#import "Reachability.h"

@implementation TDMBusinessImageService

@synthesize businessImageDelegate;
@synthesize tempBusinessModel;

-(void) getCategoryImagesForBusiness:(BussinessModel *)businessModel {

    self.tempBusinessModel = businessModel;
    if (![businessModel.fourSquareId isEqualToString:@""]) {
        if ([Reachability connected]) 
        {   
            NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@",FOURSQURE_SERVER_URL,@"v2/venues/",businessModel.fourSquareId, @"/photos?"];
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            NSMutableDictionary * getParams = [[NSMutableDictionary alloc] init];
            [getParams setObject:FOURSQUARE_CLIENTID forKey:kFourSquareClientID];
            [getParams setObject:FOURSQUARE_SECRETID forKey:kFourSquareSecretID]; 
            
            [self getRequest:urlString withParams:getParams];
            
            [getParams release];
            getParams = nil;   
            
            if(pool)
                [pool drain];
        }
        else
        {
            if (self.businessImageDelegate && [self.businessImageDelegate respondsToSelector:@selector(networkError)]) {
                [businessImageDelegate networkError];
            }
            
        }
  
    }
    else
    {
        if (self.businessImageDelegate && [self.businessImageDelegate respondsToSelector:@selector(networkError)]) {
            [businessImageDelegate networkError];
        } 
    }

}
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    BOOL got100X100Image = NO;
    NSDictionary *jsonResponse = [request.responseString JSONValue];
    NSDictionary *response;
    NSDictionary *photos ;
    NSMutableArray *finalArray = [[NSMutableArray alloc]init];
    NSMutableArray *defaultArray = [[NSMutableArray alloc]init];
    NSMutableArray *groups ;
    if([[jsonResponse objectForKey:@"response"] isKindOfClass:NSClassFromString(@"NSDictionary")]){
        response = [jsonResponse objectForKey:@"response"];
        if([[response objectForKey:@"photos"] isKindOfClass:NSClassFromString(@"NSDictionary")]) {
            photos = [response objectForKey:@"photos"];
            if([[photos objectForKey:@"groups"] isKindOfClass:NSClassFromString(@"NSMutableArray")]){
                groups = [photos objectForKey:@"groups"];
                if([groups count]>=2) {
                    NSDictionary *type = [groups objectAtIndex:1];
                    if([type isKindOfClass:NSClassFromString(@"NSDictionary")]) {
                        if([[type objectForKey:@"items"] isKindOfClass:NSClassFromString(@"NSArray")]){
                            NSMutableArray *items = [type objectForKey:@"items"];
                            for (NSDictionary * dictionary in items) {
                            
                                if([[dictionary objectForKey:@"url"] isKindOfClass:[NSString class]])
                                {
                                    [defaultArray addObject:[dictionary objectForKey:@"url"]];
                                }
                                
                                if([[dictionary objectForKey:@"sizes"] isKindOfClass:[NSDictionary class]])
                                {
                                    NSMutableDictionary *imageDictionary = [dictionary objectForKey:@"sizes"];
                                    
                                    
                                    if([[imageDictionary objectForKey:@"items"] isKindOfClass:[NSArray class]])
                                    {
                                        NSMutableArray *imageArray = [imageDictionary objectForKey:@"items"];
                                        if([imageArray count]>0)
                                        {
                                            for (NSDictionary *imageSizeDictionary in imageArray ) {
                                                
                                                if([imageSizeDictionary objectForKey:@"width"] && [imageSizeDictionary objectForKey:@"height"])
                                                {
                                                    
                                                    NSString * width = [NSString stringWithFormat:@"%@",[imageSizeDictionary objectForKey:@"width"]];
                                                    NSString * height = [NSString stringWithFormat:@"%@",[imageSizeDictionary objectForKey:@"height"]];
                                                                                                    
                                                    if([width isEqualToString:@"100"] && [height isEqualToString:@"100"])
                                                    {
                                                        [finalArray addObject:[imageSizeDictionary objectForKey:@"url"]];
                                                        got100X100Image = YES;
                                                        break;
                                                    }
                                                    else
                                                    {
                                                        if(got100X100Image)
                                                        {
                                                            got100X100Image = NO;
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }
                                        }
                                    }
                                }

                            }
                        }
                    }
                }
            }
        }
    }
    [self.tempBusinessModel setDefaultCategoryImages:defaultArray];
    [self.tempBusinessModel setCategoryImages:finalArray];
    [self.tempBusinessModel setCategoryImagesFetched:YES];
    [finalArray release];
    finalArray = nil;
    if (self.businessImageDelegate && [self.businessImageDelegate respondsToSelector:@selector(thumbnailReceivedForBusiness:)]) {
        [businessImageDelegate thumbnailReceivedForBusiness:tempBusinessModel];
    }
    
    self.businessImageDelegate = nil;
}

- (NSString *)getCurrentDateFormat
{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:currentDate];
    NSInteger day = [dateComponents day];
    dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:currentDate];
    NSInteger month = [dateComponents month];
    dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:currentDate];
    NSInteger year = [dateComponents year];
    NSString *dateValue = [NSString stringWithFormat:@"%d%02d%02d",year,month,day];
    return dateValue;
}

- (void)dealloc
{
    self.tempBusinessModel = nil;
    self.businessImageDelegate = nil;
    [super dealloc];
}

@end
