//
//  Models.h
//  EasyFMDB
//
//  Created by zhouyong on 14-10-27.
//  Copyright (c) 2014年 zhouyong. All rights reserved.
//

#import "ZyxBaseModel.h"

@interface ZyxContact : ZyxBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
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




