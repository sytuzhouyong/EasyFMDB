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


// Database related Objective-C object
// the object inherted from ZyxBaseModel needs to override +(void)load;
// and in + (void)load method, you should call ZyxBaseModel::registeModel:(Class)clazz.
@interface ZyxBaseModel : NSObject

@property (nonatomic, assign) NSUInteger id;     // autoincreasement

/// subclass of ZyxBaseModel needs to override this method
+ (void)registeModel:(Class)clazz;
+ (NSMutableSet *)registedModels;

+ (NSArray *)ignoredProperties;

- (id)initWithObserverEnabledFlag:(BOOL)isObserverEnable;
- (void)setObserverEnabled:(BOOL)enabled;


/// common database operation method
- (BOOL)save;
- (BOOL)delete;
- (BOOL)update;
- (NSArray *)query;


// key: property name  value: ZyxFieldAttribute object
/// all property info that predicateProperty: method return YES
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
