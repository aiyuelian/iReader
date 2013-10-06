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

- (void)requestData:(NSString *)bookKindName
{
    [_bookModel requestData:bookKindName :flatViewControllerCode];
}

- (BOOL)loadData
{
    NSInteger displayDataCount = [self getBooksSegment:[_bookModel getBooksArray]];
    NSArray *subBooks = [[_bookModel getBooksArray] subarrayWithRange:NSMakeRange(m_breakPoint, displayDataCount)];
    [self addOffsetToBreakPoint:displayDataCount];
    if(displayDataCount != 0)
    {
        [_displayBooks addObjectsFromArray:subBooks];
         [m_flatListView reloadData];
        
    }
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
    return YES;
}
#pragma mark - 下拉刷新回调
- (BOOL)recieveModelChangeNotification:(NSNotification*)notification
{
    [self setBreakPointToZero];
    [_displayBooks removeAllObjects];
    
    NSInteger displayBooksCount = [self getBooksSegment:[_bookModel getBooksArray]];
    [_displayBooks addObjectsFromArray:[[_bookModel getBooksArray] subarrayWithRange:NSMakeRange(m_breakPoint, displayBooksCount)]];
    [self addOffsetToBreakPoint:displayBooksCount];
    
    
    m_flatListView.pullLastRefreshDate = [NSDate date];
    m_flatListView.pullTableIsRefreshing = NO;
    [m_flatListView reloadData];
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
    return YES;
}

#pragma mark - 默认方法
- (void)viewDidLoad
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kflatViewRefreshNotifiCationName object:nil];
    [self requestData:@"life"];
    //[_bookModel requestData:@"life" :flatViewControllerCode];

    [super viewDidLoad];
    [self.view addSubview:m_flatListView];
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
    [cell setTitleFrame:CGRectMake(90, 0,230, 30)];
    [cell setTitleText:book.title];
    
    NSString *imagePath = [self getImagePath:book.images.small];
    if(![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        [cell setImageViewUrl:book.images.small];
        [cell setImageLoad:[self createLoadfinishBlock:[cell getImageView] :_bookModel]];
    }
    else
    {
       NSArray *subViews = [cell.contentView subviews];
        for (UIView *view in subViews)
        {
            [view removeFromSuperview];
        }
        UIView *imageViewTemp = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath]];
        imageViewTemp.frame = CGRectMake(10, 10, 80, 100);
        [cell.contentView addSubview:imageViewTemp];
    }
    [cell setAuthorFrame:CGRectMake(90, 30, 230, 30)];
    [cell setAuthorText:book.author];
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

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kflatViewRefreshNotifiCationName object:nil];
}


#pragma mark - 下拉刷新，上拉加载代理


- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    //[self refashData];
    [_bookModel refresh :flatViewControllerCode];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self loadData];
    //[self loadMoreData];
}
@end
