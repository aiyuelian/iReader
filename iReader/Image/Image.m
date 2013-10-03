//
//  Image.m
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "Image.h"

@implementation Image

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.large = [aDecoder decodeObjectForKey:@"large-Image"];
        self.medium = [aDecoder decodeObjectForKey:@"medium-Image"];
        self.small = [aDecoder decodeObjectForKey:@"small-Image"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.large forKey:@"large-Image"];
    [aCoder encodeObject:self.medium forKey:@"medium-Image"];
    [aCoder encodeObject:self.small forKey:@"small-Image"];
}
@end
