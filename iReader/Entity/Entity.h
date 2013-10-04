//
//  Entity.h
//  iReader
//
//  Created by chenyu on 13-10-3.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Communicator.h"
#import "ASIHTTPRequest.h"
#import "iReadercommunicatorDelegate.h"

@interface Entity : NSObject<iReadercommunicatorDelegate>
{
    @private
    Communicator *communicator;
}

- (BOOL)requestData :(NSString*)bookKindName;
- (BOOL)checkLocalDataBeforeRequest :(NSString*)bookKindName;

@end
