//
//  TincanContextActivities.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "TincanContextActivities.h"

@interface TincanContextActivities()

@property (nonatomic, strong, readwrite) NSMutableDictionary* dataDict;

@end

@implementation TincanContextActivities

@synthesize dataDict = _dataDict;

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.dataDict = [NSMutableDictionary new];
    }
    
    return self;
}

- (void) setParent:(TincanContextActivity*)parent
{
    [self setSeerArrayObjectData:parent forProperty:@"parent"];
}

- (void) setGrouping:(TincanContextActivity*)grouping
{
    [self setSeerArrayObjectData:grouping forProperty:@"grouping"];
}

- (void) setCategory:(TincanContextActivity*)category
{
    [self setSeerArrayObjectData:category forProperty:@"category"];
}

- (void) setOther:(TincanContextActivity*)other
{
    [self setSeerArrayObjectData:other forProperty:@"other"];
}

- (TincanContextActivity*) setParentWithId:(NSString*)parentId
{
    TincanContextActivity* parent = [TincanContextActivity new];
    [parent addActivityItemWithId:parentId];
    
    [self setSeerArrayObjectData:parent forProperty:@"parent"];
    
    return parent;
}

- (TincanContextActivity*) setGroupingWithId:(NSString*)groupingId
{
    TincanContextActivity* grouping = [TincanContextActivity new];
    [grouping addActivityItemWithId:groupingId];
    
    [self setSeerArrayObjectData:grouping forProperty:@"grouping"];
    
    return grouping;
}

- (TincanContextActivity*) setCategoryWithId:(NSString*)categoryId
{
    TincanContextActivity* category = [TincanContextActivity new];
    [category addActivityItemWithId:categoryId];
    
    [self setSeerArrayObjectData:category forProperty:@"category"];
    
    return category;
}

- (TincanContextActivity*) setOtherWithId:(NSString*)otherId
{
    TincanContextActivity* other = [TincanContextActivity new];
    [other addActivityItemWithId:otherId];
    
    [self setSeerArrayObjectData:other forProperty:@"other"];
    
    return other;
}

- (TincanContextActivity*)parent
{
    TincanContextActivity* tcaParent = [TincanContextActivity new];
    NSMutableArray* array = [self getSeerArrayObjectDataForProperty:@"parent"];
    if (array)
    {
        [tcaParent setArray: array];
    }
    return tcaParent;
}

- (TincanContextActivity*)grouping
{
    TincanContextActivity* tcaGrouping = [TincanContextActivity new];
    NSMutableArray* array = [self getSeerArrayObjectDataForProperty:@"grouping"];
    if (array)
    {
        [tcaGrouping setArray: array];
    }
    return tcaGrouping;
}

- (TincanContextActivity*)category
{
    TincanContextActivity* tcaCategory = [TincanContextActivity new];
    NSMutableArray* array = [self getSeerArrayObjectDataForProperty:@"category"];
    if (array)
    {
        [tcaCategory setArray: array];
    }
    return tcaCategory;
}

- (TincanContextActivity*)other
{
    TincanContextActivity* tcaOther = [TincanContextActivity new];
    NSMutableArray* array = [self getSeerArrayObjectDataForProperty:@"other"];
    if (array)
    {
        [tcaOther setArray: array];
    }
    return tcaOther;
}

@end
