//
//  Tag.m
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "Tag.h"

@implementation Tag
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.title = [aDecoder decodeObjectForKey:@"title-Tag"];
        self.name = [aDecoder decodeObjectForKey:@"name-Tag"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title-Tag"];
    [aCoder encodeObject:self.name forKey:@"name-Tag"];
}
@end
