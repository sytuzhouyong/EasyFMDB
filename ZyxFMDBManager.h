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

// open flags
#define SQLITE_OPEN_READONLY         0x00000001  /* Ok for sqlite3_open_v2() */
#define SQLITE_OPEN_READWRITE        0x00000002  /* Ok for sqlite3_open_v2() */
#define SQLITE_OPEN_CREATE           0x00000004  /* Ok for sqlite3_open_v2() */
#define SQLITE_OPEN_DELETEONCLOSE    0x00000008  /* VFS only */
#define SQLITE_OPEN_EXCLUSIVE        0x00000010  /* VFS only */
#define SQLITE_OPEN_AUTOPROXY        0x00000020  /* VFS only */
#define SQLITE_OPEN_URI              0x00000040  /* Ok for sqlite3_open_v2() */
#define SQLITE_OPEN_MEMORY           0x00000080  /* Ok for sqlite3_open_v2() */
#define SQLITE_OPEN_MAIN_DB          0x00000100  /* VFS only */
#define SQLITE_OPEN_TEMP_DB          0x00000200  /* VFS only */
#define SQLITE_OPEN_TRANSIENT_DB     0x00000400  /* VFS only */
#define SQLITE_OPEN_MAIN_JOURNAL     0x00000800  /* VFS only */
#define SQLITE_OPEN_TEMP_JOURNAL     0x00001000  /* VFS only */
#define SQLITE_OPEN_SUBJOURNAL       0x00002000  /* VFS only */
#define SQLITE_OPEN_MASTER_JOURNAL   0x00004000  /* VFS only */
#define SQLITE_OPEN_NOMUTEX          0x00008000  /* Ok for sqlite3_open_v2() */
#define SQLITE_OPEN_FULLMUTEX        0x00010000  /* Ok for sqlite3_open_v2() */
#define SQLITE_OPEN_SHAREDCACHE      0x00020000  /* Ok for sqlite3_open_v2() */
#define SQLITE_OPEN_PRIVATECACHE     0x00040000  /* Ok for sqlite3_open_v2() */
#define SQLITE_OPEN_WAL              0x00080000  /* VFS only */

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
