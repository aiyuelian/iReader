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

- (id)init
{
    self = [super init];
    if(self)
        m_breakPoint = 0;
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
    
    m_flatListView = [[PullTableView alloc]initWithFrame:CGRectMake(0, 0, 320, 420)];
    m_flatListView.pullDelegate = self;
    [self.view addSubview:m_flatListView];
    m_flatListView.delegate = self;
    m_flatListView.dataSource = self;
    
    m_flatListView.pullArrowImage = [UIImage imageNamed:@"blackArrow.png"];
    m_flatListView.pullBackgroundColor = [UIColor yellowColor];
    m_flatListView.pullTextColor = [UIColor blackColor];

    
}

#pragma mark - 按钮的action
- (void)rightButtonPressed 
{
}

#pragma  mark - 接口方法

- (BOOL)setBreakPointToZero
{
    m_breakPoint = 0;
    return YES;
}

- (BOOL)addOffsetToBreakPoint:(NSInteger)offset
{
    m_breakPoint += offset;
    return YES;
}
- (NSInteger)getBooksSegment :(NSArray*)parmBooks
{
    NSInteger bookCount = parmBooks.count - m_breakPoint;
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

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
}

@end
