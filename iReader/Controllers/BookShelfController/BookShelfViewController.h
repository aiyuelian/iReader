//
//  BookShelfViewController.h
//  iReader
//
//  Created by chenyu on 13-10-1.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookDisplayView.h"
#import "Config.h"
#import "Book.h"
#import "BlockDef.h"
#import "RootViewController.h"
#import "BooksInfo.h"



@interface BookShelfViewController : RootViewController


@property (nonatomic,strong) BooksInfo *bookModel;
@property (nonatomic,strong) NSMutableArray *displayBooks;

- (id)initWithBookInfoModel :(BooksInfo*)parmBookModel;
- (void)requestData;
- (void)setRequestKind :(NSString*)kindName;

@end
