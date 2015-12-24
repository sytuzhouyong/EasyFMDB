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
+ (NSNumber *)integerType;
+ (NSNumber *)uintegerType;
+ (NSNumber *)doubleType;
+ (NSNumber *)stringType;
+ (NSNumber *)dateType;

+ (NSString *)stringWithDataType:(ZyxFieldType)type;

@end

@interface ZyxFieldAttribute : NSObject

@property (nonatomic, assign) ZyxFieldType type;       // data type of property
@property (nonatomic, copy) NSString *name;         // proper name
@property (nonatomic, copy) NSString *className;    // class name
@property (nonatomic, copy) NSString *nameInDB;     // related column name in db
@property (nonatomic, assign) BOOL isBaseModel;

- (id)initWithName:(NSString *)name type:(int)t nameInDB:(NSString *)nit;

@end
