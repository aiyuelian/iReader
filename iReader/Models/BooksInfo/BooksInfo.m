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
- (id)init
{
    self = [super init];
    if(self)
    {
        self.communicator = [[Communicator alloc]init];
        self.communicator.delegate = self;
        self.bookKind = nil;
        self.bookArray = nil;
    }
    return self;
}

- (BOOL)refresh :(NSString*)controllerName
{
    self.currentController = controllerName;
    [self.communicator setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.douban.com/v2/book/search?tag=%@",self.bookKind]]];;
    [self.communicator start :NO];
    return YES;
}

- (BOOL)request:(NSString*)controllerName
{
    if(self.bookKind == nil) return NO;
    self.currentController = controllerName;
    [self.communicator setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.douban.com/v2/book/search?tag=%@",self.bookKind]]];;
    [self.communicator start :YES];
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
    NSString *path = [self createDir:self.bookKind :error];
    NSString *plistName = [self.bookKind stringByAppendingString:@".plist"];
    path = [path stringByAppendingPathComponent:plistName];
    [NSKeyedArchiver archiveRootObject:books toFile:path];
    
    self.bookArray = [NSArray arrayWithArray:books];
    
    if([self.currentController isEqualToString:kFlatViewControllerName])
        [[NSNotificationCenter defaultCenter]postNotificationName:kflatViewRefreshNotifiCationName object:nil];
    if([self.currentController isEqualToString:kBookShelfViewControllerName])
        [[NSNotificationCenter defaultCenter] postNotificationName:kBookViewRefreshNotificationName object:nil userInfo:nil];
}
- (void)connectedError:(NSError *)error
{
    if([self.currentController isEqualToString:kFlatViewControllerName]){
        [[NSNotificationCenter defaultCenter]postNotificationName:kFlatViewControllerError object:error];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:kBookShelfControllerError object:error];
    }
}

- (void)parseCount:(int)count
{
    
}

@end
