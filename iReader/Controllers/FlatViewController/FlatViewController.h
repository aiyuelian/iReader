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
#import "CustomTableViewCellForFlat.h"



@interface FlatViewController :RootViewController
{
    @private
    NSMutableArray *displayBooks;
    BooksInfo *bookModel;
    NSTimer *timer;
}

- (id)initWithModel :(BooksInfo*)parmBookModel;

- (void)setRequestKind :(NSString*)kindName;
- (BOOL)requestData;

- (NSArray*)getCurrentDisplayBooks;
- (BooksInfo*)getBookModel;



@end
