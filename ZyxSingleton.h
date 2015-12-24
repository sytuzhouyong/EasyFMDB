//
//  ZyxSingleton.h
//  EasyFMDB
//
//  Created by sytuzhouyong on 13-8-5.
//  Copyright (c) 2013年 sytuzhouyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZyxMacro.h"

#define SINGLETON_DECLEAR \
    + (instancetype)sharedInstance;


#if !__has_feature(objc_arc)
    #define SINGLETON_IMPLEMENTATION_PART \
        + (id)allocWithZone:(NSZone *)zone {                                            \
            return [[self sharedInstance] retain];                                      \
        }                                                                               \
        - (id)copyWithZone:(NSZone *)zone {                                             \
            return self;                                                                \
        }                                                                               \
        - (id)retain {                                                                  \
            return self;                                                                \
        }                                                                               \
        - (NSUInteger)retainCount {                                                     \
            return NSUIntegerMax;                                                       \
        }                                                                               \
        - (oneway void)release                                                          \
        {}                                                                              \
        - (id)autorelease {                                                             \
            return self;                                                                \
        }
#else
    #define SINGLETON_IMPLEMENTATION_PART
#endif

#define SINGLETON_IMPLEMENTATION(__class__) \
    + (instancetype)sharedInstance {                                                    \
        static __class__ *sharedSingleton_ = nil;                                       \
        static dispatch_once_t predicate;                                               \
        dispatch_once(&predicate, ^{                                                    \
            sharedSingleton_ = [[__class__ alloc] init];                                \
        });                                                                             \
        return sharedSingleton_;                                                        \
    }                                                                                   \
    SINGLETON_IMPLEMENTATION_PART


#define SINGLETON_IMPLEMENTATION_ADD(__class__, __m__) \
    + (instancetype)sharedInstance {                                                    \
        static __class__ *sharedSingleton_ = nil;                                       \
        static dispatch_once_t predicate;                                               \
        dispatch_once(&predicate, ^{                                                    \
            sharedSingleton_ = [[__class__ alloc] init];                                \
            [sharedSingleton_ __m__];                                                   \
        });                                                                             \
        return sharedSingleton_;                                                        \
    }                                                                                   \
    SINGLETON_IMPLEMENTATION_PART


