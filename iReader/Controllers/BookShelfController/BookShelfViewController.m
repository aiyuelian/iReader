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


#pragma mark - 初始化函数

- (id)initWithBookInfoModel:(BooksInfo *)parmBookModel
{
    self = [super init];
    if(self)
    {
        self.bookModel = parmBookModel;
        self.displayBooks = [[NSMutableArray alloc]initWithArray:[self.bookModel.bookArray subarrayWithRange:NSMakeRange(0, kSegmentCount)]];
        self.breakPoint += kSegmentCount;
    }
    return self;
}
- (id)init
{
    self = [super init];
    if(self)
    {
        self.displayBooks = [[NSMutableArray alloc]init];
        self.bookModel = [[BooksInfo alloc]init];
       
    }
    return self;
}

#pragma mark - 系统函数
- (void)viewDidLoad
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kRefresh object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUnSuccess:) name:kRefreshError object:nil];
    self.flatListView.pullLastRefreshDate = [NSDate date];
    if(self.bookModel.bookArray == nil && self.bookModel.bookKind != nil){
        [self requestData];
    }
    [self.navigationItem setHidesBackButton:YES];
    [super viewDidLoad];
    [self.view addSubview:self.flatListView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 接口函数
- (void)setRequestKind:(NSString *)parmBookKind
{
    [self.bookModel setBookKind:parmBookKind];
}

- (void)requestData
{
    [self.bookModel requestData];
}

#pragma mark - 右导航栏按钮的,覆写父类的方法

- (void)rightButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 私有函数

- (BOOL)loadMoreData
{
    NSInteger displayDataCount = [self getBooksSegment:self.bookModel.bookArray];
    NSArray *subBooks = [self.bookModel.bookArray subarrayWithRange:NSMakeRange(self.breakPoint, displayDataCount)];
    self.breakPoint += displayDataCount;
    if(displayDataCount != 0)
    {
        [self.displayBooks addObjectsFromArray:subBooks];
        [self.flatListView reloadData];
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
        [displayView setImageViewUrl:book.images.small :[self createLoadfinishBlock:[displayView getEGOImageView] :self.bookModel]];
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
        if(row*kSubViewCountInCell +i == self.displayBooks.count)
            break;
        Book *book = [self.displayBooks objectAtIndex:row*kSubViewCountInCell +i];
        
        NSString *imagePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:self.bookModel.bookKind] stringByAppendingPathComponent:[[book.images.small componentsSeparatedByString:@"/"] lastObject]];
        [self loadCellImage:displayView :imagePath :book];
        [self setCellImageFrmame:displayView :i];
        [cell.contentView addSubview:displayView];
    }
}
- (void)fillDisplayBooks
{
    NSInteger displayBooksCount = [self getBooksSegment:self.bookModel.bookArray];
    [self.displayBooks addObjectsFromArray:[self.bookModel.bookArray subarrayWithRange:NSMakeRange(self.breakPoint, displayBooksCount)]];
    self.breakPoint += displayBooksCount;
    [self.flatListView reloadData];
}

#pragma mark - 接收通知函数

- (void)requestUnSuccess :(NSNotification*)notification
{
    [self performSelector:@selector(stopPullUpRefresh) withObject:nil afterDelay:0.1f];
    self.flatListView.pullTableIsRefreshing = NO;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请求失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (BOOL)recieveModelChangeNotification:(NSNotification*)notification
{

    [self performSelector:@selector(stopPullDownRefresh) withObject:nil afterDelay:0.1f];
    
    self.breakPoint = 0;
    [self.displayBooks removeAllObjects];
    NSInteger displayBooksCount = [self getBooksSegment:self.bookModel.bookArray];
    [self.displayBooks addObjectsFromArray:[self.bookModel.bookArray subarrayWithRange:NSMakeRange(self.breakPoint, displayBooksCount)]];
    self.breakPoint += displayBooksCount;
    [self.flatListView reloadData];
    
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
    if(self.displayBooks.count%kSubViewCountInCell == 0)
        return self.displayBooks.count / kSubViewCountInCell;
    return self.displayBooks.count / kSubViewCountInCell + 1;
}


#pragma mark - 下拉刷新上拉加载的Delegate

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self loadMoreData];
}
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self requestData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefresh object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshError object:nil];
}
@end
