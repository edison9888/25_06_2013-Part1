//
//  XMLParser.m
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.


#import "XMLParser.h"
#import "DBHandler.h"
#import "Image.h"
#import "Utilities.h"

// string contants found in the RSS feed
static NSString *kItem          = @"item";
static NSString *kTitle         = @"title";
static NSString *kDescription   = @"description";
static NSString *kLink          = @"link";
//static NSString *kLastBuildDate = @"lastBuildDate";
static NSString *kPubDate       = @"pubDate";


@implementation XMLParser

@synthesize delegate;
@synthesize identifier;
@synthesize workingArray;
@synthesize workingEntry;
@synthesize workingPropertyString;
@synthesize elementsToParse;
@synthesize storingCharacterData;

@synthesize lastBuildDate;

- (XMLParser *) initXMLParser {
	
	[super init];
    self.workingArray = [NSMutableArray array]; 
    self.workingPropertyString = [NSMutableString string];
    images=[[NSMutableArray alloc]init];
    self.elementsToParse = [NSArray arrayWithObjects:kTitle, kDescription, kLink,kPubDate, nil];
    return self;
}

-(void)parseData:(NSData *)data{
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
	[xmlParser setDelegate:self];
	//Start parsing the XML file.
	BOOL success = [xmlParser parse];
	if(success)
    {
        DebugLog(@"No Errors");
    }		
	else
    {
        DebugLog(@"Error Error Error!!!");
    }
    
    [xmlParser release];
    xmlParser = nil;
    
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:kItem]) {
        
        //model class
        self.workingEntry = [[[List alloc] init] autorelease]; 
        self.workingEntry.images=[[NSMutableArray alloc] init];//if we r not allocating memory then we can't add objects 
        [workingPropertyString setString:@""]; 
    }
    
    storingCharacterData = [elementsToParse containsObject:elementName];
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string { 
    
    if (storingCharacterData)
    {
        //[workingPropertyString setString:@""];    
        [workingPropertyString appendString:string];
        
    }
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 

{
    
    
    if (self.workingEntry)
	{
        
        if (storingCharacterData)
        {
            
           // workingPropertyString = ;
            
            NSString *trimmedString = [workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([elementName isEqualToString:kTitle])
            {        
                self.workingEntry.title = trimmedString;
            }
            else if ([elementName isEqualToString:kDescription])
            {
                self.workingEntry.description = trimmedString;
                //For finding the thumb and content images
                [self parseImageLink:trimmedString imageType:SMALL_IMAGE];
                [self parseImageLink:trimmedString imageType:LARGE_IMAGE];
            }
            else if ([elementName isEqualToString:kPubDate])
            {
                self.workingEntry.pubDate = trimmedString;
            }
            else if ([elementName isEqualToString:kLink])
            {
                self.workingEntry.link = trimmedString;
            }
            
            else if ([elementName isEqualToString:kItem])
            {
                self.workingEntry.parent_idmenu = identifier; 
                self.workingEntry.lastBuildDate = lastBuildDate;
                [self.workingArray addObject:self.workingEntry];
                self.workingEntry = nil;;
            }
       
            [workingPropertyString setString:@""]; 
        }
        
     //[workingPropertyString setString:@""];
    }
    
}



// -------------------------------------------------------------------------------
//	didFinishParsing:appList
// -------------------------------------------------------------------------------
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    DBHandler *dbHandler =[DBHandler sharedManager];
    dbHandler.delegate=self;
    [dbHandler deleteListImageRows:identifier];
    [dbHandler deleteListRows:identifier];
    [dbHandler performSelectorInBackground:@selector(insertList:) withObject:self.workingArray];  
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    int parent = [dbHandler getparentIDMenu:identifier];
    NSString *folderPath = [NSString stringWithFormat:@"%@/PE.com/%d/%d", documentsDirectoryPath,parent,identifier];

    
    if ([[NSFileManager defaultManager] fileExistsAtPath:folderPath])
    {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:folderPath error:NULL];
    }

    
    //[dbHandler release];
    dbHandler = nil;
    
}

#pragma DB Handler Delegate Method

-(void)savedData{
    
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(parsingCompleted:)])
        [self.delegate parsingCompleted:self];
}
#pragma  mark - method for finding the icons parths

//Finding the thumb image paths from the descriptions
- (void )parseImageLink:(NSString *) htmlString imageType:(int)imageType {
    
    NSString *parserTag=nil;
    
    if(imageType==SMALL_IMAGE)
        parserTag=SRCTAG;
    else
        parserTag=HREFTAG;
    
    NSMutableArray *srcImages =[[htmlString componentsSeparatedByString:parserTag] mutableCopy];
    [srcImages removeObjectAtIndex:0];
    
    for(NSString *url in srcImages) {
        
        if ([url rangeOfString:LARGEJPG].location != NSNotFound || [url rangeOfString:SMALLJPG].location != NSNotFound || [url rangeOfString:LARGEPNG].location != NSNotFound || [url rangeOfString:SMALLPNG].location != NSNotFound  ) {
            
            //separated by url
            NSArray *newUrl = [url componentsSeparatedByString:URLENDELEMENT];
            Image *imgs=[[Image alloc]init];
            imgs.imageType=imageType;
            imgs.imageUrl=[newUrl objectAtIndex:0]; 
            [self.workingEntry.images addObject:imgs];
            [imgs  release];
            imgs = nil;
        } 
//        else {
//            
//            DebugLog(@"string does not contain the correct url");
//            
//        }
        
        
    }
}



- (void) dealloc {
    
    [self.workingArray release];
    [images release];
    [self.workingEntry release];
    [self.workingPropertyString release];
    [self.elementsToParse release];
    [self.lastBuildDate release];
	[super dealloc];
}

@end
