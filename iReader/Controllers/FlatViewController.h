//
//  ListFlatViewController.h
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "Config.h"
#import "EGOImageView.h"
#import "BlockDef.h"
#import "PullTableView.h"
#import "BooksInfo.h"
#import "RootViewController.h"
#import "BookShelfViewController.h"



@interface FlatViewController :RootViewController
{
    @private
    NSMutableArray *displayBooks;
    BooksInfo *bookModel;
}

@property (nonatomic,strong) BooksInfo *bookModel;
@property (nonatomic,strong) NSMutableArray *displayBooks;

- (id)initWithArray :(NSArray*)parmBooks;

//测试添加
- (void)requestData :(NSString*)bookKindName;


@end
