//
//  ZyxFieldAttribute.m
//  EasyFMDB
//
//  Created by sytuzhouyong on 13-6-20.
//  Copyright (c) 2013年 sytuzhouyong. All rights reserved.
//

#import "ZyxFieldAttribute.h"

@implementation ZyxFieldAttribute

- (id)initWithName:(NSString *)n type:(int)t nameInDB:(NSString *)nit {
    if (self = [super init]) {
        self.name = n;
        self.type = t;
        self.nameInDB = nit;
    }
    return self;
}

@end

@implementation ZyxDataType

+ (NSNumber *)numberWithDateType:(ZyxFieldType)dt {
    return [NSNumber numberWithInt:dt];
}
+ (NSNumber *)boolType {
    return [ZyxDataType numberWithDateType:ZyxFieldTypeBOOL];
}
+ (NSNumber *)stringType {
    return [ZyxDataType numberWithDateType:ZyxFieldTypeNSString];
}
+ (NSNumber *)integerType {
    return [ZyxDataType numberWithDateType:ZyxFieldTypeNSInteger];
}
+ (NSNumber *)uintegerType {
    return [ZyxDataType numberWithDateType:ZyxFieldTypeNSUInteger];
}
+ (NSNumber *)doubleType {
    return [ZyxDataType numberWithDateType:ZyxFieldTypeCGFloat];
}
+ (NSNumber *)dateType {
    return [ZyxDataType numberWithDateType:ZyxFieldTypeNSDate];
}

+ (NSString *)stringWithDataType:(ZyxFieldType)type {
    switch (type) {
        case ZyxFieldTypeBOOL:                   return @"bool";
        case ZyxFieldTypeNSInteger:              return @"integer";
        case ZyxFieldTypeNSUInteger:             return @"integer unsigned";
        case ZyxFieldTypeCGFloat:                return @"double";
        case ZyxFieldTypeNSString:               return @"text";
        case ZyxFieldTypeNSDate:                 return @"date";
        case ZyxFieldTypeBaseModel:           return @"integer unsigned";
        default: {
            NSLog(@"oh no, unrecognized data type : %lu", (unsigned long)type);
            return @"";
        }
    }
}

@end
