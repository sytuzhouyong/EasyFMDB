//
//  TestEasyFMDBTests.m
//  TestEasyFMDBTests
//
//  Created by zhouyong on 15/7/6.
//  Copyright (c) 2015年 zhouyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "EasyFMDB.h"
#import "ZyxContact.h"
#import "Teacher.h"
#import "Student.h"

@interface TestEasyFMDBTests : XCTestCase

@property (nonatomic, retain) ZyxFMDBManager *dbManager;

@end

@implementation TestEasyFMDBTests

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.dbManager = [ZyxFMDBManager sharedInstance];
    [self.dbManager createDBFileAtSubDirectory:@"test"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.dbManager = nil;
    [super tearDown];
}

- (ZyxContact *)contact {
    static int number = 0;
    number++;
    
    ZyxContact *contact = [[ZyxContact alloc] init];
    contact.name = [NSString stringWithFormat:@"name_%d", number];
    contact.age = number;
    contact.homeAddress = [NSString stringWithFormat:@"home_address_%d", number];
    contact.workAddress = [NSString stringWithFormat:@"work_address_%d", number];
    contact.mobilePhone = [NSString stringWithFormat:@"mobile_phone_%d", number];
    return contact;
}

- (void)clearTable {
    NSValue *value = [NSValue valueWithPointer:(__bridge const void *)(ZyxContact.class)];
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Delete withParam:value];
}

// 1
- (void)test00_DeleteAllModelsInTable {
    NSValue *value = [NSValue valueWithPointer:(__bridge const void *)(ZyxContact.class)];
    NSDictionary *dict = @{kEasyFMDBModel:value, kEasyFMDBBlock:^(BOOL success) {
        XCTAssertTrue(success);
    }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Delete withParam:dict];
}

// 2
- (void)test10_AddModel {
    ZyxContact *contact = [self contact];
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Add withParam:contact];
    
    ZyxContact *model = [[ZyxContact alloc] init];
    model.age = 1;
    NSDictionary *dict = @{kEasyFMDBModel:model, kEasyFMDBBlock:^(BOOL success, NSArray *models){
        XCTAssertEqual(models.count, 1);
        ZyxContact *item = models.firstObject;
        XCTAssert([item.name isEqualToString:@"name_1"]);
    }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Query withParam:dict];
}

// 3
- (void)test11_AddModels {
    [self clearTable];
    
    NSMutableArray *contacts = [NSMutableArray arrayWithCapacity:16];
    for (int i=0; i<16; i++) {
        [contacts addObject:[self contact]];
    }
    
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Add withParam:contacts];
    
    ZyxContact *model = [[ZyxContact alloc] init];
    NSDictionary *dict = @{kEasyFMDBModel:model,
                           kEasyFMDBPropertiesValues:@{@"name": @[@"name_14", @"name_15"]},
                           kEasyFMDBBlock:^(BOOL success, NSArray *models){
                               XCTAssertEqual(models.count, 2);
                           }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Query withParam:dict];
}

// select * from T_ZyxContact where age = 10
- (void)test20_QueryModelByProperty {
    ZyxContact *model = [[ZyxContact alloc] init];
    model.age = 10;
    NSDictionary *dict = @{kEasyFMDBModel:model, kEasyFMDBBlock:^(BOOL success, NSArray *models){
        XCTAssertEqual(models.count, 1);
    }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Query withParam:dict];
}

// select * from T_ZyxContact where age = 10 or/and name = 'name_10'
- (void)test21_QueryModelByPropertiesAndLogics {
    ZyxContact *model = [[ZyxContact alloc] init];
    model.age = 10;
    model.name = @"name_10";
    NSDictionary *dict = @{kEasyFMDBModel:model,
                           kEasyFMDBLogics:@(LR_Or),    // if don't have this key-value，it will be LR_And
                           kEasyFMDBBlock:^(BOOL success, NSArray *models){
                               XCTAssertEqual(models.count, 1);
                           }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Query withParam:dict];
}

// select * from T_ZyxContact where name = 'name_10' or 'name = name_8'
// kEasyFMDBMatches 的顺序：先属性中设置的，然后再是dict中设置的
- (void)test22_QueryModelByPropertyWithMultiValues {
    ZyxContact *model = [[ZyxContact alloc] init];
    model.age = 10;
    
    NSDictionary *dict = @{kEasyFMDBModel:model,
                           kEasyFMDBPropertiesValues:@{@"name":@[@"name_10", @"name_8"]},
                           kEasyFMDBMatches:@[@(DCT_NotEqual), @[@(DCT_Equal), @(DCT_NotEqual)]],
                           kEasyFMDBBlock:^(BOOL success, NSArray *models){
                               XCTAssertTrue(models.count != 0);
                           }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Query withParam:dict];
}

