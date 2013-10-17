//
//  ListFlatViewController.m
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "FlatViewController.h"


@interface FlatViewController ()
{
    BOOL shouldExecutionviewWillAppearCode;
}
@end

@implementation FlatViewController

//@synthesize bookModel = _bookModel;

#pragma mark - 共有方法

- (id)initWithModel:(BooksInfo *)parmBookModel
{
    self = [super init];
    if(self){
        self.bookModel = parmBookModel;
        shouldExecutionviewWillAppearCode = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kflatViewRefreshNotifiCationName object:nil];
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
        shouldExecutionviewWillAppearCode = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kflatViewRefreshNotifiCationName object:nil];
    }      
    return self;
}
- (BOOL)requestData
{
   return [self.bookModel request :kFlatViewControllerName];
}
- (void)setRequestKind:(NSString *)kindName
{
    [self.bookModel setBookKind:kindName];
}
- (BooksInfo*)getBookModel
{
    return self.bookModel;
}



#pragma mark - 默认方法
- (void)viewWillAppear:(BOOL)animated
{
    if(!shouldExecutionviewWillAppearCode) return;
    shouldExecutionviewWillAppearCode = NO;
    if(!self.bookModel || !self.bookModel.bookKind) return;
    if(self.bookModel.bookKind && !self.bookModel.bookArray){
        [self.bookModel request:kFlatViewControllerName];
    }else
    {
        self.displayBooks = [[NSMutableArray alloc]initWithArray:[self.displayBooks subarrayWithRange:NSMakeRange(0, kSegmentCount)]];
        [self addOffsetToBreakPoint:kSegmentCount];
    }
}
- (void)viewDidLoad
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUnSuccess:) name:kFlatViewControllerError object:nil];
    [super viewDidLoad];
    [self.view addSubview:self.m_flatListView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - 右按钮的action

- (void)rightButtonPressed
{
    BookShelfViewController *bookShelfController = [[BookShelfViewController alloc]initWithBookInfoModel:self.bookModel];
    [self.navigationController pushViewController:bookShelfController animated:YES];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCellForFlat *cell = [tableView dequeueReusableCellWithIdentifier:kFVCCellIdentifier];
    if(cell == nil)
    {
       cell = [[CustomTableViewCellForFlat alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFVCCellIdentifier];
       [cell setImageLoad:nil];
    }
        
    if([self.bookModel.bookArray count]< indexPath.row+1) return nil;
    Book *book = [self.bookModel.bookArray objectAtIndex:indexPath.row];
    
    [self configCellTitleAndAuthor:cell :book];
    [self loadCellImage:cell :book];
    return cell;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.displayBooks count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
#pragma mark - 私有方法

- (BOOL)loadMoreData
{
    NSArray *booksArray = self.bookModel.bookArray;
    NSInteger displayDataCount = [self getBooksSegment:booksArray];
    if(displayDataCount != 0)
    {
        NSArray *subBooks = [booksArray subarrayWithRange:NSMakeRange(self.breakPoint, displayDataCount)];
        [self addOffsetToBreakPoint:displayDataCount];
        [self.displayBooks addObjectsFromArray:subBooks];
        [self.m_flatListView reloadData];
    }
    [self performSelector:@selector(stopPullUpRefresh) withObject:nil afterDelay:0.1f];
    return YES;
}

- (void)configCellTitleAndAuthor :(CustomTableViewCellForFlat*)cell :(Book*)book
{
    [cell setTitleFrame:CGRectMake(90, 0,230, 30)];
    [cell setTitleText:book.title];
    [cell setAuthorFrame:CGRectMake(90, 30, 230, 30)];
    [cell setAuthorText:book.author];
}
- (void)loadCellImage :(CustomTableViewCellForFlat*)cell :(Book*)book
{
    NSString *imagePath = [self getImagePath:book.images.small];
    if(![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        [cell setImageViewUrl:book.images.small];
        [cell setImageLoad:[self createLoadfinishBlock:[cell getImageView] :self.bookModel]];
    }
    else
    {
        [self clearCellContentView:cell];
        UIView *imageViewTemp = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath]];
        imageViewTemp.frame = CGRectMake(10, 10, 80, 100);
        [cell.contentView addSubview:imageViewTemp];
    }
}

- (void)clearCellContentView :(UITableViewCell*)cell
{
    NSArray *subViews = [cell.contentView subviews];
    for (UIView *view in subViews){
        [view removeFromSuperview];
    }
    
}

- (NSString*)getImagePath :(NSString*)orgUrl
{
    NSArray *subStrArray = [orgUrl componentsSeparatedByString:@"/"];
    NSString *imageName = [subStrArray lastObject];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:self.bookModel.bookKind];
    path = [path stringByAppendingPathComponent:imageName];
    return path;
}

#pragma mark - EGOImageViewDelegate

- (void)imageViewLoadedImage:(EGOImageView *)imageView
{
    NSString *url = [imageView.imageURL absoluteString];
    NSString *imageName = [[url componentsSeparatedByString:@"/"] lastObject];
    NSString *imageFilePath = [self getImagePath:imageName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:imageFilePath])
    {
        NSData *data =UIImageJPEGRepresentation(imageView.image, 1.f);
        [data writeToFile:imageFilePath atomically:YES];
    }
}
- (void)imageViewFailedToLoadImage:(EGOImageView *)imageView error:(NSError *)error
{
    
}

#pragma mark - 刷新通知回调
- (BOOL)recieveModelChangeNotification:(NSNotification*)notification
{
    [self setBreakPointToZero];
    [self.displayBooks removeAllObjects];
    
    NSInteger displayBooksCount = [self getBooksSegment:self.bookModel.bookArray];
    [self.displayBooks addObjectsFromArray:[self.bookModel.bookArray subarrayWithRange:NSMakeRange(self.breakPoint, displayBooksCount)]];
    [self addOffsetToBreakPoint:displayBooksCount];
    
    self.m_flatListView.pullLastRefreshDate = [NSDate date];
    self.m_flatListView.pullTableIsRefreshing = NO;
    [self.m_flatListView reloadData];
    [self performSelector:@selector(stopPullDownRefresh) withObject:nil afterDelay:0.1f];
    return YES;
}

#pragma mark - 联网失败

- (void)requestUnSuccess :(NSNotification*)notification
{
    [self performSelector:@selector(stopPullDownRefresh) withObject:nil afterDelay:0.1f];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请求失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}


#pragma mark - 下拉刷新，上拉加载代理

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self.bookModel refresh:kFlatViewControllerName];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self loadMoreData];
}

#pragma mark - dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kflatViewRefreshNotifiCationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFlatViewControllerError object:nil];
}
@end
