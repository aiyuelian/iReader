//
//  AppDelegate.h
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InCodeMappingProvider.h"
#import "iReaderManager.h"
#import "FlatViewController.h"

@class FlatViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) InCodeMappingProvider *inCodeMappingProvider;

//@property (strong, nonatomic) iReaderManager *manager;
@property (strong,nonatomic) UINavigationController *navigationController;
@property (strong,nonatomic) UIToolbar *toolbar;
@property (strong,nonatomic) FlatViewController *flatViewController;
//@property (strong,nonatomic) ControllerCenter *controllerCenter;

@end
