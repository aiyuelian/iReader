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


@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
{
    @protected
    NSInteger m_breakPoint;
    //PullTableView *m_flatListView;
}
@property (nonatomic,strong) PullTableView *m_flatListView;
- (BOOL)setBreakPointToZero;
- (BOOL)addOffsetToBreakPoint :(NSInteger)offset;
- (NSInteger)getBooksSegment :(NSArray*)books;
- (LoadImageFinish)createLoadfinishBlock :(EGOImageView*)parmimageView :(BooksInfo*)bookModel;
@end
