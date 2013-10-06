//
//  Entity.m
//  iReader
//
//  Created by chenyu on 13-10-3.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "Entity.h"

@implementation Entity
#pragma mark - init

static NSString *strURL = @"https://api.douban.com/v2/book/search?tag=%@";
- (id)init
{
    self = [super init];
    if(self)
    {
        communicator = [[Communicator alloc]init];
        communicator.delegate = self;
    }
    return self;
}

#pragma mark - 接口方法

- (BOOL)requestData:(NSString *)bookKindName :(ControllerCode)code
{
    [communicator setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.douban.com/v2/book/search?tag=%@",bookKindName]]];
    [communicator start:NO];
    return YES;
}

- (BOOL)checkLocalDataBeforeRequest:(NSString *)bookKindName
{
    [communicator setURL:[NSURL URLWithString:[NSString stringWithFormat:strURL,bookKindName]]];
    [communicator start:YES];
    return YES;
}

#pragma mark - 请求数据返回委托

- (void)parseFinish:(NSMutableArray *)books
{
    
}
- (void)parseCount:(int)count
{
    
}
- (void)parseOne:(Book *)book
{
    
}
- (void)connectedError :(NSError*)error
{
    
}
@end
