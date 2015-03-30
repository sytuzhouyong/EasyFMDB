//
//  ZyxFieldAttribute.m
//  EasyFMDB
//
//  Created by sytuzhouyong on 13-6-20.
//  Copyright (c) 2013年 sytuzhouyong. All rights reserved.
//

#import "ZyxFieldAttribute.h"

@implementation ZyxFieldAttribute

- (id)initWithName:(NSString *)n type:(int)t nameInDB:(NSString *)nit
{
    if (self = [super init])
    {
        self.name = n;
        self.type = t;
        self.nameInDB = nit;
    }
    return self;
}


@end

@implementation ZyxDataType

+ (NSNumber *)numberWithDateType:(EDataType)dt
{
    return [NSNumber numberWithInt:dt];
}
+ (NSNumber *)boolType
{
    return [ZyxDataType numberWithDateType:DT_BOOL];
}
+ (NSNumber *)intType
{
    return [ZyxDataType numberWithDateType:DT_Int];
}
+ (NSNumber *)longType
{
    return [ZyxDataType numberWithDateType:DT_Long];
}
+ (NSNumber *)longLongIntType
{
    return [ZyxDataType numberWithDateType:DT_LongLongInt];
}
+ (NSNumber *)uLongLongIntType
{
    return [ZyxDataType numberWithDateType:DT_UnsignedLongLongInt];
}
+ (NSNumber *)floatType
{
    return [ZyxDataType numberWithDateType:DT_Float];
}
+ (NSNumber *)doubleType
{
    return [ZyxDataType numberWithDateType:DT_Double];
}
+ (NSNumber *)stringType
{
    return [ZyxDataType numberWithDateType:DT_String];
}
+ (NSNumber *)utf8StringType
{
    return [ZyxDataType numberWithDateType:DT_UTF8String];
}
+ (NSNumber *)dateType
{
    return [ZyxDataType numberWithDateType:DT_Date];
}
+ (NSNumber *)objectType
{
    return [ZyxDataType numberWithDateType:DT_Object];
}

+ (NSString *)stringWithDataType:(EDataType)type
{
    switch (type)
    {
        case DT_BOOL:                   return @"bool";
        case DT_Int:                    return @"integer";
        case DT_UnsignedInt:            return @"integer";
        case DT_Long:                   return @"integer";
        case DT_UnsignedLong:           return @"integer";
        case DT_LongLongInt:            return @"integer";
        case DT_UnsignedLongLongInt:    return @"integer";
        case DT_Float:                  return @"float";
        case DT_Double:                 return @"double";
        case DT_String:                 return @"text";
        case DT_UTF8String:             return @"text";
        case DT_Date:                   return @"date";
        default:
        {
            NSLog(@"oh no, unrecognized data type : %lu", (unsigned long)type);
            return @"";
        }
    }
}

@end
