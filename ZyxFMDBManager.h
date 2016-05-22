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

// /Documents/name.db
- (void)createDBWithName:(NSString *)name;

// complex interface
- (void)save:(id)model withCompletion:(DBUpdateOperationResultBlock)block;
- (void)delete:(id)model withCompletion:(DBUpdateOperationResultBlock)block;
- (void)update:(id)model withCompletion:(DBUpdateOperationResultBlock)block;
- (void)query:(id)model withCompletion:(DBQueryOperationResultBlock)block;

// simple interface
- (BOOL)save:(ZyxBaseModel *)model;
- (BOOL)delete:(ZyxBaseModel *)model;
- (BOOL)update:(ZyxBaseModel *)model;
- (NSArray<ZyxBaseModel *> *)query:(ZyxBaseModel *)model;

@end
