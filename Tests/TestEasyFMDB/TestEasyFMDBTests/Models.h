//
//  Models.h
//  EasyFMDB
//
//  Created by zhouyong on 14-10-27.
//  Copyright (c) 2014年 zhouyong. All rights reserved.
//

#import "ZyxBaseModel.h"

@interface ZyxContact : ZyxBaseModel

@property (nonatomic, assign) bool b1;
@property (nonatomic, assign) BOOL b2;
@property (nonatomic, assign) int i1;
@property (nonatomic, assign) short i2;
@property (nonatomic, assign) long i3;
@property (nonatomic, assign) long long int i6;
@property (nonatomic, assign) unsigned int i4;
@property (nonatomic, assign) unsigned long long int i5;
@property (nonatomic, assign) char ch;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSUInteger age2;
@property (nonatomic, copy) NSString *homeAddress;
@property (nonatomic, copy) NSString *workAddress;
@property (nonatomic, copy) NSString *mobilePhone;

@end


@interface Teacher : ZyxBaseModel

@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, assign) NSUInteger age;

@end


@interface Student : ZyxBaseModel

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSUInteger xxx;
@property (nonatomic, assign) CGFloat heavy;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy  ) NSString *nickname;
@property (nonatomic, strong) NSDate *birthday;

@property (nonatomic, strong) Teacher *teacher;

@end




