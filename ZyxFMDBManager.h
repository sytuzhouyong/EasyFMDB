//
//  ZyxFMDBManager.h
//  EasyFMDB
//
//  Created by sytuzhouyong on 13-6-17.
//  Copyright (c) 2013年 sytuzhouyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZyxSingleton.h"
#import "ZyxTypedef.h"

@class ZyxBaseModel;

@interface ZyxFMDBManager : NSObject

SINGLETON_DECLEAR;

/**
 * @param name 数据库的名字
 * @param forceCreate 是否j强制新建。YES:如果有旧的数据库就先删除旧的文件，再创建新的
 */
- (void)createDBWithName:(NSString *)name forceCreate:(BOOL)forceCreate;
- (void)createDBWithName:(NSString *)name;

/**
 * @param model 要操作的对象, 可以ZyxBaseModel的子类，或者ZyxBaseModel子类的数组
 * @param block 结果处理函数
 */
- (void)save:(id)model withCompletion:(DBUpdateOperationResultBlock)block;
- (void)delete:(id)model withCompletion:(DBUpdateOperationResultBlock)block;
- (void)update:(id)model withCompletion:(DBUpdateOperationResultBlock)block;
/**
 * @param model 要查询条件的对象,里面的属性值会做为where的条件
 * @param block 结果处理函数
 */
- (void)query:(id)model withCompletion:(DBQueryOperationResultBlock)block;

/**
 * @param model 要操作的对象, 可以ZyxBaseModel的子类，或者ZyxBaseModel子类的数组
 * @return 处理是否成功
 */
- (BOOL)save:(ZyxBaseModel *)model;
- (BOOL)delete:(ZyxBaseModel *)model;
- (BOOL)update:(ZyxBaseModel *)model;
/**
 * @param model 要查询条件的对象,里面的属性值会做为where的条件
 * @return 查询的对象列表
 */
- (NSArray<ZyxBaseModel *> *)query:(ZyxBaseModel *)model;

@end
