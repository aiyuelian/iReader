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
#import "CustomTableViewCellForBookShelf.h"
#import "BooksInfo.h"



@interface BookShelfViewController : RootViewController
{
    @private
    BooksInfo *bookModel;
    NSMutableArray *displayBooks;
}

@property (nonatomic,strong) BooksInfo *bookModel;

- (id)initWithArray :(NSArray*)parmBooks;
- (BOOL)setBookKind :(NSString*)parmBookKind;
- (BOOL)request :(NSString*)controllerName;

@end
