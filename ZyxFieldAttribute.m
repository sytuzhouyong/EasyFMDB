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

+ (NSNumber *)numberWithDateType:(EDataType)dt {
    return [NSNumber numberWithInt:dt];
}
+ (NSNumber *)boolType {
    return [ZyxDataType numberWithDateType:DT_BOOL];
}
+ (NSNumber *)stringType {
    return [ZyxDataType numberWithDateType:DT_NSString];
}
+ (NSNumber *)integerType {
    return [ZyxDataType numberWithDateType:DT_NSInteger];
}
+ (NSNumber *)uintegerType {
    return [ZyxDataType numberWithDateType:DT_NSUInteger];
}
+ (NSNumber *)doubleType {
    return [ZyxDataType numberWithDateType:DT_CGFloat];
}
+ (NSNumber *)dateType {
    return [ZyxDataType numberWithDateType:DT_NSDate];
}

+ (NSString *)stringWithDataType:(EDataType)type {
    switch (type) {
        case DT_BOOL:                   return @"bool";
        case DT_NSInteger:              return @"integer";
        case DT_NSUInteger:             return @"integer unsigned";
        case DT_CGFloat:                return @"double";
        case DT_NSString:               return @"text";
        case DT_NSDate:                 return @"date";
        case DT_ZyxBaseModel:           return @"integer unsigned";
        default: {
            NSLog(@"oh no, unrecognized data type : %lu", (unsigned long)type);
            return @"";
        }
    }
}

@end
