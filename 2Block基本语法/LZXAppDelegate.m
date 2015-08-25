//
//  LZXAppDelegate.m
//  2Block基本语法
//
//  Created by LZXuan on 14-12-9.
//  Copyright (c) 2014年 LZXuan. All rights reserved.
//

#import "LZXAppDelegate.h"

//用typedef 定义了一个新的类型
//就是给int (*)(int,int) 起了一个别名 FuncPoint
typedef int (*FuncPoint) (int ,int) ;

//typedef 定义 无参无返回值 的新类型

typedef void(^NewBlock)(void);//别名 NewBlock

typedef int (^NewBlock2)(int,int);//别名NewBlock2

typedef NSString * (^NewBlock3) (NSString *,NSString *);

int add(int a, int b) {
    return a+b;
}
int sub(int a, int b) {
    return a-b;
}

@implementation LZXAppDelegate
{
    int _height;
}
- (void)dealloc {
    self.window = nil;
    [super dealloc];
}
- (void)testFuncPoint {
    //把一个函数的地址 赋给 pFunc
    
    int (*pFunc) (int ,int) = add;
    int sum = pFunc(1,2);
    NSLog(@"sum:%d",sum);
    
    pFunc = sub;
    NSLog(@"sub:%d",pFunc(2, 3));
    
    //使用typedef 定义的新类型
    FuncPoint p = add;
    NSLog(@"%d",p(1,2));
    
}

- (void)testBlock {
    // ^代码块 表示 使用的是block语法
    
    //block 就是一堆代码，一个代码块 没有名字 相当于匿名函数
    //它和 C语言的函数指针很像
    
    void (^myBlock)(void) = ^ void(void) {
        NSLog(@"我是一个无名的代码块myBlock");
        return;
    };
    
    //调用block--->block变量名();
    myBlock();
    
    /*
     下面的就是一个block  block 代码块
     ^ void(void) {
        NSLog(@"我是一个无名的代码块myBlock");
     }
     
     //下面的myBlock 就是一个存放block的变量  myBlock 存放的就是block代码块的地址
     void (^myBlock)(void);
     
     //调用 block 
     myBlock();
     */
    
    //block也可以有参数 和 返回值
}
//block 参数 和返回值
- (void)testBlock2 {
    //1.无参 无返回值的block
    //定义block变量
    void (^myBlock)(void);
    /*
     写block 代码块的时候 返回值类型 可以不写 如果参数 是void 那么参数也可以不写
     */
    myBlock = ^void (void) {
        NSLog(@"我是无参无返回值代码块myBlock 1");
    };
    //调用block
    myBlock ();
    
    myBlock = ^ {//参数是void 可以省去，返回值类型可以省去
        NSLog(@"我是无参无返回值代码块myBlock 2");
    };
    //调用
    myBlock();
    //2.有参 有返回值的block
    int (^myBlock2)(int,int) = ^int (int a,int b){
        return a+b;
    };
    //调用 传参
    int sum = myBlock2(1,2);//1+2
    NSLog(@"sum:%d",sum);
    
    //实现一个block 求两个数中的最大值
    
    int (^maxOfTwo)(int , int) = ^int(int a, int b) {
        return a > b?a:b;
    };
    
    NSLog(@"max:%d",maxOfTwo(22,33));
}
//typedef 定义
- (void)testTypedefBlock {
    //定义block 变量 myBlock1
    NewBlock myBlock1 = ^ {
        NSLog(@"myBlock1");
    };
    //调用block
    myBlock1();
    
    NewBlock2 myBlock2 = ^(int a, int b) {
        return a+b;
    };
    //调用求和
    NSLog(@"new:%d",myBlock2(1,2));
    //实现一个block  拼接两个字符串
    
    NewBlock3 appString = ^(NSString *str1,NSString *str2) {
        return [str1 stringByAppendingString:str2];
    };
    
    NSLog(@"newStr:%@",appString(@"xiaohong love ",@"xiaofen"));
}
//block 作为参数
- (void)testBlock3 {
    
    NewBlock myBlock = ^ {
        NSLog(@"myBlock");
    };

    [self runBlock1:myBlock];
    //把block代码块传入函数内部直接调用block
    [self runBlock1:^{
        NSLog(@"run block");
    }];
    
    //运行两个block
    [self runBlock1:^{
        NSLog(@"run block1");
    } block2:^int(int a, int b) {
        return a*b;
    }];

}
//运行 无参无返回值的block
- (void)runBlock1:(NewBlock) block{
    block();
}
//把两个block 传入函数进行调用
- (void)runBlock1:(NewBlock)block1 block2:(NewBlock2)block2 {
    block1();
    NSLog(@"block2--->%d",block2(2,2));
}

- (void)testBlock4 {
    //block 访问 函数内部的局部变量
    
    int age = 10;
    
    __block int cnt = 0;//用__block 修改函数内部的局部变量 这样 表示 局部变量cnt 可以在 block 中进行修改 达到和block代码块 共享一个变量的目的
    
    cnt++;
    void (^myBlock)(void) = ^ {
        NSLog(@"age:%d",age);//block 内部 只可以读 函数中的局部变量
        //age = 1;函数内部的局部变量是不能在block中修改的
        
        _height = 20;//当前类的成员变量(或者全局变量)可以在block内部修改
        
        cnt++;//block 可以修改 函数内部用__block修饰的变量
        NSLog(@"cnt:%d",cnt);
    };
    cnt++;
    //执行block  不调用block  block内部代码 不会执行
    myBlock();
    NSLog(@"test_cnt:%d",cnt);
}

//拷贝block
- (void)testCopyBlock {
    int cnt = 1;
    int (^myBlock)(int,int)  = ^(int a, int b) {
        NSLog(@"myBlock_cnt:%d",cnt);
        return a+b;
    } ;
    //实际上 block 代码块 是一个特殊的oc 的对象
    //把block 代码块对象地址 给了myBlock
    
    
    int sum = myBlock(1,2);
    NSLog(@"sum:%d",sum);
    //一般在对block 对象进行操作的时候 使用copy 拷贝
    int (^newBlock)(int,int) = [myBlock copy];
   
    //block 还可以这样拷贝 释放
//    newBlock = Block_copy(myBlock);
//    Block_release(newBlock);
    
    sum = newBlock(1,1);
    NSLog(@"sum2:%d",sum);
    
    
    NSLog(@"myBlock:%@",myBlock);
    NSLog(@"newBlock:%@",newBlock);

    //用完之后要release  ----》对应的是前面的copy
    [newBlock release];

}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    [self testFuncPoint];
    [self testBlock];
    //[self testBlock2];
    
    //[self testTypedefBlock];
  [self testBlock3];
    //[self testBlock4];
    
    
    //[self testCopyBlock];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
