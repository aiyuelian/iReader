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

//@synthesize bookModel = _bookModel;

#pragma mark - 初始化函数

- (id)initWithBookInfoModel:(BooksInfo *)parmBookModel
{
    self = [super init];
    if(self)
    {
        bookModel = parmBookModel;
        displayBooks = [[NSMutableArray alloc]initWithArray:[[bookModel getBooksArray] subarrayWithRange:NSMakeRange(0, kSegmentCount)]];
        [self addOffsetToBreakPoint:kSegmentCount];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kBookViewRefreshNotificationName object:nil];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if(self)
    {
        displayBooks = [[NSMutableArray alloc]init];
        bookModel = [[BooksInfo alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kBookViewRefreshNotificationName object:nil];
    }
    return self;
}

#pragma mark - 系统函数
- (void)viewDidLoad
{
    self.m_flatListView.pullLastRefreshDate = [NSDate date];
    if([bookModel getBooksArray] == nil && [bookModel getBookKind] != nil){
        [self requestData];
    }
    [self.navigationItem setHidesBackButton:YES];
    [super viewDidLoad];
    [self.view addSubview:self.m_flatListView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 接口函数
- (void)setRequestKind:(NSString *)parmBookKind
{
    [bookModel setBookKind:parmBookKind];
}

- (void)requestData
{
    [bookModel request:kBookShelfViewControllerName];
}

- (BooksInfo*)getBookModel
{
    return bookModel;
}

#pragma mark - 右导航栏按钮的,覆写父类的方法

- (void)rightButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 私有函数

- (BOOL)loadMoreData
{
    NSInteger displayDataCount = [self getBooksSegment:[bookModel getBooksArray]];
    NSArray *subBooks = [[bookModel getBooksArray] subarrayWithRange:NSMakeRange(m_breakPoint, displayDataCount)];
    [self addOffsetToBreakPoint:displayDataCount];
    if(displayDataCount != 0)
    {
        [displayBooks addObjectsFromArray:subBooks];
        [self.m_flatListView reloadData];
    }
    [self performSelector:@selector(stopPullUpRefresh) withObject:nil afterDelay:0.1f];
    return YES;
}
- (void)clearExistCellContent :(UITableViewCell*)cell
{
    NSArray *subArrays = [cell.contentView subviews];
    for (UIView *view in subArrays)
        [view removeFromSuperview];
}
- (BOOL)loadCellImage :(BookDisplayView*)displayView :(NSString*)path :(Book*)book
{
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [displayView setImageViewPic:[UIImage imageWithContentsOfFile:path]];
        return NO;
        
    }else
    {
        [displayView setLoadImageFinish:[self createLoadfinishBlock:[displayView getEGOImageView] :bookModel]];
        [displayView setImageViewUrl:book.images.small];
        return YES;
    }
}
- (void)setCellImageFrmame :(BookDisplayView*)displayView :(int)index
{
    CGRect frame = displayView.frame;
    frame.origin.x += index*(frame.size.width +20) ;
    displayView.frame = frame;
}

- (void)displayBooksOnCell :(UITableViewCell*)cell :(int)row
{
    for (int i = 0; i != kSubViewCountInCell; i++)
    {
        BookDisplayView *displayView = [[BookDisplayView alloc]init];
        if(row*kSubViewCountInCell +i == displayBooks.count)
            break;
        Book *book = [displayBooks objectAtIndex:row*kSubViewCountInCell +i];
        
        NSString *imagePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[bookModel getBookKind]] stringByAppendingPathComponent:[[book.images.small componentsSeparatedByString:@"/"] lastObject]];
        [self loadCellImage:displayView :imagePath :book];
        [self setCellImageFrmame:displayView :i];
        [cell.contentView addSubview:displayView];
    }
}

#pragma mark - 接收通知函数

- (BOOL)recieveModelChangeNotification:(NSNotification*)notification
{
    [self setBreakPointToZero];
    [displayBooks removeAllObjects];
    
    NSInteger displayBooksCount = [self getBooksSegment:[bookModel getBooksArray]];
    [displayBooks addObjectsFromArray:[[bookModel getBooksArray] subarrayWithRange:NSMakeRange(m_breakPoint, displayBooksCount)]];
    [self addOffsetToBreakPoint:displayBooksCount];
    
    
    self.m_flatListView.pullLastRefreshDate = [NSDate date];
    self.m_flatListView.pullTableIsRefreshing = NO;
    [self.m_flatListView reloadData];
    [self performSelector:@selector(stopPullDownRefresh) withObject:nil afterDelay:0.1f];
    return YES;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify  = @"cell";
    CustomTableViewCellForBookShelf *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell)
        [self clearExistCellContent:cell];
    if(!cell)
        cell = [[CustomTableViewCellForBookShelf alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    
    [self displayBooksOnCell:cell :indexPath.row];
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
    [self loadMoreData];
}
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [bookModel refresh :kBookShelfViewControllerName];
}
@end
