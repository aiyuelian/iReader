//
//  BooksInfo.m
//  iReader
//
//  Created by chenyu on 13-10-3.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "BooksInfo.h"

@implementation BooksInfo

#pragma mark - 接口方法
- (BOOL)refresh :(ControllerCode)controllerCode
{
    code = controllerCode;
    [self requestData:bookKind :controllerCode];
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

#pragma mark - 覆写父类方法

- (BOOL)requestData:(NSString *)bookKindName :(ControllerCode)controllerCode
{
    code = controllerCode;
    bookKind = [[NSString alloc]initWithString:bookKindName];
    [super requestData:bookKindName :controllerCode];
    return YES;
}


#pragma mark - 请求数据返回的代理

- (void)parseFinish:(NSMutableArray *)books
{
    bookArray = [NSArray arrayWithArray:books];
    switch (code)
    {
        case flatViewControllerCode:
            [[NSNotificationCenter defaultCenter] postNotificationName:kflatViewRefreshNotifiCationName object:nil userInfo:nil];
            break;
        case bookShelfViewControllerCode:
            [[NSNotificationCenter defaultCenter] postNotificationName:kBookViewRefreshNotificationName object:nil userInfo:nil];
        default:
            break;
    }
    //[[NSNotificationCenter defaultCenter] postNotificationName:kModelRefreshNotifiCationName object:nil userInfo:nil];
}
@end
