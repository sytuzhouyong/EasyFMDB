//
//  ZyxMacro.h
//  EasyFMDB
//
//  Created by sytuzhouyong on 14-10-23.
//  Copyright (c) 2014年 sytuzhouyong. All rights reserved.
//

#ifndef EasyFMDB_ZyxMacro_h
#define EasyFMDB_ZyxMacro_h

#if !__has_feature(objc_arc)
// -fno-objc-arc
    #define ZyxRelease(__v)         ([__v release]);
    #define ZyxRetain(__v)          ([__v retain]);
    #define ZyxAutorelease(__v)     ([__v autorelease]);
    #define ZyxReturnAutoreleased   ZyxAutorelease
    #define ZyxReturnRetained       ZyxRetain
#else
// -fobjc-arc
    #define ZyxRelease(__v)
    #define ZyxRetain(__v)
    #define ZyxAutorelease(__v)
    #define ZyxReturnAutoreleased(__v)  (__v)
    #define ZyxReturnRetained(__v)      (__v)
#endif

#define kEasyFMDBModel                          @"model"
#define kEasyFMDBProperties                     @"properties"
#define kEasyFMDBPropertiesValues               @"properties_values"
#define kEasyFMDBValues                         @"values"
#define kEasyFMDBResult                         @"result"
#define kEasyFMDBSuccess                        @"success"
#define kEasyFMDBBlock                          @"block"
#define kEasyFMDBUpdateProperties               @"update_properties"
#define kEasyFMDBQueryProperties                @"query_properties"
#define kEasyFMDBQueryPropertiesAndValues       @"query_properties_and_values"
#define kEasyFMDBMatches                        @"matches"
#define kEasyFMDBLogics                         @"logics"
#define kEasyFMDBOrders                         @"orders"
#define kEasyFMDBRange                          @"range"

#define TABLE_NAME_C(__c)                       [NSString stringWithFormat:@"T_%@", NSStringFromClass(__c)]
#define TABLE_NAME(__m)                         TABLE_NAME_C(__m.class)
#define TABLE_NAME_S(__n)                       [NSString stringWithFormat:@"T_%@", __n]

#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

#endif
