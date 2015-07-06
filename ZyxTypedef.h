//
//  ZyxTypedef.h
//  EasyFMDB
//
//  Created by sytuzhouyong on 14-10-23.
//  Copyright (c) 2014年 sytuzhouyong. All rights reserved.
//

#ifndef EasyFMDB_ZyxTypedef_h
#define EasyFMDB_ZyxTypedef_h

typedef void (^DBUpdateOperationResultBlock) (BOOL success);
typedef void (^DBQueryOperationResultBlock) (BOOL success, NSArray *result);

typedef NS_ENUM(NSUInteger, EEasyFMDBCapabilityType) {
    EasyFMDBCapabilityType_Add,
    EasyFMDBCapabilityType_Delete,
    EasyFMDBCapabilityType_Update,
    EasyFMDBCapabilityType_Query,
};

typedef NS_ENUM(NSUInteger, EDataCompareType) {
    DCT_Equal,
    DCT_NotEqual,
    DCT_Like,
    DCT_Less,
    DCT_LessEqual,
    DCT_Larger,
    DCT_LargerEqual,
};

typedef NS_ENUM(NSUInteger, ELogicRelationship) {
    LR_And,
    LR_Or,
};

typedef NS_ENUM(NSUInteger, EDataType) {
    DT_Unkonw,
    DT_BOOL,
    DT_NSInteger,
    DT_NSUInteger,
    DT_CGFloat,
    DT_NSString,
    DT_NSDate,
    DT_ZyxBaseModel,
};

#endif
