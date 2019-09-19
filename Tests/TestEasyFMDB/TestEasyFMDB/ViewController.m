//
//  ViewController.m
//  TestEasyFMDB
//
//  Created by zhouyong on 15/7/6.
//  Copyright (c) 2015年 zhouyong. All rights reserved.
//

#import "ViewController.h"
#import "ZyxBaseModel.h"
#import "EasyFMDB.h"
#import "Models.h"


@interface ViewController ()

@property (nonatomic, retain) ZyxFMDBManager *dbManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    // CPU个数
//    NSUInteger count1 = [[NSProcessInfo processInfo] processorCount];
//    // 可用CPU个数
//    NSUInteger count2 = [[NSProcessInfo processInfo] activeProcessorCount];
//    NSLog(@"count1 = %d, count2 = %d", count1, count2);

    [self initDB];
}


- (void)initDB {
    self.dbManager = [ZyxFMDBManager sharedInstance];
    [self.dbManager createDBWithName:@"test" forceCreate:YES];
}


- (void)testSave {
    dispatch_apply(100, dispatch_get_global_queue(0, 0), ^(size_t index) {
        ZyxContact *model = [self contact:index];
        [self.dbManager save:model withCompletion:^(BOOL success) {
            NSLog(@"save result %@: %@", @(index), @(success));
//            sleep(10);
        }];
    });
}

- (void)testQuery {
    ZyxContact *model = [[ZyxContact alloc] init];
    model.id = 10;
    dispatch_apply(100, dispatch_get_global_queue(0, 0), ^(size_t index) {
        [self.dbManager query:model withCompletion:^(BOOL success, NSArray *models) {
            NSLog(@"query %@ result: %@", @(index), models);
//            sleep(3);
        }];
    });
}

- (ZyxContact *)contact:(int)index {
    
    ZyxContact *contact = [[ZyxContact alloc] init];
    contact.name = [NSString stringWithFormat:@"name_%d", index];
    contact.age = index;
    contact.homeAddress = [NSString stringWithFormat:@"home_address_%d", index];
    contact.workAddress = [NSString stringWithFormat:@"work_address_%d", index];
    contact.mobilePhone = [NSString stringWithFormat:@"mobile_phone_%d", index];
    return contact;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


RegisteModel(TestModel)
@implementation TestModel


@end
