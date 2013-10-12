//
//  AppDelegate.m
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "AppDelegate.h"

#import "FlatViewController.h"
#import "ObjectInstanceProvider.h"
#import "CommonLoggingProvider.h"
#import "ObjectMapper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ObjectInstanceProvider *instanceProvider = [[ObjectInstanceProvider alloc] init];
	self.inCodeMappingProvider = [[InCodeMappingProvider alloc] init];
	CommonLoggingProvider *commonLoggingProvider = [[CommonLoggingProvider alloc] initWithLogLevel:LogLevelInfo];
	
	[[ObjectMapper sharedInstance] setInstanceProvider:instanceProvider];
	[[ObjectMapper sharedInstance] setMappingProvider:self.inCodeMappingProvider];
	[[ObjectMapper sharedInstance] setLoggingProvider:commonLoggingProvider];
    [self.inCodeMappingProvider mapFromDictionaryKey:@"id" toPropertyKey:@"bookId" forClass:[Book class]];
    
    self.flatViewController = [[FlatViewController alloc]init];
    [self.flatViewController setRequestKind:@"python"];
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:self.flatViewController];
    self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 447, 320, 33)];
    
    UIBarButtonItem *btnSwitch = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnSwitchPressed)];
    
    UIBarButtonItem *sp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *btnList = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"list.png"] style:UIBarButtonItemStylePlain target:self action:@selector(btnListPressed)];
    


    NSArray *items = [NSArray arrayWithObjects:btnList,sp,btnSwitch, nil];
    [self.toolbar setItems:items animated:YES];
    self.toolbar.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:self.toolbar];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    //[self.window addSubview:self.toolbar];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - toolBar Button Action

- (void)btnListPressed
{
    NSArray *viewcontrollers = [self.navigationController viewControllers];
    int count = [viewcontrollers count];
    if(![[viewcontrollers objectAtIndex:count-1] isEqual:self.flatViewController])
        [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)btnSwitchPressed
{
    NSArray *viewcontrollers = [self.navigationController viewControllers];
    int count = [viewcontrollers count];
    if([[viewcontrollers objectAtIndex:count-1] isEqual:self.flatViewController])
    {
        BookShelfViewController *bookShelfController = [[BookShelfViewController alloc]initWithBookInfoModel:[self.flatViewController getBookModel]];
        [self.navigationController pushViewController:bookShelfController animated:YES];
    }
}


#pragma mark - 系统代理

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
