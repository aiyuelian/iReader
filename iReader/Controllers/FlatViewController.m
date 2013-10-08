//
//  ListFlatViewController.m
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "FlatViewController.h"
#import "CustomTableViewCellForFlat.h"

@interface FlatViewController ()

@end

@implementation FlatViewController

@synthesize bookModel = _bookModel,displayBooks = _displayBooks;

#pragma mark - 共有方法

- (id)init
{
    self = [super init];
    if(self)
    {
       
        _displayBooks = [[NSMutableArray alloc]init];
         _bookModel = [[BooksInfo alloc]init];
    }      
    return self;
}
- (id)initWithArray :(NSArray*)parmBooks
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kflatViewRefreshNotifiCationName object:nil];
         _bookModel = [[BooksInfo alloc]init];
       
        [_bookModel setBookdArray:parmBooks];
    }
    return self;
}
- (void)requestData
{
    [_bookModel request :kFlatViewControllerName];
}
- (void)setRequestKind:(NSString *)kindName
{
    [_bookModel setBookKind:kindName];
}
- (void)refreshData
{
    [_bookModel refresh];
}
- (NSString*)getBookkind
{
    return [_bookModel getBookKind];
}
#pragma mark - 默认方法
- (void)viewDidLoad
{
     [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kflatViewRefreshNotifiCationName object:nil];
    [self setRequestKind:@"c++"];
    [self requestData];
     
    [self.view addSubview:self.m_flatListView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - 右按钮的action

- (void)rightButtonPressed
{
    BookShelfViewController *bookShelfController = [[BookShelfViewController alloc]init];
    [bookShelfController setBookKind:[_bookModel getBookKind]];
    [self.navigationController pushViewController:bookShelfController animated:YES];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCellForFlat *cell = [tableView dequeueReusableCellWithIdentifier:kFVCCellIdentifier];
    if(cell == nil)
        cell = [[CustomTableViewCellForFlat alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFVCCellIdentifier];
    if([[_bookModel getBooksArray] count]< indexPath.row+1) return nil;
    Book *book = [[_bookModel getBooksArray] objectAtIndex:indexPath.row];
    
    [self configCellTitleAndAuthor:cell :book];
    [self loadCellImage:cell :book];
    return cell;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_displayBooks count];
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
        [cell setImageLoad:[self createLoadfinishBlock:[cell getImageView] :_bookModel]];
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
    for (UIView *view in subViews)
        [view removeFromSuperview];
}
- (BOOL)loadMoreData
{
    NSInteger displayDataCount = [self getBooksSegment:[_bookModel getBooksArray]];
    NSArray *subBooks = [[_bookModel getBooksArray] subarrayWithRange:NSMakeRange(m_breakPoint, displayDataCount)];
    [self addOffsetToBreakPoint:displayDataCount];
    if(displayDataCount != 0)
    {
        [_displayBooks addObjectsFromArray:subBooks];
        [self.m_flatListView reloadData];
        
    }
    [self performSelector:@selector(stopPullUpRefresh) withObject:nil afterDelay:0.1f];
    return YES;
}
- (NSString*)getImagePath :(NSString*)orgUrl
{
    NSArray *subStrArray = [orgUrl componentsSeparatedByString:@"/"];
    NSString *imageName = [subStrArray lastObject];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:[_bookModel getBookKind]];
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
    [_displayBooks removeAllObjects];
    
    NSInteger displayBooksCount = [self getBooksSegment:[_bookModel getBooksArray]];
    [_displayBooks addObjectsFromArray:[[_bookModel getBooksArray] subarrayWithRange:NSMakeRange(m_breakPoint, displayBooksCount)]];
    [self addOffsetToBreakPoint:displayBooksCount];
    
    self.m_flatListView.pullLastRefreshDate = [NSDate date];
    self.m_flatListView.pullTableIsRefreshing = NO;
    [self.m_flatListView reloadData];
    [self performSelector:@selector(stopPullDownRefresh) withObject:nil afterDelay:0.1f];
    return YES;
}


#pragma mark - 下拉刷新，上拉加载代理


- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self refreshData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self loadMoreData];
}

#pragma mark - dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kflatViewRefreshNotifiCationName object:nil];
}
@end
