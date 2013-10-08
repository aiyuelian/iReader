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
- (id)init
{
    self = [super init];
    if(self)
    {
        _communicator = [[Communicator alloc]init];
        _communicator.delegate = self;
    }
    return self;
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
- (BOOL)refresh
{
    [_communicator setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.douban.com/v2/book/search?tag=%@",bookKind]]];;
    [_communicator start :NO];
    return YES;
}

- (BOOL)request:(NSString*)controllerName
{
    self.currentController = controllerName;
    [_communicator setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.douban.com/v2/book/search?tag=%@",bookKind]]];;
    [_communicator start :YES];
    return YES;
}

#pragma mark - 私有方法

- (NSString*)createDir :(NSString*)dirName :(NSError*)error
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentPath = [documentPath stringByAppendingPathComponent:dirName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:documentPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:&error];
    return documentPath;
}

#pragma mark - 请求数据返回的代理

- (void)parseFinish:(NSMutableArray *)books
{
    NSError *error = nil;
    NSString *path = [self createDir:bookKind :error];
    NSString *plistName = [bookKind stringByAppendingString:@".plist"];
    path = [path stringByAppendingPathComponent:plistName];
    [NSKeyedArchiver archiveRootObject:books toFile:path];
    
    bookArray = [NSArray arrayWithArray:books];
    
    if([self.currentController isEqualToString:kFlatViewControllerName])
        [[NSNotificationCenter defaultCenter]postNotificationName:kflatViewRefreshNotifiCationName object:nil];
    if([self.currentController isEqualToString:kBookShelfViewControllerName])
        [[NSNotificationCenter defaultCenter] postNotificationName:kBookViewRefreshNotificationName object:nil userInfo:nil];
}

- (void)parseCount:(int)count
{
    
}

@end
