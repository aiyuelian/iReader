//
//  RootViewController.m
//  iReader
//
//  Created by chenyu on 13-10-3.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "RootViewController.h"
#import "Config.h"

@interface RootViewController ()

@end

@implementation RootViewController

//@synthesize m_flatListView = _m_flatListView;
- (id)init
{
    self = [super init];
    if(self)
    {
        self.breakPoint = 0;
        CGRect frame;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= kIOS_7){
            frame = CGRectMake(0, 0, 320, 440);
        }else{
            frame = CGRectMake(0, 0, 320, 385);
        }
        self.flatListView = [[PullTableView alloc]initWithFrame:[AutoLayoutControl getFrameAccordingIOSVersion:frame] style:UITableViewStylePlain pullDownRefresh:YES pullUpLoadMore:YES];
        self.flatListView.pullDelegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 32, 32);
    [btn setBackgroundImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnItem;
    [self.navigationItem setHidesBackButton:YES];
    
    
   
    //[self.view addSubview:self.m_flatListView];
    self.flatListView.delegate = self;
    self.flatListView.dataSource = self;
    
    self.flatListView.pullArrowImage = [UIImage imageNamed:@"blackArrow.png"];
    self.flatListView.pullBackgroundColor = [UIColor yellowColor];
    self.flatListView.pullTextColor = [UIColor blackColor];

    
}

#pragma mark - 按钮的action
- (void)rightButtonPressed 
{
}

#pragma  mark - 接口方法

- (NSInteger)getBooksSegment :(NSArray*)parmBooks
{
    NSInteger bookCount = parmBooks.count - self.breakPoint;
    if(bookCount <= 0) return 0;
    if(bookCount <= kSegmentCount)
        return bookCount;
    return kSegmentCount; 
}
#pragma mark - 其他方法
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITableViewDelegate

- (void) stopPullDownRefresh
{
    self.flatListView.pullLastRefreshDate = [NSDate date];
    self.flatListView.pullTableIsRefreshing = NO;
}

- (void) stopPullUpRefresh
{
    self.flatListView.pullTableIsLoadingMore = NO;
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
}

#pragma mark - 异步加载图片的callBack块

- (LoadImageFinish)createLoadfinishBlock :(EGOImageView*)parmimageView :(BooksInfo*)bookModel
{
    LoadImageFinish blk = ^(EGOImageView *parmimageView){
        
        
        NSString *url = [parmimageView.imageURL absoluteString];
        NSString *imageName = [[url componentsSeparatedByString:@"/"] lastObject];
        NSString *imageFilePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:bookModel.bookKind] stringByAppendingPathComponent:imageName];
        if(![[NSFileManager defaultManager] fileExistsAtPath:imageFilePath])
        {
            NSData *data =UIImageJPEGRepresentation(parmimageView.image, 1.f);
            [data writeToFile:imageFilePath atomically:YES];
        }
    };
    return blk;
}

@end
