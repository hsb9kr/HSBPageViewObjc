//
//  ImageView.m
//  ScrollViewObjc
//
//  Created by hsb9kr on 2017. 10. 30..
//  Copyright © 2017년 hsb9kr. All rights reserved.
//

#import "ImageView.h"

@implementation ImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%@ init", self.class);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"%@ init", self.class);
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self.class);
}
@end
