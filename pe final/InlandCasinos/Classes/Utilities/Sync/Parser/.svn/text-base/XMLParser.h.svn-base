//
//  XMLParser.h
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>
#import "List.h"
#import "DBHandler.h"

@class XMLParser;

@protocol XMLParserDelegate <NSObject>

-(void)parsingCompleted:(XMLParser *)parser;
-(void)parsingFailed:(NSError *)error;

@end

@interface XMLParser : NSObject<NSXMLParserDelegate,DBDelegate> {
    
    int identifier;
    
    //date from downloadmanager
    NSString *lastBuildDate;
    
    //For storing the list model class objects
    NSMutableArray *workingArray;
    NSMutableArray *images;
    
    id <XMLParserDelegate> delegate;
    
    List            *workingEntry;
    NSMutableString *workingPropertyString;
    NSArray         *elementsToParse;
    BOOL            storingCharacterData;
    
}

@property (nonatomic, retain) id <XMLParserDelegate> delegate;
@property (nonatomic, assign) int identifier;

@property (nonatomic, retain) NSString *lastBuildDate;

@property (nonatomic, retain) NSMutableArray *workingArray;
@property (nonatomic, retain) List *workingEntry;
@property (nonatomic, retain) NSMutableString *workingPropertyString;
@property (nonatomic, retain) NSArray *elementsToParse;
@property (nonatomic, assign) BOOL storingCharacterData;

- (XMLParser *) initXMLParser;
-(void)parseData:(NSData *)data;

//for finding the Thumb icon paths
- (void)parseImageLink:(NSString *) htmlString imageType:(int)imageType; 

@end
