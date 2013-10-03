//
//  iReaderManager.m
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "iReaderManager.h"
#import "AppDelegate.h"

@implementation iReaderManager

//@synthesize mainViewController;
#pragma mark - kvo

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"refash"])
    {
        lastSenment = 0;
        [self startRequestData :@"GET":[NSString stringWithFormat:@"https://api.douban.com/v2/book/search?tag=%@",currentBookKind] :NO];
    }
        
    if([keyPath isEqualToString:@"loadMore"])
        [self pullUpLoadMore];
}

#pragma mark - 接口方法
-(id)init
{
    self = [super init];
    if(self)
    {
        lastSenment = 0;
        mRecieve = [[NSMutableData alloc]init];
        commmunicator = [[Communicator alloc]init];
        commmunicator.delegate = self;
    }
    return self;
}
- (BOOL)startRequestData :(NSString*)methond :(NSString*)url :(BOOL)isCheckLocal
{
    currentBookKind = [[url componentsSeparatedByString:@"="] lastObject];
    [commmunicator setURL:[NSURL URLWithString:url]];
    [commmunicator start:isCheckLocal];
    return YES;
}
- (BOOL)setDisplayView:(DisplayViewCode)code
{
    switch (code)
    {
        case FlatViewCode:
            if(!flatViewController) flatViewController = [[FlatViewController alloc]init];
            [flatViewController addObserver:self forKeyPath:@"refash" options:NSKeyValueObservingOptionNew context:nil];
            [flatViewController addObserver:self forKeyPath:@"loadMore" options:NSKeyValueObservingOptionNew context:nil];
            [flatViewController setRightButtonPressedAction:[self createBSVRightBtnPressedBlock]];
            self.currentDisplayController = flatViewController;
            break;
        case BookViewCode:
            if(!bookShelfViewController) bookShelfViewController = [[BookShelfViewController alloc]init];
            self.currentDisplayController = bookShelfViewController;
            break;
            
        default:
            break;
    }
    return YES;
}

#pragma mark - iReaderDelegate
- (void)parseFinish:(NSMutableArray *)parmbooks
{
    books = [NSArray arrayWithArray:parmbooks];
    NSInteger sunLenght = [self getBooksSegment:books];
    NSArray *subbooks = [books subarrayWithRange:NSMakeRange(lastSenment, sunLenght)];
    lastSenment += sunLenght;
   
    NSDictionary *parmDic = [NSDictionary dictionaryWithObjectsAndKeys:sunLenght==0?nil:[NSArray arrayWithArray:subbooks],@"books",currentBookKind,@"bookKind", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFVCNotifyModelChange object:parmDic userInfo:nil];
}
- (void)connectedError:(NSError *)error
{
    
}
- (void)parseOne:(Book *)book
{
    
}
- (void)parseCount:(int)count
{
}

- (void)dealloc
{
    [flatViewController removeObserver:self forKeyPath:@"refash" context:nil];
    [flatViewController removeObserver:self forKeyPath:@"loadMore" context:nil];
}

#pragma mark - 私有方法

- (RightButtonPressed)createBSVRightBtnPressedBlock
{
    RightButtonPressed blk = ^(NSArray *parmBooks,NSString *parmBookKind){
        
        bookShelfViewController = [[BookShelfViewController alloc]initWithArray:parmBooks];
        [bookShelfViewController setBookKind:parmBookKind];
        self.currentDisplayController = bookShelfViewController;
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        [delegate.navigationController pushViewController:bookShelfViewController animated:YES];
        
    };
    return blk;
}

- (NSInteger)getBooksSegment :(NSArray*)parmBooks
{
    NSInteger bookCount = parmBooks.count - lastSenment;
    if(bookCount <= kSegmentCount)
    {
        //lastSenment += bookCount;
        return bookCount;
    }
    else
    {
        //lastSenment += kSegmentCount;
        return kSegmentCount;
    }
        
}

- (void)pullUpLoadMore
{
    NSInteger sunLenght = [self getBooksSegment:books];
   // if(sunLenght == 0)return;
    NSArray *subbooks = [books subarrayWithRange:NSMakeRange(lastSenment, sunLenght)];
    lastSenment += sunLenght;
    NSDictionary *parmDic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSArray alloc]initWithArray:subbooks],@"books",currentBookKind,@"bookKind", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFVCPullUpLoadMoew object:parmDic userInfo:nil];
    
}
@end

