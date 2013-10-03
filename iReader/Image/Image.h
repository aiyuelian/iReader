//
//  Image.h
//  iReader
//
//  Created by chenyu on 13-9-28.
//  Copyright (c) 2013年 zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Image : NSObject<NSCoding>

@property(nonatomic,strong) NSString *large;//large,small,medium
@property(nonatomic,strong) NSString *small;
@property(nonatomic,strong) NSString *medium;
@end
