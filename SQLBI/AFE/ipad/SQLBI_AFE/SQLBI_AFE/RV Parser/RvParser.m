//
//  RvParser.m
//  RvParser
//
//  Created by Elbin John on 31/05/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import "RvParser.h"

@interface RvParser(){
    
}

-(NSArray*)beginJsonParsing:(NSString*)parsingClassName modelClassElements:(id)elements:(id)jsonObject;

-(id)parseJsonToModelClass:(NSString *)parsingClassName modelClassElements:(id )elements:(id)jsonObject:(id)modelClassObject;

-(id)makeModelClass:(NSDictionary*)objects:(id)modelclass:(NSString*)field:(NSString*)mapingField:(NSString*)type:(NSString*)formatte;

@end



@implementation RvParser


-(NSArray*)mapptoModelClass:(NSString*)rootClassName:(id)jsonObject{
    
    
    NSArray * result =nil;
    DLog(@"Begin mapptoModelClass %@",rootClassName);
    
    if(rootClassName && [rootClassName length] && jsonObject && [jsonObject count]){
        
        NSMutableDictionary* jsonMappingList = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:JSON_MAPPING_PLIST ofType:@"plist"]];        
        id currentParsingJsonList  = [jsonMappingList objectForKey:rootClassName];    
        result=  [self beginJsonParsing:rootClassName modelClassElements:currentParsingJsonList :jsonObject];            
        jsonMappingList =nil;
        
    }
    else {
        
        DLog(@"Null object recieved for parsing");        
//        SHOW_ALERT(@"Null object recieved for parsing");                        
    }
    DLog(@"End mapptoModelClass %@",rootClassName);
    return result;
    
}


-(NSArray*)beginJsonParsing:(NSString*)parsingClassName modelClassElements:(id)elements:(id)jsonObject {
    
    
    NSMutableArray * parsedElements = [NSMutableArray new];  
    DLog(@"Begin beginJsonParsing %@",parsingClassName);
    if ([[jsonObject class] isSubclassOfClass:[NSArray class]]) {
        
        for (int i=0; i<[jsonObject count]; i++) {            
            
            id modelClassObject = [[NSClassFromString(parsingClassName) alloc] init];
            DLog(@"Model Class Created");
            id result = [self parseJsonToModelClass:parsingClassName modelClassElements:elements :[jsonObject objectAtIndex:i] :modelClassObject];
            
            //id result =  [self parseJsonToModelClass:parsingClassName:elements:[jsonObject objectAtIndex:i]:modelClassObject];                        
            
            if (result) {
                
                [parsedElements addObject:result];
            }
            
        }
        
    }
    else {
        DLog(@"Model Class Created");
        id modelClassObject = [[NSClassFromString(parsingClassName) alloc] init];
        id result = [self parseJsonToModelClass:parsingClassName modelClassElements:elements :jsonObject :modelClassObject];
        //id result =  [self parseObjectoModelClass:parsingClassName:elements:jsonObject:modelClassObject];
        if (result) {
            [parsedElements addObject:result]; 
        }
        
        
    }
    DLog(@"END beginJsonParsing %@",parsingClassName);
    return parsedElements;
    //return [mary autorelease];
    
}



