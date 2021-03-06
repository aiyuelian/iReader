//
//  AppDelegate.h
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InCodeMappingProvider.h"
#import "FlatViewController.h"
#import "Book.h"
#import "BookShelfViewController.h"
#import "AutoLayoutControl.h"

@class FlatViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) InCodeMappingProvider *inCodeMappingProvider;

//@property (strong, nonatomic) iReaderManager *manager;
@property (strong,nonatomic) UINavigationController *navigationController;
@property (strong,nonatomic) UIToolbar *toolbar;
@property (strong,nonatomic) FlatViewController *flatViewController;
@property (strong,nonatomic) BookShelfViewController *bookShelfController;

@end
