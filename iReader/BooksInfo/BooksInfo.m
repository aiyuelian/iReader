//
//  BooksInfo.m
//  iReader
//
//  Created by chenyu on 13-10-3.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "BooksInfo.h"

@implementation BooksInfo

#pragma mark - 借口方法
- (BOOL)refresh
{
    [self requestData:bookKind];
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

- (BOOL)requestData:(NSString *)bookKindName
{
    bookKind = [[NSString alloc]initWithString:bookKindName];
    [super requestData:bookKindName];
    return YES;
}


#pragma mark - 请求数据返回的代理

- (void)parseFinish:(NSMutableArray *)books
{
    //bookKind = [NSString stringWithString:<#(NSString *)#>]
    bookArray = [NSArray arrayWithArray:books];
   // NSDictionary *parmDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:books],@"books",[NSString stringWithString:bookKind],kBookKindName, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kModelRefreshNotifiCationName object:nil userInfo:nil];
}
@end