-(id)parseJsonToModelClass:(NSString *)parsingClassName modelClassElements:(id )elements:(id)jsonObject:(id)modelClassObject{
    
    
    DLog(@"Begin parseJsonToModelClass %@",parsingClassName);
    id modelClassProperty  = [elements objectForKey:AttributeElements];    
    id  modelClassRelation     = [elements objectForKey:AttributeRelations];
    
    
    //id obj = nil;
    if ([[modelClassProperty class] isSubclassOfClass:[NSArray class]]) {
        
        //obj = [[NSClassFromString(modelName) alloc] init];        
        for (int i=0; i< [modelClassProperty count];i++) {
            
            NSDictionary * key =  [(NSArray*)modelClassProperty objectAtIndex:i];
            modelClassObject = [self makeModelClass:jsonObject :modelClassObject :[key objectForKey:AttributeField] :[key objectForKey:AttributeMapTo]:@"":@"" ];            
            
        }
        
    }
    else if(!modelClassProperty || [modelClassProperty length]==0){
        
        DLog(@"NO entry for model class in plist %@",parsingClassName);
//        NSString * message = [NSString stringWithFormat:@"NO entry for model class in plist %@",parsingClassName];
//        SHOW_ALERT(message);
    }
    
    
    DLog(@"Checking relations");
    if ([[modelClassRelation class] isSubclassOfClass:[NSArray class]]) {
        DLog(@"Relation found");
        for (int i=0; i< [modelClassRelation count];i++) {
            DLog(@"Begin Relation");
            NSString * modelClassmapto      = [[modelClassRelation objectAtIndex:i] objectForKey:AttributeMapTo];            
            NSString * jsonField     = [[modelClassRelation objectAtIndex:i] objectForKey:AttributeField];
            NSString * relationModelType   = [[modelClassRelation objectAtIndex:i] objectForKey:AttributeType];
            
            NSMutableDictionary* allJsonList = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:JSON_MAPPING_PLIST ofType:@"plist"]];    
            
            
            id currentParsingJsonList = [allJsonList objectForKey:relationModelType];
            
            NSArray * relationParseResult=  [self beginJsonParsing:relationModelType modelClassElements:currentParsingJsonList :[jsonObject objectForKey:jsonField]]; 
            
                          unsigned int outCount, i;
                          objc_property_t *properties = class_copyPropertyList([modelClassObject class], &outCount);
                          for (i = 0; i < outCount; i++) {
                              objc_property_t property = properties[i];
                              fprintf(stdout, "\n PPR  %s       %s   PPR \n", property_getName(property), property_getAttributes(property));
                          }
            
            
            
            const char *name = [modelClassmapto UTF8String];
            
            // objc_property_t ppp = class_getProperty([obj class],name);             
            // objc_msgSend(obje, NSSelectorFromString(@"update"));
            // objc_msgSend(obje, qselector,@"elbin");             
            // id ss= objc_msgSend(obj,  NSSelectorFromString(mc));
            
            objc_property_t  property = class_getProperty([modelClassObject class],name);
            DLog(@"parseJsonToModelClass Class%@ And property  %@  Object type %@ ",parsingClassName,modelClassmapto,[modelClassObject class]);
            
            if(property){
                const char * type = property_getAttributes(property);
                NSString * typeString = [NSString stringWithUTF8String:type];
                NSArray * attributes = [typeString componentsSeparatedByString:@","];
                NSString * typeAttribute = [attributes objectAtIndex:0];
                NSString * propertyType = [typeAttribute substringFromIndex:1];
                const char * rawPropertyType = [propertyType UTF8String];
                //                if (strcmp(rawPropertyType, @encode(NSArray))==0) 
                if ([propertyType isEqualToString:@"@\"NSArray\""] || (strcmp(rawPropertyType, @encode(NSArray))==0) ) 
                {
                    DLog(@"parseJsonToModelClass Set  Class %@ And property  %@",parsingClassName,modelClassmapto);
                    [modelClassObject setValue:relationParseResult forKey:modelClassmapto];                    
                    
                }
                else //if (strcmp(rawPropertyType, [relationModelType UTF8String])==0)
                    if ([propertyType isEqualToString:[NSString stringWithFormat:@"@\"%@\"",relationModelType]]|| (strcmp(rawPropertyType, [relationModelType UTF8String])==0))
                    {
                        if (relationParseResult && [relationParseResult count]) {
                            
                            DLog(@"parseJsonToModelClass Set  Class %@ And property  %@",parsingClassName,modelClassmapto);
                            id currentobjinary = [relationParseResult objectAtIndex:0];
                            [modelClassObject setValue:currentobjinary forKey:modelClassmapto];
                            
                            
                        }
                        else {
                            DLog(@"parseJsonToModelClass Null Arry %@ And Field %@",parsingClassName,modelClassmapto);
                        }
                        
                    }
                    else {
                        
                        
                        DLog(@"parseJsonToModelClass Not Matching  Class %@ And property  %@",parsingClassName,modelClassmapto);
                    }
                
            }
            else {
                
                DLog(@"parseJsonToModelClass  Fail to get  Class Field %@ And proprerty  %@",parsingClassName,modelClassmapto);
            }
            
        }
        
        
    }
    
    DLog(@"END parseJsonToModelClass %@",parsingClassName);
    return modelClassObject;
    
    
}

-(id)makeModelClass:(NSDictionary*)objects:(id)modelclass:(NSString*)field:(NSString*)mapingField:(NSString*)type:(NSString*)formatte{
    
    DLog(@"Begin makeModelClass %@",mapingField);
    const char *name = [mapingField UTF8String];
    objc_property_t  property = class_getProperty([modelclass class],name);
    if(property && ((NSNull *)[objects objectForKey:field]!= [NSNull null]) && [objects objectForKey:field]){
        [modelclass setValue: [objects objectForKey:field]  forKey:mapingField]; 
    }
    else {
        
        DLog(@"Property Not found %@",mapingField);
//        NSString * message = [NSString stringWithFormat:@"Property Not found %@",mapingField];
//        SHOW_ALERT(message);
        
    }
    
    DLog(@"END makeModelClass %@",mapingField);
    return modelclass;
    
}

@end


