//
//  RootViewController.h
//  iReader
//
//  Created by chenyu on 13-10-3.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "EGOImageView.h"
#import "BlockDef.h"
#import "BooksInfo.h"
#import "AutoLayoutControl.h"


@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
@property (nonatomic,strong) PullTableView *flatListView;
@property NSInteger breakPoint;

- (NSInteger)getBooksSegment :(NSArray*)books;
- (LoadImageFinish)createLoadfinishBlock :(EGOImageView*)parmimageView :(BooksInfo*)bookModel;
@end
