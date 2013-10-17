//
//  AutoLayoutControl.h
//  iReader
//
//  Created by chenyu on 13-10-17.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoLayoutControl : NSObject

+ (CGRect)getFrameAccordingIOSVersion :(CGRect)frame;
+ (CGRect)autoModifyFrameOrgPointAccordingIOSVersion:(CGRect)frame;
@end
