//
//  BookShelfViewController.m
//  iReader
//
//  Created by chenyu on 13-10-1.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "BookShelfViewController.h"


@interface BookShelfViewController ()

@end

@implementation BookShelfViewController

- (id)initWithArray:(NSArray *)parmBooks
{
    self = [super init];
    if(self)
    {
        bookShelfView = [[BookShelfView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        bookShelfView.showsVerticalScrollIndicator = NO;
        books = [NSArray arrayWithArray:parmBooks];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kFVCNotifyModelChange object:nil];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if(self)
    {
        bookShelfView = [[BookShelfView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        bookShelfView.showsVerticalScrollIndicator = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveModelChangeNotification:) name:kFVCNotifyModelChange object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
     [self.view addSubview:bookShelfView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 32, 32);
    [btn setBackgroundImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnItem;
    [self.navigationItem setHidesBackButton:YES];
    [self reloadData:books];
}
#pragma mark - 接口函数

- (BOOL)setRightButtonPressedAction:(RightButtonPressed)action
{
    //rightButtonPressed = action;
    return YES;
}
- (BOOL)setBookKind:(NSString *)parmBookKind
{
    bookKind = [NSString stringWithString:parmBookKind];
    return YES;
}

#pragma mark - 右导航栏按钮的action

- (void)rightButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
    //rightButtonPressed(books,bookKind);
}

#pragma mark - 私有函数

- (void)reloadData :(NSArray*)parmBooks
{
    if(!parmBooks) return;
    NSArray *subViews = [bookShelfView subviews];
    for (UIView *view in subViews)
    {
        [view removeFromSuperview];
    }
    
    int row = 0;
    int column = 0;
    
    int totalCount = [parmBooks count] + 1;
    
    int height = 160;
    int width = 160;
    
    int perRowCount = 320 / width;
    int baseCenterX = 320 / (perRowCount*2);
    int baseCenterY = height / 2;
	for (int i = 1; i != totalCount; i++)
    {
        BookDisplayView *displayView = [[BookDisplayView alloc]init];
        Book *b = [books objectAtIndex:i-1];
        NSString *imagePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:bookKind] stringByAppendingPathComponent:[[b.images.small componentsSeparatedByString:@"/"] lastObject]];
        if(![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
        {
            [displayView setImageViewUrl:b.images.small];
            [displayView setLoadImageFinish:[self createLoadfinishBlock:[displayView getEGOImageView]]];
        }
        else
        {
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            [displayView setImageViewPic:image];
        }
        
        if(i%perRowCount != 0)
        {
            displayView.center = CGPointMake(baseCenterX+row*width, baseCenterY + column*height);
            row++;
        }
        else
        {
            displayView.center = CGPointMake(baseCenterX+row*width, baseCenterY + column*height);
            row = 0;
            column++;
        }
        [bookShelfView addSubview:displayView];
    }
    if((totalCount-1)%perRowCount != 0)
    {
        [bookShelfView setContentSize:CGSizeMake(0,((totalCount-1)/perRowCount+1)*height +60)];
    }else
    {
        [bookShelfView setContentSize:CGSizeMake(0,(totalCount-1)/perRowCount*height +60)];
    }
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

#pragma mark - 接收通知函数



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)recieveModelChangeNotification:(NSNotification*)notification
{
    NSDictionary *parmDic = [notification object];
    books = [NSArray arrayWithArray:[parmDic objectForKey:@"books"]];
    bookKind = [NSString stringWithString:[parmDic objectForKey:@"bookKind"]];
    [self reloadData:books];
    return YES;
}
#pragma mark - 接口方法

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFVCNotifyModelChange object:nil];
}
@end
