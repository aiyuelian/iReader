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

#pragma mark - 发出kvo

-(void)refashData
{
    [self setValue:@"refash" forKey:@"refash"];
}
- (void)loadMoreData
{
    [self setValue:@"loadMore" forKey:@"loadMore"];
}
#pragma mark - 共有方法

- (id)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kFVCNotifyModelChange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullUpLoadMoreNotification:) name:kFVCPullUpLoadMoew object:nil];
        //books = [[NSMutableArray alloc]init];
    }      
    return self;
}
- (id)initWithArray :(NSArray*)parmBooks
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kFVCNotifyModelChange object:nil];
       
        books = [NSMutableArray arrayWithArray:parmBooks];
    }
    return self;
}
- (BOOL)pullUpLoadMoreNotification :(NSNotification*)notification
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.1f];
    NSDictionary *parmDic = [notification object];
    NSArray *subBooks = [NSArray arrayWithArray:[parmDic objectForKey:@"books"]];
    if(subBooks != nil)
    {
        [books addObjectsFromArray:subBooks];
        [listFlatView reloadData];
    }
    
   
    return YES;
}
- (BOOL)recieveModelChangeNotification:(NSNotification*)notification
{
    NSDictionary *parmDic = [notification object];
    books = [[NSMutableArray alloc]initWithArray:(NSArray*)[parmDic objectForKey:@"books"]];
    bookKind = [NSString stringWithString:[parmDic objectForKey:@"bookKind"]];
    listFlatView.pullLastRefreshDate = [NSDate date];
    listFlatView.pullTableIsRefreshing = NO;
    [listFlatView reloadData];
    return YES;
}

- (BOOL)setBookKind:(NSString *)parmBookKind
{
    bookKind = [NSString stringWithString:parmBookKind];
    return YES;
}
- (BOOL)setRightButtonPressedAction:(RightButtonPressed)action
{
    rightButtonPressed = action;
    return YES;
}
#pragma mark - 默认方法
- (void)viewDidLoad
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 32, 32);
    [btn setBackgroundImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnItem;
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    listFlatView = [[PullTableView alloc]initWithFrame:CGRectMake(0, 0, 320, 420)];
    listFlatView.pullDelegate = self;
    [self.view addSubview:listFlatView];
    listFlatView.delegate = self;
    listFlatView.dataSource = self;
    
   listFlatView.pullArrowImage = [UIImage imageNamed:@"blackArrow.png"];
   listFlatView.pullBackgroundColor = [UIColor yellowColor];
   listFlatView.pullTextColor = [UIColor blackColor];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - 右按钮的action

- (void)rightButtonPressed
{
    rightButtonPressed(books,bookKind);
}

#pragma mark - UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCellForFlat *cell = [tableView dequeueReusableCellWithIdentifier:kFVCCellIdentifier];
    if(cell == nil)
        cell = [[CustomTableViewCellForFlat alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFVCCellIdentifier];
    if([books count]< indexPath.row+1) return nil;
    Book *book = [books objectAtIndex:indexPath.row];
    [cell setTitleFrame:CGRectMake(90, 0,230, 30)];
    [cell setTitleText:book.title];
    
    NSString *imagePath = [self getImagePath:book.images.small];
    if(![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        [cell setImageViewUrl:book.images.small];
        [cell setImageLoad:[self createLoadfinishBlock:[cell getImageView]]];
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
- (LoadImageFinish)createLoadfinishBlock :(EGOImageView*)parmimageView
{
    LoadImageFinish blk = ^(EGOImageView *parmimageView){
    

        NSString *url = [parmimageView.imageURL absoluteString];
        NSString *imageName = [[url componentsSeparatedByString:@"/"] lastObject];
        NSString *imageFilePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:bookKind] stringByAppendingPathComponent:imageName];
        if(![[NSFileManager defaultManager] fileExistsAtPath:imageFilePath])
        {
            NSData *data =UIImageJPEGRepresentation(parmimageView.image, 1.f);
            [data writeToFile:imageFilePath atomically:YES];
        }
    };
    return blk;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [books count];
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
    path = [path stringByAppendingPathComponent:bookKind];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFVCNotifyModelChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFVCPullUpLoadMoew object:nil];
}


#pragma mark - 下拉刷新，上拉加载代理
- (void) refreshTable
{
    listFlatView.pullLastRefreshDate = [NSDate date];
    listFlatView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    listFlatView.pullTableIsLoadingMore = NO;
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self refashData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self loadMoreData];
}
@end
