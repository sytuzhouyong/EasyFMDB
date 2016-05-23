EasyFMDB
========
a easy way to use FMDB

[![Build Status](https://travis-ci.org/sytuzhouyong/EasyFMDB.svg?branch=master)](https://travis-ci.org/sytuzhouyong/EasyFMDB)

这是一个仿J2EE框架Hibernate并二次封装FMDB的一个上层数据库接口，想要达到的目的是：
不论数据模型有多少，都只需要一套接口就能实现数据库的基本操作。

目前代码的功能
--------------
   1. 实现数据库增、删、改、查的功能，局限在于每次操作只能作用于一张表。
   2. 能在程序运行的时候动态修改数据库表路径，目的是一个用户对应一张表。
   3. 在每次程序启动的时候能自动更新表中的字段，如果有新添加的属性就自动更新到表中。
      目前只能增加字段，不能删除字段。


准备工作：
---------
####1. 进入工程目录，运行pod install，安装依赖项目FMDB，打开workspace工程

####2. 定义自己的model，看起来像下面的代码：
	// ZyxContact.h
	@interface ZyxContact : ZyxBaseModel
	
	@property (nonatomic, copy) NSString *name;
	@property (nonatomic, assign) NSInteger age;
	@property (nonatomic, copy) NSString *homeAddress;
	@property (nonatomic, copy) NSString *workAddress;
	@property (nonatomic, copy) NSString *mobilePhone;
	
	@end
	
	// ZyxContact.m
	@implementation ZyxContact
	
	+ (void)load {
	  [ZyxBaseModel registeModel:self.class];
	}
	
	@end

####3. 导入接口文件。
    #import "EasyFMDB.h"

用例：
--------

#####1. 插入数据
      
    // 初始化除了id之外的属性
    ZyxContact *contact = [ZyxContact alloc] init];
    contact.name = @"zyx";
    [contact save];
    
#####2. 删除数据

######a. 根据主键id删除
       ZyxContact *contact = [[ZyxContact alloc] init];
       contact.id = 30;
       [contact delete];

######b. 根据其他属性删除，另外可以增加条件，eg. 设置的属性是精确匹配还是模糊匹配，属性之间的关系是 `and`还是`or`。

	// select * from T_ZyxContact where age = 10 or name = 'name_10'
	ZyxContact *model = [[ZyxContact alloc] init];
	model.age = 10;
	model.name = @"name_10";
    NSDictionary *dict = @{kEasyFMDBModel:model,
                        kEasyFMDBLogics:@(LR_Or),    // if don't have this key-value，it will be LR_And
                        kEasyFMDBBlock:^(BOOL success, NSArray *models){
       XCTAssertEqual(models.count, 1);
    }};
    [self.dbManager callCapabilityType:EasyFMDBCapabilityType_Query withParam:dict];

    // select * from T_ZyxContact where name = 'name_10' or 'name = name_8'
   	ZyxContact *model = [[ZyxContact alloc] init];
	model.age = 10;

	NSDictionary *dict = @{kEasyFMDBModel:model,
                       kEasyFMDBPropertiesValues:@{@"name":@[@"name_10", @"name_8"]},
                       kEasyFMDBMatches:@[@(ZyxCompareTypeNotEqual), @[@(ZyxCompareTypeEqual), @(ZyxCompareTypeNotEqual)]],
                     };
	[self.dbManager query:dict withCompletion:^(BOOL success, NSArray *models) {
    	XCTAssertTrue(models.count != 0);
	}];

    // select * from T_ZyxContact where home_address like '%1%' and name  = 'name_13' and work_address like '%work%' and mobile_phone like '%phone%'
    ZyxContact *model = [[ZyxContact alloc] init];
    model.homeAddress = @"1";
    model.name = @"name_13";
    model.workAddress = @"work";
    model.mobilePhone = @"phone";
 
    NSDictionary *dict = @{kEasyFMDBModel:model,
                         kEasyFMDBMatches:@[@(DCT_Like), @(DCT_Equal), @(DCT_Like), @(DCT_Like)],
                         kEasyFMDBBlock:^(BOOL success, NSArray *models){
                            XCTAssertTrue(models.count == 1);
                         }};
    [self.dbManager query:dict withCompletion:^(BOOL success, NSArray *models) {
   		XCTAssertTrue(success);
   	}];
      
#####3. 更新数据

######a. 根据主键id修改
       // update T_ZyxContact set name='name_6_6', home_address = 'home_address_6' where id = 17
       ZyxContact *contact = [[ZyxContact alloc] init];
       contact.id = 17;
       contact.homeAddress = @"home_address_xxxxx";
       contact.name = @"name_6_6";
       [contact update];
    
######b. 根据其他属性选择更新的对象

       // update T_ZyxContact set home_address = 'home_address_6' where name = 'name_6_6'
       ZyxContact *contact = [[ZyxContact alloc] init];
       contact.homeAddress = @"home_address_xxxxx";
       contact.name = @"name_6_6";
       NSDictionary *dict = @{kEasyFMDBModel:contact,
                            kEasyFMDBQueryProperties:@"name",
                            kEasyFMDBUpdateProperties:@"homeAddress",
                            kEasyFMDBBlock:^(BOOL success) {
                               XCTAssertTrue(success);
                            }};
        [self.dbManager update:dict withCompletion:^(BOOL success) {
        	XCTAssertTrue(success);
        }];

#####4. 查询数据
   查询数据和删除功能中的查找部分代码类似，具体代码可以在 TestEasyFMDBTests.m 中找到。
以上功能只是一部分代码，配合不同的参数基本可以实现对单表的任意操作。   

<br />

# 版本更新历史
###2.0.0版本主要更新：
1. #### 简化接口名称，老接口已经移除
`ZyxBaseModel`直接提供数据库基本操作接口，但是功能没有直接调用ZyxFMDBManager强大。
详细接口请见测试用例

2. #### 提供数据库操作的同步方法，复杂功能还没有支持，下个版本会增加
详细接口请见测试用例
<br />

### 1.1.0版本主要更新：
* #### 支持简单的一对一关系模型，模型代码看起来像这样：
	
		@interface Teacher : ZyxBaseModel
		
		@property (nonatomic, copy) NSString name;
		
		@end
		
		@interface Student : ZyxBaseModel
		
		@property (nonatomic, copy) NSString name;
		@property (nonatomic, strong) Teacher *teacher;
		
		@end	

数据基本操作代码和上面保持一致，具体参见 Tests/TestEasyFMDBTests.m 中的方法 test40_OneToOneRelationship。

* #### 注意点：
	1. 如果查询操作中有关联对象，那么只有关联对象的id有效果，其余属性暂时不起作用，这个功能后面版本再完善，测试代码可以见 Tests/TestEasyFMDBTests.m 中的方法test40_OneToOneRelationship
	
	2. 基本数据类型暂时不再支持int, long, float 等，需要变成NSInteger, CGFloat类型






