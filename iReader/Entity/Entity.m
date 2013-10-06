//
//  Entity.m
//  iReader
//
//  Created by chenyu on 13-10-3.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "Entity.h"

@implementation Entity

@synthesize communicator = _communicator;

#pragma mark - init

static NSString *strURL = @"https://api.douban.com/v2/book/search?tag=%@";
- (id)init
{
    self = [super init];
    if(self)
    {
       
    }
    return self;
}

#pragma mark - 接口方法

- (BOOL)connectServer:(NSString *)bookKindName :(ControllerCode)code
{
    if(!_communicator)
    {
        _communicator = [[Communicator alloc]init];
        _communicator.delegate = self;
    }
    [_communicator setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.douban.com/v2/book/search?tag=%@",bookKindName]]];
    [_communicator start:NO];
    return YES;
}

- (BOOL)checkLocalDataBeforeRequest:(NSString *)bookKindName
{
    if(!_communicator)
    {
        _communicator = [[Communicator alloc]init];
        _communicator.delegate = self;
    }
    [_communicator setURL:[NSURL URLWithString:[NSString stringWithFormat:strURL,bookKindName]]];
    [_communicator start:YES];
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
