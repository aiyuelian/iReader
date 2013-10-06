//
//  Communicator.m
//  iReader
//
//  Created by chenyu on 13-9-29.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "Communicator.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "Book.h"
#import "OCMapper.h"

@implementation Communicator

@synthesize request = _request;
#pragma mark - 接口方法
- (id)init
{
    self = [super init];
    if(self)
         mReceive = [[NSMutableData alloc]init];
    return self;
}

- (void)setURL:(NSURL *)url
{
    mUrl = url;
    _request = [[ASIHTTPRequest alloc]initWithURL:mUrl];
    [_request setDelegate:self];
}

- (BOOL)checkLocalCache
{
    
    NSString *strURL = [mUrl absoluteString];
    NSArray *tempArray = [strURL componentsSeparatedByString:@"="];
    NSString *dirAndFileName = [tempArray lastObject];
    NSString *filePath = [self getDocFirstDirFilePath:dirAndFileName :[dirAndFileName stringByAppendingString:@".plist"]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSMutableArray *books = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        [self.delegate parseFinish:books];
        return YES;
    }
    return NO;
}
- (BOOL)start :(BOOL)isCheckedLocal
{
    if(isCheckedLocal)
    {
        if([self checkLocalCache]) return NO;
    }
    [_request startAsynchronous];
    return YES;
}

#pragma mark - ASIHTTPRequestDElegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    mReceive = [[NSMutableData alloc]initWithData:[_request responseData]];
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSDictionary *josnDic = [parser objectWithData:mReceive];
    NSArray *booksArray = [josnDic objectForKey:@"books"];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.inCodeMappingProvider mapFromDictionaryKey:@"id" toPropertyKey:@"bookId" forClass:[Book class]];
    NSMutableArray *books = [[NSMutableArray alloc]initWithCapacity:[booksArray count]];
    [self.delegate parseCount:[booksArray count]];
    for (int i = 0; i != [booksArray count]; ++i)
    {
        Book *book = [Book objectFromDictionary:[booksArray objectAtIndex:i]];
        [books addObject:book];
    }
    NSString *strURL = [mUrl absoluteString];
    NSArray *tempArray = [strURL componentsSeparatedByString:@"="];
    NSString *dirAndFileName =[tempArray lastObject];
    NSError *error = nil;
    NSString *path = [self createDir:dirAndFileName :error];
    NSString *plistName = [dirAndFileName stringByAppendingString:@".plist"];
    path = [path stringByAppendingPathComponent:plistName];
    [NSKeyedArchiver archiveRootObject:books toFile:path];
    [mReceive setLength:0];
    [self.delegate parseFinish:books];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *reportError = [NSError errorWithDomain:@"testdomain" code:iReaderConnectErrorCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[_request error],NSUnderlyingErrorKey, nil]];
    [self.delegate connectedError:reportError];
}

#pragma mark - 私有方法
- (NSString*)getDocFirstDirFilePath :(NSString*)dirName :(NSString*)fileName
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if(!dirName)
       documentPath = [documentPath stringByAppendingPathComponent:dirName];
    documentPath = [documentPath stringByAppendingPathComponent:fileName];
    return documentPath;
}
- (NSString*)createDir :(NSString*)dirName :(NSError*)error
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentPath = [documentPath stringByAppendingPathComponent:dirName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:documentPath])
         [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:&error];
    return documentPath;
}
@end
//NSString *iReaderConnectErrorDomain = @"iReaderConnectErrorDomain";
