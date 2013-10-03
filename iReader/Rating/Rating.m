//
//  Rating.m
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "Rating.h"

@implementation Rating

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.min = [aDecoder decodeObjectForKey:@"min-Rating"];
        self.average = [aDecoder decodeObjectForKey:@"average-Rating"];
        self.max = [aDecoder decodeObjectForKey:@"max-Rating"];
        self.numRaters = [aDecoder decodeObjectForKey:@"numRaters-Rating"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.max forKey:@"max-Rating"];
    [aCoder encodeObject:self.average forKey:@"average-Rating"];
    [aCoder encodeObject:self.min forKey:@"min-Rating"];
    [aCoder encodeObject:self.numRaters forKey:@"numRaters-Rating"];
}
@end
