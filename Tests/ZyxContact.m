//
//  ZyxContact.m
//  EasyFMDB
//
//  Created by zhouyong on 14-10-27.
//  Copyright (c) 2014年 zhouyong. All rights reserved.
//

#import "ZyxContact.h"

@implementation ZyxContact

+ (void)load
{
    [ZyxBaseModel registeModel:self.class];
}

- (id)copyWithZone:(NSZone *)z
{
    ZyxContact *copy = [super copyWithZone:z];
    if (copy)
    {
        [copy setName:self.name];
        [copy setAge:self.age];
        [copy setHomeAddress:self.homeAddress];
        [copy setWorkAddress:self.workAddress];
        [copy setMobilePhone:self.mobilePhone];
    }
    return copy;
}

@end
