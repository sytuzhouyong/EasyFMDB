//
//  ZyxBaseModel.m
//  EasyFMDB
//
//  Created by sytuzhouyong on 14-3-19.
//  Copyright (c) 2013年 sytuzhouyong. All rights reserved.
//

#import "ZyxBaseModel.h"
#import <objc/runtime.h>
#import "ZyxTypedef.h"
#import "ZyxMacro.h"
#import "ZyxFieldAttribute.h"

@implementation ZyxBaseModel
{
    NSMutableArray *_updatedProperties;
    NSMutableArray *_updatedValues;
    NSMutableArray *_updatedPropertiesExceptId;
    NSMutableArray *_updatedValuesExceptId;
    NSMutableArray *_watchedKeys;
    BOOL _isObserverEnabled;
}

+ (void)registeModel:(Class)clazz
{
    NSMutableArray *registedModels = [self.class registedModels];
    [registedModels addObject:[NSValue valueWithPointer:(__bridge const void *)(clazz)]];
}

+ (NSMutableArray *)registedModels
{
    static NSMutableArray *registedModels = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        registedModels = [[NSMutableArray alloc] initWithCapacity:8];
    });
    return registedModels;
}

#pragma mark - Init

- (id)init
{
    return [self initWithObserverEnabledFlag:YES];
}

- (id)initWithObserverEnabledFlag:(BOOL)isObserverEnable
{
    if (self = [super init])
    {
        _isObserverEnabled = isObserverEnable;
        _updatedProperties = [[NSMutableArray alloc] init];
        _updatedValues = [[NSMutableArray alloc] init];
        _updatedPropertiesExceptId = [[NSMutableArray alloc] init];
        _updatedValuesExceptId = [[NSMutableArray alloc] init];
        _watchedKeys = [[NSMutableArray alloc] init];
        
        if (isObserverEnable)
        {
            [self addWatchKeys];
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        [copy setId:_id];
    }
    
    return copy;
}

#pragma mark - KVO

- (void)addWatchKeys
{
    NSDictionary *properties = [self.class propertyDictionary];
    [properties.allKeys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([self.class predicateProperty:obj])
        {
            [self addObserver:self forKeyPath:obj options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            [_watchedKeys addObject:obj];
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    id newValue = [change objectForKey:@"new"];
    if (newValue != nil && ![newValue isKindOfClass:NSNull.class])
    {
        [_updatedProperties addObject:keyPath];
        [_updatedValues addObject:newValue];
        if (![keyPath isEqualToString:@"id"])
        {
            [_updatedPropertiesExceptId addObject:keyPath];
            [_updatedValuesExceptId addObject:newValue];
        }
    }
}

- (void)setObserverEnabled:(BOOL)enabled
{
    if (enabled)
    {
        [self addWatchKeys];
    }
    else
    {
        [_updatedProperties removeAllObjects];
        [_updatedValues removeAllObjects];
        [_updatedPropertiesExceptId removeAllObjects];
        [_updatedValuesExceptId removeAllObjects];
        
        [_watchedKeys removeAllObjects];
    }
}

#pragma mark - Property Dictionary

+ (NSDictionary *)propertyDictionary
{
    static NSMutableDictionary *properties = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        properties = [[NSMutableDictionary alloc] initWithCapacity:8];
    });
    
    NSString *name = NSStringFromClass(self.class);
    NSDictionary *value = [properties objectForKey:name];
    if (value == nil)
    {
        value = [self.class dictOfPropertyWithObject:self.class];
        properties[name] = value;
    }
    return value;
}

- (NSArray *)updatedProperties
{
    return _updatedProperties;
}
- (NSArray *)updatedValues
{
    return _updatedValues;
}
- (NSArray *)updatedPropertiesExceptId
{
    return _updatedPropertiesExceptId;
}
- (NSArray *)updatedValuesExceptId
{
    return _updatedValuesExceptId;
}

#pragma mark - ZyxBaseModelProtocol

+ (BOOL)predicateProperty:(NSString *)name
{
    return ![name hasPrefix:@"_"];
}

#pragma mark - Util Function

+ (NSString *)sql
{
    static NSMutableDictionary *sqlDictionary = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqlDictionary = [[NSMutableDictionary alloc] initWithCapacity:8];
    });
    
    NSString *name = NSStringFromClass(self.class);
    NSMutableString *sql = [sqlDictionary objectForKey:name];
    if (sql == nil)
    {
        sql = [[NSMutableString alloc] initWithCapacity:1024];
        [sql appendString:@"create table "];
        [sql appendString:TABLE_NAME(self)];
        [sql appendString:@" (id integer primary key autoincrement, "];
        
        NSArray *properties = [ZyxBaseModel arrayOfPropertyWithObject:self.class];
        for (ZyxFieldAttribute *property in properties)
        {
            if ([property.name isEqualToString:@"id"])
                continue;
            
            NSString *field = [NSString stringWithFormat:@"%@ %@, ", property.nameInDB, [ZyxDataType stringWithDataType:property.type]];
            [sql appendString:field];
        }
        
        if ([sql hasSuffix:@", "])
        {
            [sql deleteCharactersInRange:NSMakeRange(sql.length-2, 2)];
        }
        [sql appendString:@")"];
        
        sqlDictionary[name] = sql;
    }
    
    return sql;
}

