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

/**
 * 每一个通过RegisteModel注册过的ZyxBaseModel对应数据库中的一张表，没有注册就不会生成表
 */
@interface ZyxBaseModel : NSObject

// 主键，默认自增，暂时不支持自定义主键
@property (nonatomic, assign) NSUInteger id;

/**
 * @param observerEnabled 是否开启属性监控 默认开启
 * 开启后model中的属性修改都将被监控
 */
- (instancetype)initWithObserverEnabledFlag:(BOOL)observerEnabled;
- (void)setObserverEnabled:(BOOL)observerEnabled;

/**
 * 所有注册模型的类名
 * 注册过的模型都会在数据库里面生成一张表
 */
+ (NSSet<NSString *> *)registedModels;

/**
 * 模型中不需要存入数据库的字段集合
 */
+ (NSArray<NSString *> *)ignoredProperties;


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
