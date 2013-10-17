//
//  AutoLayoutControl.m
//  iReader
//
//  Created by chenyu on 13-10-17.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "AutoLayoutControl.h"

@implementation AutoLayoutControl

+ (CGRect)getFrameAccordingIOSVersion:(CGRect)frame
{
    float version = [[[UIDevice currentDevice]systemVersion] floatValue];
    CGRect screenFrame = [[UIScreen mainScreen]bounds];
    if(screenFrame.size.height == 568)
    {
        frame.size.height += screenFrame.size.height - 480;
    }
    return frame;
}

+ (CGRect)autoModifyFrameOrgPointAccordingIOSVersion:(CGRect)frame
{
    //float version = [[[UIDevice currentDevice]systemVersion] floatValue];
    CGRect screenFrame = [[UIScreen mainScreen]bounds];
    if(screenFrame.size.height == 568)
    {
        frame.origin.y += screenFrame.size.height - 480;
        
    }
    return frame;
}
@end
