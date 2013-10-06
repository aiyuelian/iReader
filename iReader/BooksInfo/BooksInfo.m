//
//  BooksInfo.m
//  iReader
//
//  Created by chenyu on 13-10-3.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "BooksInfo.h"

@implementation BooksInfo

@synthesize communicator = _communicator;

#pragma mark - 接口方法
- (BOOL)refresh //:(ControllerCode)controllerCode
{
   // code = controllerCode;
    [self request:bookKind :self.currentController];
    return YES;
}

- (BOOL)loadData
{
    return YES;
}

- (NSArray*)getBooksArray
{
    return [NSArray arrayWithArray:bookArray];
}

- (BOOL)setBookdArray:(NSArray *)parmBookArray
{
    bookArray = [NSArray arrayWithArray:parmBookArray];
    return YES;
}

- (NSString*)getBookKind
{
    return [NSString stringWithString:bookKind];
}

- (BOOL)setBookKind:(NSString *)parmBookKind
{
    bookKind = [NSString stringWithString:parmBookKind];
    return YES;
}


- (BOOL)checkLocalDataBeforeRequest:(NSString *)bookKindName
{
    if(!_communicator)
    {
        _communicator = [[Communicator alloc]init];
        _communicator.delegate = self;
    }
    [_communicator setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.douban.com/v2/book/search?tag=%@",bookKindName]]];
    [_communicator start:YES];
    return YES;
}

- (void)test:(NSString *)bookKindName :(NSString *)controllerName
{
    
}

- (void)createcommunicator :(NSString*)bookKindName
{
    bookKind = [NSString stringWithString:bookKindName];
    if(!_communicator)
    {
        _communicator = [[Communicator alloc]init];
        _communicator.delegate = self;
        
    }
    [_communicator setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.douban.com/v2/book/search?tag=%@",bookKindName]]];
}
- (BOOL)request:(NSString *)bookKindName :(NSString*)controllerName
{
    self.currentController = controllerName;
    [_communicator start :NO];
    return YES;
}


#pragma mark - 请求数据返回的代理

- (void)parseFinish:(NSMutableArray *)books
{
    bookArray = [NSArray arrayWithArray:books];
    
    if([self.currentController isEqualToString:kFlatViewControllerName])
        [[NSNotificationCenter defaultCenter] postNotificationName:kflatViewRefreshNotifiCationName object:nil userInfo:nil];
    if([self.currentController isEqualToString:kBookShelfViewControllerName])
        [[NSNotificationCenter defaultCenter] postNotificationName:kBookViewRefreshNotificationName object:nil userInfo:nil];

}

- (void)parseCount:(int)count
{
    
}

@end
