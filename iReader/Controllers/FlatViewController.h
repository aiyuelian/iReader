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


@interface FlatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGOImageViewDelegate,PullTableViewDelegate>
{
    @private
    PullTableView *listFlatView;
    NSMutableArray *books;
    NSString *refash;
    NSString *loadMore;
    NSString *bookKind;
    
    RightButtonPressed rightButtonPressed;
    
    
}

- (id)initWithArray :(NSArray*)parmBooks;

- (void)refashData;
- (void)loadMoreData;
- (BOOL)setBookKind :(NSString*)parmBookKind;

- (BOOL)setRightButtonPressedAction:(RightButtonPressed)action;

@end
