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

@interface ZyxFMDBManager : NSObject

SINGLETON_DECLEAR;

// Documents/subDirectory/xx.db
- (void)createDBFileAtSubDirectory:(NSString *)subDirectory;
- (void)callCapabilityType:(EEasyFMDBCapabilityType)capabilityType withParam:(id)inParam;

@end