// get all properties including inherited form super class
+ (NSDictionary *)dictOfPropertyWithObject:(Class)class
{
    NSMutableDictionary *props = [[NSMutableDictionary alloc] init];
    Class c = class;
    NSString *classString = NSStringFromClass(c);
    NSString *objectString = NSStringFromClass(NSObject.class);
    
    while (![classString isEqualToString:objectString])
    {
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList(c, &outCount);
        for (unsigned int i = 0; i<outCount; i++)
        {
            objc_property_t property = properties[i];
            
            // name
            const char *char_name = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_name];
            
            // ingore invalid property
            if (![self.class predicateProperty:propertyName])
            {
                continue;
            }
            
            // attr
            const char *char_attr = property_getAttributes(property);
            NSString *propertyAttr = [NSString stringWithUTF8String:char_attr];
            NSArray *attributes = [propertyAttr componentsSeparatedByString:@","];
            NSString *attr = [attributes objectAtIndex:0];
            
            NSString *dataType = @"";
            NSRange range = [attr rangeOfString:@"@\""];
            if (range.location == NSNotFound)
            {
                dataType = [attr substringFromIndex:1];
            }
            else
            {
                dataType = [attr substringWithRange:NSMakeRange(3, attr.length - 4)];
            }
            
            ZyxFieldAttribute *p = [[ZyxFieldAttribute alloc] init];
            p.name = propertyName;
            p.nameInDB = [self propertyNameToDBName:propertyName];
            p.type = [self dataTypeWithTypeString:dataType];
            [props setObject:p forKey:propertyName];
        }
        c = class_getSuperclass(c);
        classString = NSStringFromClass(c);
        free(properties);
    }
    return props;
}

/// array of all ZyxFieldAttribute object in Class, the same order with that declared in class
+ (NSArray *)arrayOfPropertyWithObject:(Class)class
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:16];
    
    Class c = class;
    NSString *classString = NSStringFromClass(c);
    NSString *objectString = NSStringFromClass(NSObject.class);
    
    NSDictionary *propertyDict = [class propertyDictionary];
    
    while (![classString isEqualToString:objectString])
    {
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList(c, &outCount);
        for (unsigned int i = 0; i<outCount; i++)
        {
            objc_property_t property = properties[i];
        
            // name
            const char *char_name = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_name];
            
            ZyxFieldAttribute *p = [propertyDict objectForKey:propertyName];
            [array addObject:p];
        }
        
        c = class_getSuperclass(c);
        classString = NSStringFromClass(c);
        free(properties);
    }
    
    return  array;
}


+ (NSString *)propertyNameToDBName:(NSString *)propertyName
{
    NSMutableString *dbName = [NSMutableString string];
    NSUInteger length = propertyName.length;
    
    for (NSUInteger i=0; i<length; i++)
    {
        unichar c = [propertyName characterAtIndex:i];
        if (c >= 'A' && c <= 'Z')
        {
            [dbName appendFormat:@"_%c", tolower(c)];
        }
        else
        {
            [dbName appendFormat:@"%c", c];
        }
    }
    return dbName;
}

+ (NSString *)dbNameToPropertyName:(NSString *)dbName
{
    NSArray *elements = [dbName componentsSeparatedByString:@"_"];
    NSMutableString *propertyName = [NSMutableString stringWithString:elements.firstObject];
    if (elements.count < 2)
    {
        return propertyName;
    }
    
    for (NSUInteger i=1; i<elements.count; i++)
    {
        NSString *element = elements[i];
        [propertyName appendString:[element capitalizedString]];
    }
    return propertyName;
}

#pragma mark -

+ (EDataType)dataTypeWithTypeString:(NSString *)typeString
{
//    NSLog(@"type string : %@", typeString);
    const char *str = typeString.UTF8String;
    
    if (strcmp(str, @encode(bool)) == 0)            return DT_BOOL;
    if (strcmp(str, @encode(int)) == 0)             return DT_Int;
    if (strcmp(str, @encode(unsigned)) == 0)        return DT_UnsignedInt;
    if (strcmp(str, @encode(long)) == 0)            return DT_Long;
    if (strcmp(str, @encode(unsigned long)) == 0)   return DT_UnsignedLong;
    if (strcmp(str, @encode(float)) == 0)           return DT_Float;
    if (strcmp(str, @encode(double)) == 0)          return DT_Double;
    if (strcmp(str, @encode(char)) == 0)            return DT_UTF8String;
    if (strcmp(str, @encode(id)) == 0)              return DT_Object;
    
    if (strcmp(str, [self ocTypeString:@encode(NSDate)]) == 0)
        return DT_Date;
    if (strcmp(str, [self ocTypeString:@encode(NSString)]) == 0)
        return DT_String;
    if (strcmp(str, @encode(long long int)) == 0)
        return DT_LongLongInt;
    if (strcmp(str, @encode(unsigned long long int)) == 0)
        return DT_UnsignedLongLongInt;
    
    NSLog(@"oh no, unrecognized data type : %s", str);
    return DT_Object;
}

+ (const char *)ocTypeString:(const char *)str
{
    NSString *type = [NSString stringWithUTF8String:str];
    NSString *ocType = [type substringWithRange:NSMakeRange(1, type.length - 4)];
    return [ocType UTF8String];
}

#pragma mark - dealloc

- (void)dealloc
{
    for (NSString *key in _watchedKeys)
    {
        [self removeObserver:self forKeyPath:key context:nil];
    }
}

+ (void)logType
{
    NSLog(@"BOOL : %s", @encode(BOOL));
    NSLog(@"bool: %s", @encode(bool));
    NSLog(@"int: %s", @encode(int));
    NSLog(@"unsigned int: %s", @encode(unsigned));
    NSLog(@"long: %s", @encode(long));
    NSLog(@"unsigned long: %s", @encode(unsigned long));
    NSLog(@"float: %s", @encode(float));
    NSLog(@"double: %s", @encode(double));
    NSLog(@"char: %s", @encode(char));
    NSLog(@"id: %s", @encode(id));
    NSLog(@"long long int: %s", @encode(long long int));
    NSLog(@"unsigned long long int: %s", @encode(unsigned long long int));
}

@end
