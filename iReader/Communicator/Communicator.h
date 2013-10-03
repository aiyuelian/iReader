//
//  Communicator.h
//  iReader
//
//  Created by chenyu on 13-9-29.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iReadercommunicatorDelegate.h"
#import "ASIHTTPRequest.h"

extern NSString *iReaderConnectErrorDomain;
enum
{
    iReaderConnectErrorCode,
};
@interface Communicator : NSObject<ASIHTTPRequestDelegate>
{
    @private
    ASIHTTPRequest *mRequest;
    NSMutableData *mReceive;
    NSURL *mUrl;
}
@property(nonatomic,weak) id<iReadercommunicatorDelegate> delegate;

- (void)setURL :(NSURL*)url;
- (BOOL)start :(BOOL)isCheckedLocal;
@end
