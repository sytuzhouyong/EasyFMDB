//
//  ViewController.h
//  TestEasyFMDB
//
//  Created by zhouyong on 15/7/6.
//  Copyright (c) 2015年 zhouyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZyxBaseModel.h"

@interface ViewController : UIViewController


@end




@interface TestModel : ZyxBaseModel

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;

@end
