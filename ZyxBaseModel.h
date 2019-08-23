//
//  ZyxBaseModel.h
//  EasyFMDB
//
//  Created by sytuzhouyong on 14-3-19.
//  Copyright (c) 2013年 sytuzhouyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#   import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#endif

#define kSegmentName                "__RegisterModels"
#define AddSectionSegment(segment)  __attribute((used, section("__DATA, "#segment" ")))
#define RegisteModel(model)         char * k##model##_xxx AddSectionSegment(__RegisterModels) = ""#model"";

// Database related Objective-C object
@interface ZyxBaseModel : NSObject

@property (nonatomic, assign) NSUInteger id;     // autoincreasement

/// subclass of ZyxBaseModel needs to override this method
+ (NSSet *)registedModels;

+ (NSArray *)ignoredProperties;

- (id)initWithObserverEnabledFlag:(BOOL)isObserverEnable;
- (void)setObserverEnabled:(BOOL)enabled;


/// common database operation method
- (BOOL)save;
- (BOOL)delete;
- (BOOL)update;
- (NSArray *)query;


// key: property name;  value: ZyxFieldAttribute object
+ (NSDictionary *)propertiesDictionary;

/// property array which updated
- (NSArray *)updatedProperties;
- (NSArray *)updatedValues;
/// property array except id which updated
- (NSArray *)updatedPropertiesExceptId;
- (NSArray *)updatedValuesExceptId;

// util function
+ (NSString *)sql;
+ (NSDictionary *)fieldsAttributeDictInClass:(Class)c;
+ (NSArray *)fieldsAttributeInClass:(Class)c;
+ (NSString *)propertyNameToDBName:(NSString *)propertyName isBaseModel:(BOOL)isBaseModel;
+ (NSString *)dbNameToPropertyName:(NSString *)dbName;

@end
