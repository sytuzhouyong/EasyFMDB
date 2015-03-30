//
//  ZyxFieldAttribute.h
//  EasyFMDB
//
//  Created by sytuzhouyong on 13-6-20.
//  Copyright (c) 2013年 sytuzhouyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZyxTypedef.h"

@interface ZyxDataType : NSObject

+ (NSNumber *)boolType;
+ (NSNumber *)intType;
+ (NSNumber *)longType;
+ (NSNumber *)longLongIntType;
+ (NSNumber *)uLongLongIntType;
+ (NSNumber *)floatType;
+ (NSNumber *)doubleType;
+ (NSNumber *)stringType;
+ (NSNumber *)utf8StringType;
+ (NSNumber *)dateType;
+ (NSNumber *)objectType;

+ (NSString *)stringWithDataType:(EDataType)type;

@end

@interface ZyxFieldAttribute : NSObject

@property (nonatomic, assign) EDataType type;       // data type of property
@property (nonatomic, copy) NSString *name;         // proper name
@property (nonatomic, copy) NSString *nameInDB;     // related column name in db

- (id)initWithName:(NSString *)name type:(int)t nameInDB:(NSString *)nit;

@end
