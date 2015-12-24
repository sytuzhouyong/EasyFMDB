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

#pragma mark - XCode Colors

#define XCODE_COLORS_ESCAPE_MAC @"\033["
#define XCODE_COLORS_ESCAPE_IOS @"\xC2\xA0["

#if 0//TARGET_OS_IPHONE
#   define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_IOS
#else
#   define XCODE_COLORS_ESCAPE  XCODE_COLORS_ESCAPE_MAC
#endif

#define XCODE_COLORS_RESET_FG   XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG   XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET      XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#define LogRed(frmt, ...)       NSLog((XCODE_COLORS_ESCAPE @"fg249,73,72;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogGreen(frmt, ...)     NSLog((XCODE_COLORS_ESCAPE @"fg42,201,51;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogYellow(frmt, ...)    NSLog((XCODE_COLORS_ESCAPE @"fg253,177,36;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

#define LogError(frmt, ...)     LogRed(frmt, ##__VA_ARGS__)
#define LogWarning(frmt, ...)   LogYellow(frmt, ##__VA_ARGS__)
#define LogInfo(frmt, ...)      LogGreen(frmt, ##__VA_ARGS__)

#pragma mark - Time Tick

#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

#endif
