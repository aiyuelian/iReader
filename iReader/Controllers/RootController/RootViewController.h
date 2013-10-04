//
//  RootViewController.h
//  iReader
//
//  Created by chenyu on 13-10-3.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"

@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
{
    @protected
    NSInteger m_breakPoint;
    PullTableView *m_flatListView;
}

//@property(nonatomic,weak) id<ControllerCenterDelegate> switchViewDelegate;

- (BOOL)setBreakPointToZero;
- (BOOL)addOffsetToBreakPoint :(NSInteger)offset;
- (NSInteger)getBooksSegment :(NSArray*)books;
//- (void)rightButtonPressed ;
@end
