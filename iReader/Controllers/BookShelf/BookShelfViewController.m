//
//  BookShelfViewController.m
//  iReader
//
//  Created by chenyu on 13-10-1.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "BookShelfViewController.h"
#import "CustomTableViewCellForBookShelf.h"
#import "BookDisplayView.h"


@interface BookShelfViewController ()

@end

@implementation BookShelfViewController

- (id)initWithArray:(NSArray *)parmBooks
{
    self = [super init];
    if(self)
    {
        [self.view addSubview:m_flatListView];
        bookModel = [[BooksInfo alloc]init];
        //[bookModel set]
        displayBooks = [NSMutableArray arrayWithArray:parmBooks];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kBookViewRefreshNotificationName object:nil];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if(self)
    {
        bookModel = [[BooksInfo alloc]init];
        displayBooks = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kBookViewRefreshNotificationName object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [self.view addSubview:m_flatListView];
    [bookModel request:[bookModel getBookKind]:kBookShelfViewControllerName];
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
}
#pragma mark - 接口函数

- (BOOL)setRightButtonPressedAction:(RightButtonPressed)action
{
    //rightButtonPressed = action;
    return YES;
}
- (BOOL)setBookKind:(NSString *)parmBookKind
{
    [bookModel setBookKind:parmBookKind];
    return YES;
}

#pragma mark - 右导航栏按钮的action

- (void)rightButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 私有函数

- (BOOL)loadData
{
    NSInteger displayDataCount = [self getBooksSegment:[bookModel getBooksArray]];
    NSArray *subBooks = [[bookModel getBooksArray] subarrayWithRange:NSMakeRange(m_breakPoint, displayDataCount)];
    [self addOffsetToBreakPoint:displayDataCount];
    if(displayDataCount != 0)
    {
        [displayBooks addObjectsFromArray:subBooks];
        [m_flatListView reloadData];
        
    }
    
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
    return YES;
}

#pragma mark - 接收通知函数

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)recieveModelChangeNotification:(NSNotification*)notification
{
    [self setBreakPointToZero];
    [displayBooks removeAllObjects];
    
    NSInteger displayBooksCount = [self getBooksSegment:[bookModel getBooksArray]];
    [displayBooks addObjectsFromArray:[[bookModel getBooksArray] subarrayWithRange:NSMakeRange(m_breakPoint, displayBooksCount)]];
    [self addOffsetToBreakPoint:displayBooksCount];
    
    
    m_flatListView.pullLastRefreshDate = [NSDate date];
    m_flatListView.pullTableIsRefreshing = NO;
    [m_flatListView reloadData];
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
    return YES;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    NSString *identify  = @"cell";
    CustomTableViewCellForBookShelf *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil)
        cell = [[CustomTableViewCellForBookShelf alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    if(cell)
    {
        NSArray *subArrays = [cell.contentView subviews];
        for (UIView *view in subArrays)
        {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i != kSubViewCountInCell; i++)
    {
        BookDisplayView *displayView = [[BookDisplayView alloc]init];
        if(row*kSubViewCountInCell +i == displayBooks.count)
        {
            NSLog(@"break");
            break;
        }

        Book *book = [displayBooks objectAtIndex:row*kSubViewCountInCell +i];
        
        NSString *path = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[bookModel getBookKind]] stringByAppendingPathComponent:[[book.images.small componentsSeparatedByString:@"/"] lastObject]];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [displayView setImageViewPic:[UIImage imageWithContentsOfFile:path]];
            
        }else
        {
            [displayView setLoadImageFinish:[self createLoadfinishBlock:[displayView getEGOImageView] :bookModel]];
            [displayView setImageViewUrl:book.images.small];
        }
        
        CGRect frame = displayView.frame;
        frame.origin.x += i*(frame.size.width +20) ;
        displayView.frame = frame;
        [cell.contentView addSubview:displayView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(displayBooks.count%kSubViewCountInCell == 0)
        return displayBooks.count / kSubViewCountInCell;
    return displayBooks.count / kSubViewCountInCell + 1;
}

#pragma mark - 接口方法

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kBookViewRefreshNotificationName object:nil];
}



#pragma mark - 下拉刷新上拉加载的Delegate

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self loadData];
}
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [bookModel refresh];
}
@end
