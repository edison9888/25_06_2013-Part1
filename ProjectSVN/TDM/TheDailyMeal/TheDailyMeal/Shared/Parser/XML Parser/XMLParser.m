//
//  XMLParser.m
//  TheDailyMeal
//
//  Created by Nithin George on 06/01/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "XMLParser.h"

#define RSS_START_TAG @"item"

#define KTITLE @"title"
#define KLINK @"link"
#define KIMAGEURL @"enclosure"
#define KDESCRIPTION @"description"
#define KPUBDATE @"pubDate"

#define CHANNEL_IMAGE_DETAIL_TAG @"enclosure"
#define CHANNEL_IMAGE_URL @"url"

@interface XMLParser (Private)

-(void)releaseAllocatedMemories;

@end

@implementation XMLParser

@synthesize channelDetails;
@synthesize myDelegate;


- (void)parserDidStartDocument:(NSXMLParser *)parser{	
    
	NSLog(@"found file and started parsing");
	
}

- (void)parseXMLFileAtURL:(NSString *)URL
{	
	stories = [[NSMutableArray alloc] init];

    NSURL *xmlURL = [NSURL URLWithString:URL];

    rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];

    [rssParser setDelegate:self];

    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
	
    [rssParser parse];
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
    REMOVE_FROM_MEMORY(errorAlert);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			

    //NSLog(@"attributeDict:::::::::%@",attributeDict);
    
	currentElement = [elementName copy];
	if ([elementName isEqualToString:RSS_START_TAG]) {
		// creating the channel model class objects
        channelDetails = [[TDMChannelDetails alloc]init];
        
        currentTitle            = [[NSMutableString alloc] init];
		currentLink             = [[NSMutableString alloc] init];
		currentDescription      = [[NSMutableString alloc] init];
        currentPubDate          = [[NSMutableString alloc] init];
                
	}

    else if ([elementName isEqualToString:CHANNEL_IMAGE_DETAIL_TAG]) 
    {
        channelDetails.channelImageURL = [attributeDict objectForKey:CHANNEL_IMAGE_URL];
    
    }
    

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     

	if ([elementName isEqualToString:RSS_START_TAG]) {
		// save values to an item, then store that item into the array...
        channelDetails.channelTitle         = currentTitle;
        channelDetails.channelLink          = currentLink;
        channelDetails.channelDescription   = currentDescription;
        channelDetails.channelPubDate       = currentPubDate;
       
		[stories addObject:channelDetails];
        
        [self releaseAllocatedMemories];
        
    }
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

    //NSLog(@"found characters: %@", string);
	// save the characters for the current item...
    
	if ([currentElement isEqualToString:KTITLE]) {
        
		[currentTitle appendString:string];
	}
    
    else if ([currentElement isEqualToString:KLINK]) {
        
		[currentLink appendString:string];
	} 
    
    else if ([currentElement isEqualToString:KDESCRIPTION]) {
        
		[currentDescription appendString:string];
	}
    
    else if ([currentElement isEqualToString:KPUBDATE]) {
        
		[currentPubDate appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {

    if(self.myDelegate!=nil && [self.myDelegate respondsToSelector:@selector(didFinished:)])
        [self.myDelegate didFinished:stories];
}


#pragma mark AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(self.myDelegate!=nil && [self.myDelegate respondsToSelector:@selector(didFailedWithError)])
        [self.myDelegate didFinished:nil];
}


#pragma mark- Release Memory
-(void)releaseAllocatedMemories
{
    REMOVE_FROM_MEMORY(channelDetails);
    
	REMOVE_FROM_MEMORY(currentElement);
    REMOVE_FROM_MEMORY(currentTitle);
    REMOVE_FROM_MEMORY(currentPubDate);
    REMOVE_FROM_MEMORY(currentDescription);
    REMOVE_FROM_MEMORY(currentLink);
}

- (void)dealloc {
    
    [super dealloc];
}





@end


