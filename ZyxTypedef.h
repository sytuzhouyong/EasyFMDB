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

typedef NS_ENUM(NSUInteger, EEasyFMDBCapabilityType)
{
    EasyFMDBCapabilityType_Add,
    EasyFMDBCapabilityType_Delete,
    EasyFMDBCapabilityType_Update,
    EasyFMDBCapabilityType_Query,
};

typedef NS_ENUM(NSUInteger, EDataCompareType)
{
    DCT_Equal,
    DCT_NotEqual,
    DCT_Like,
    DCT_Less,
    DCT_Larger,
};

typedef NS_ENUM(NSUInteger, ELogicRelationship)
{
    LR_And,
    LR_Or,
};

typedef NS_ENUM(NSUInteger, EDataType)
{
    DT_BOOL,
    DT_Int,
    DT_UnsignedInt,
    DT_Long,
    DT_UnsignedLong,
    DT_LongLongInt,
    DT_UnsignedLongLongInt,
    DT_Float,
    DT_Double,
    DT_String,
    DT_UTF8String,
    DT_Date,
    DT_Object,
};

#endif
