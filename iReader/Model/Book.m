//
//  Book.m
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import "Book.h"

@implementation Book

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.translator forKey:@"translator"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.rating forKey:@"rating"];
    [aCoder encodeObject:self.images forKey:@"images"];
    [aCoder encodeObject:self.tags forKey:@"tags"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.alt forKey:@"alt"];
    [aCoder encodeObject:self.publisher forKey:@"publisher"];
    [aCoder encodeObject:self.catalog forKey:@"catalog"];
    [aCoder encodeObject:self.binding forKey:@"binding"];
    [aCoder encodeObject:self.origin_title forKey:@"origin_title"];
    [aCoder encodeObject:self.bookId forKey:@"bookId"];
    [aCoder encodeObject:self.pages forKey:@"pages"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.isbn13 forKey:@"isbn13"];
    [aCoder encodeObject:self.alt_title forKey:@"alt_title"];
    [aCoder encodeObject:self.author_intro forKey:@"author_intro"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.summary forKey:@"summary"];
    [aCoder encodeObject:self.pubdate forKey:@"pubdate"];
    [aCoder encodeObject:self.subtitle forKey:@"subtitle"];
    [aCoder encodeObject:self.isbn10 forKey:@"isbn10"];
    [aCoder encodeObject:self.image forKey:@"image"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.translator = [aDecoder decodeObjectForKey:@"translator"];
        self.author = [aDecoder decodeObjectForKey:@"author"];
        self.rating = [aDecoder decodeObjectForKey:@"rating"];
        self.images = [aDecoder decodeObjectForKey:@"images"];
        self.tags = [aDecoder decodeObjectForKey:@"tags"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.alt = [aDecoder decodeObjectForKey:@"alt"];
        self.publisher = [aDecoder decodeObjectForKey:@"publisher"];
        self.catalog = [aDecoder decodeObjectForKey:@"catalog"];
        self.binding = [aDecoder decodeObjectForKey:@"binding"];
        self.origin_title = [aDecoder decodeObjectForKey:@"origin_title"];
        self.bookId = [aDecoder decodeObjectForKey:@"bookId"];
        self.pages = [aDecoder decodeObjectForKey:@"pages"];
        self.price = [aDecoder decodeObjectForKey:@"price"];
        self.isbn13 = [aDecoder decodeObjectForKey:@"isbn13"];
        self.alt_title = [aDecoder decodeObjectForKey:@"alt_title"];
        self.author_intro = [aDecoder decodeObjectForKey:@"author_intro"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.summary = [aDecoder decodeObjectForKey:@"summary"];
        self.pubdate = [aDecoder decodeObjectForKey:@"pubdate"];
        self.subtitle = [aDecoder decodeObjectForKey:@"subtitle"];
        self.isbn10 = [aDecoder decodeObjectForKey:@"isbn10"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
    }
    return self;
    
}
@end