// select * from T_ZyxContact where home_address like '%1%' and name  = 'name_13' and work_address like '%work%' and mobile_phone like '%phone%' and (age != 10 or age = 8)
- (void)test23_QueryModelByMultiPropertiesAndMatches {
    ZyxContact *model = [[ZyxContact alloc] init];
    model.homeAddress = @"1";
    model.name = @"name_13";
    model.workAddress = @"work";
    model.mobilePhone = @"phone";
    
    NSDictionary *dict = @{kEasyFMDBModel:model,
                           kEasyFMDBPropertiesValues:@{@"age":@[@"10", @"8"]},
                           kEasyFMDBMatches:@[@(DCT_Like), @(DCT_Equal), @(DCT_Like), @(DCT_Like), @[@(DCT_NotEqual), @(DCT_Equal)]],
                           kEasyFMDBBlock:^(BOOL success, NSArray *models){
                               XCTAssertTrue(models.count == 1);
                           }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Query withParam:dict];
}

// LR_And: intersection, LR_Or: union
// select * from T_ZyxContact where home_address like '%1%' and name  = 'name_13' or work_address like '%work%' and mobile_phone like '%phone%'
- (void)test24_QueryModelByMultiPropertiesAndMatchesAndLogics {
    ZyxContact *model = [[ZyxContact alloc] init];
    model.homeAddress = @"1";
    model.name = @"name_13";
    model.workAddress = @"address";
    model.mobilePhone = @"phone";
    
    NSDictionary *dict = @{kEasyFMDBModel:model,
                           kEasyFMDBMatches:@[@(DCT_Like), @(DCT_Equal), @(DCT_Like), @(DCT_Like)],
                           kEasyFMDBLogics:@[@(LR_And), @(LR_Or)],
                           kEasyFMDBBlock:^(BOOL success, NSArray *models){
                               XCTAssertTrue(models.count > 0);
                           }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Query withParam:dict];
}

// queryAll sql: select * from T_ZyxContact order by name desc
- (void)test25_QueryAllModels {
    NSDictionary *dict = @{kEasyFMDBModel:[NSValue valueWithPointer: (__bridge const void *)(ZyxContact.class)],
                           kEasyFMDBOrders:@{@"name": @"desc"},
                           kEasyFMDBBlock:^(BOOL success, NSArray *models){
                               XCTAssertTrue(models.count > 0);
                           }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Query withParam:dict];
}

// update T_ZyxContact set name='name_6_' where id = 2
- (void)test30_UpdateModelById {
    ZyxContact *contact = [[ZyxContact alloc] init];
    contact.id = 2;
    contact.name = @"name_2_2";
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Update withParam:contact];
    
    ZyxContact *model = [[ZyxContact alloc] init];
    model.id = 2;
    NSDictionary *dict = @{kEasyFMDBModel:model, kEasyFMDBBlock:^(BOOL success, NSArray *models){
        XCTAssertEqual(models.count, 1);
        ZyxContact *contact = models.firstObject;
        XCTAssertTrue([contact.name isEqualToString:@"name_2_2"]);
    }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Query withParam:dict];
}

// update T_ZyxContact set name='name_6_' where home_address = 'home_address_6'
- (void)test30_UpdateModelByPropertyExceptId {
    ZyxContact *contact = [[ZyxContact alloc] init];
    contact.homeAddress = @"home_address_6";
    contact.name = @"name_6_";
    NSDictionary *dict = @{kEasyFMDBModel:contact,
                           kEasyFMDBQueryProperties:@"homeAddress",
                           kEasyFMDBUpdateProperties:@"name",
                           kEasyFMDBBlock:^(BOOL success) {
                               XCTAssertTrue(success);
                           }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Update withParam:dict];
    
    ZyxContact *model = [[ZyxContact alloc] init];
    model.homeAddress = @"home_address_6";
    NSDictionary *dict2 = @{kEasyFMDBModel:model, kEasyFMDBBlock:^(BOOL success, NSArray *models){
        XCTAssertEqual(models.count, 1);
        ZyxContact *contact = models.firstObject;
        XCTAssertTrue([contact.name isEqualToString:@"name_6_"]);
    }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Query withParam:dict2];
}

