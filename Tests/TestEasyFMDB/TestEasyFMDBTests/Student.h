//
//  Student.h
//  
//
//  Created by zhouyong on 15/4/20.
//
//

#import <UIKit/UIKit.h>
#import "ZyxBaseModel.h"
#import "Teacher.h"

@interface Student : ZyxBaseModel

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSUInteger xxx;
@property (nonatomic, assign) CGFloat heavy;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy  ) NSString *nickname;
@property (nonatomic, strong) NSDate *birthday;

@property (nonatomic, strong) Teacher *teacher;

@end
