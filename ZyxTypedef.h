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
typedef void (^DBQueryOperationResultBlock) (BOOL success, NSArray *models);

typedef NS_ENUM(NSUInteger, ZyxCompareType) {
    ZyxCompareTypeEqual,
    ZyxCompareTypeNotEqual,
    ZyxCompareTypeLike,
    ZyxCompareTypeLess,
    ZyxCompareTypeLessEqual,
    ZyxCompareTypeLarger,
    ZyxCompareTypeLargerEqual,
};

typedef NS_ENUM(NSUInteger, ZyxLogicRelationshipType) {
    ZyxLogicRelationshipTypeAnd,
    ZyxLogicRelationshipTypeOr,
};

typedef NS_ENUM(NSUInteger, ZyxFieldType) {
    ZyxFieldTypeUnkonw,
    ZyxFieldTypeBOOL,
    ZyxFieldTypeNSInteger,
    ZyxFieldTypeNSUInteger,
    ZyxFieldTypeCGFloat,
    ZyxFieldTypeNSString,
    ZyxFieldTypeNSDate,
    ZyxFieldTypeBaseModel,
};

#endif