// update T_ZyxContact set name='name_6_6', home_address = 'home_address_6' where id = 17
- (void)test30_UpdateModelByPropertiesAndValues {
    ZyxContact *contact = [[ZyxContact alloc] init];
    contact.id = 17;
    contact.homeAddress = @"home_address_xxxxx";
    contact.name = @"name_6_6";
    NSDictionary *dict = @{kEasyFMDBModel:contact,
                           kEasyFMDBBlock:^(BOOL success) {
                               XCTAssertTrue(success);
                           }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Update withParam:dict];
}

// update T_ZyxContact set home_address ='home_address_6' where name='name_6_6'
- (void)test31_UpdateModelByPropertiesAndValues {
    ZyxContact *contact = [[ZyxContact alloc] init];
    contact.homeAddress = @"home_address_xxxxx";
    contact.name = @"name_6_6";
    NSDictionary *dict = @{kEasyFMDBModel:contact,
                           kEasyFMDBQueryProperties:@"name",
                           kEasyFMDBUpdateProperties:@"homeAddress",
                           kEasyFMDBBlock:^(BOOL success) {
                               XCTAssertTrue(success);
                           }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Update withParam:dict];
}

// update T_ZyxContact set home_address = 'home_address_xxxxx', name='name_6_6' where id = 10 or id = 11 or id = 12;
- (void)test32_UpdateModelByPropertiesAndValues {
    ZyxContact *contact = [[ZyxContact alloc] init];
    contact.homeAddress = @"home_address_xxxxx";
    contact.name = @"name_6_6";
    NSDictionary *dict = @{kEasyFMDBModel:contact,
                           kEasyFMDBQueryPropertiesAndValues:@{@"id":@[@(10), @(11), @(12)]},
                           kEasyFMDBBlock:^(BOOL success) {
                               XCTAssertTrue(success);
                           }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Update withParam:dict];
}

// update T_ZyxContact set work_address = work_address_xxxxx, mobile_phone = mobile_phone_xxxxx
// where (id = 10 or id = 11 or id = 12) and (name = name_11)
- (void)test33_UpdateModelByMultiPropertyValues {
    ZyxContact *contact = [[ZyxContact alloc] init];
    contact.workAddress = @"work_address_xxxxx";
    contact.mobilePhone = @"mobile_phone_xxxxx";
    contact.name = @"name_11";
    NSDictionary *dict = @{kEasyFMDBModel:contact,
                           kEasyFMDBQueryProperties:@"name",
                           kEasyFMDBQueryPropertiesAndValues:@{@"id":@[@(10), @(11), @(12)]},
                           kEasyFMDBUpdateProperties:@[@"workAddress", @"mobilePhone"],
                           kEasyFMDBBlock:^(BOOL success) {
                               XCTAssertTrue(success);
                           }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Update withParam:dict];
}

// update T_ZyxContact set work_address = work_address_8 where work_address = work_address_7
- (void)test34_UpdateModel {
    ZyxContact *contact = [[ZyxContact alloc] init];
    contact.workAddress = @"work_address_8";
    NSDictionary *dict = @{kEasyFMDBModel:contact,
                           kEasyFMDBQueryPropertiesAndValues:@{@"workAddress":@"work_address_7"}};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Update withParam:dict];
}

- (void)test40_OneToOneRelationship {
    Teacher *teacher = [[Teacher alloc] init];
    teacher.name = @"teacher1";
    teacher.age = 50;
    
    Student *student = [[Student alloc] init];
    student.age = 10;
    student.xxx = 20;
    student.heavy = 56.1;
    student.teacher = teacher;
    [[ZyxFMDBManager sharedInstance] callCapabilityType:EasyFMDBCapabilityType_Add withParam:student];
    XCTAssertTrue(teacher.id > 0 && student.id > 0);
    
    DBQueryOperationResultBlock block = ^(BOOL success, NSArray *result) {
        Student *student = result.firstObject;
        NSLog(@"teach name = %@", student.teacher.name);
        XCTAssertTrue([student.teacher.name isEqualToString:teacher.name]);
    };
    // select * from T_Student where (age = 10) and (xxx = 20) and (heavy = 56.1) and (teacher_id = 3) and (id = 3)
    [[ZyxFMDBManager sharedInstance] callCapabilityType:EasyFMDBCapabilityType_Query withParam:@{@"model":student, @"block": block}];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
