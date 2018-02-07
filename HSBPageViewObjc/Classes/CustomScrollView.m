//
//  CustomScrollView.m
//  ScrollViewObjc
//
//  Created by 홍상보 on 2018. 2. 7..
//  Copyright © 2018년 hsb9kr. All rights reserved.
//

#import "CustomScrollView.h"

@implementation CustomScrollView

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
	[super setDelegate:delegate];
	
	_customDelegate = (id<CustomScrollViewDelegate>)delegate;
	
	_delegateFlags.selectedFlag = [_customDelegate respondsToSelector:@selector(scrollView:selectedIndex:)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	NSUInteger index = self.contentOffset.x / self.bounds.size.width;
	
	if (_delegateFlags.selectedFlag) [_customDelegate scrollView:self selectedIndex:index];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	
}

@end
