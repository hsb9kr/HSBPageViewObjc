//
//  HSBPageView.m
//  ScrollViewObjc
//
//  Created by hsb9kr on 2017. 10. 27..
//  Copyright © 2017년 hsb9kr. All rights reserved.
//

#import "HSBPageView.h"
#import "CustomScrollView.h"

@interface HSBPageView(UIScrollViewDelegate) <UIScrollViewDelegate>
@end

@interface HSBPageView(CustomScrollViewDelegate) <CustomScrollViewDelegate>
@end

@implementation HSBPageView
@dynamic currentIndex;
@dynamic currentView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadData];
}

- (NSInteger)currentIndex {
    return _index;
}

- (UIView *)currentView {
    return _views[_index];
}

- (void)setDataSource:(id<HSBPageViewDataSource>)dataSource {
    _dataSource = dataSource;
    _dataSourceFlags.numberOfViewFlag = [_dataSource respondsToSelector:@selector(numberOfViewInHSBPageView:)];
    _dataSourceFlags.viewForIndexFlag = [_dataSource respondsToSelector:@selector(hsbPageView:viewForIndex:)];
}

- (void)setDelegate:(id<HSBPageViewDelegate>)delegate {
    _delegate = delegate;
    _delegateFlags.willDisplayViewFlag = [_delegate respondsToSelector:@selector(hsbPageView:willDisplayView:forIndex:)];
    _delegateFlags.frameForIndexFlag = [_delegate respondsToSelector:@selector(hsbPageView:frameForIndex:)];
    _delegateFlags.didLoadViewFlag = [_delegate respondsToSelector:@selector(hsbPageView:didLoadView:forIndex:)];
    _delegateFlags.loadMoreFlag = [_delegate respondsToSelector:@selector(hsbPageView:loadMore:)];
    _delegateFlags.didSelectIndexFlag = [_delegate respondsToSelector:@selector(hsbPageView:didSelectIndex:)];
    _delegateFlags.didDraggingRateFlag = [_delegate respondsToSelector:@selector(hsbPageView:didDraggingRate:)];
}

#pragma mark - Inspectable

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [[UIColor alloc] initWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setBounces:(BOOL)bounces {
    _scrollView.bounces = bounces;
}

- (BOOL)bounces {
    return _scrollView.bounces;
}

#pragma mark - Public

- (void)registerReuseViewIdentifier:(NSString *)identifier class:(Class)aClass {
    _reuseViewClass[identifier] = aClass;
}

- (UIView *)dequeueReusableViewWithIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    Class aClass = _reuseViewClass[identifier];
    if (!aClass) return nil;
    if (_views.count > index) {
        UIView *view = _views[index];
        if ([view isKindOfClass:aClass]) {
            return view;
        }
    }
    return [[aClass alloc] init];
}

- (void)reloadData {
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = self.bounds.size;
    
    if (!_dataSourceFlags.numberOfViewFlag) return;
    
    NSInteger number = [_dataSource numberOfViewInHSBPageView:self];
    CGSize contentSize = _scrollView.contentSize;
    contentSize.width = self.bounds.size.width * number;
    _scrollView.contentSize = contentSize;
    
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    NSMutableArray<UIView *> *tempViews = [[NSMutableArray alloc] init];
    
    for (NSInteger index = 0; index < number; index++) {
        if (!_dataSourceFlags.viewForIndexFlag) continue;
		
		UIView *contentView = [[UIView alloc] init];
		contentView.backgroundColor = UIColor.clearColor;
		
        UIView *view = [_dataSource hsbPageView:self viewForIndex:index];
        [contentView addSubview:view];
		
        view.layer.borderColor = _cBorderColor.CGColor;
        view.layer.borderWidth = _cBorderWidth;
        view.layer.cornerRadius = _cCornerRadius;
        
        CGRect expectedFrame = CGRectMake(self.bounds.size.width * index, 0, self.bounds.size.width, self.bounds.size.height);
		contentView.frame = expectedFrame;
		
		expectedFrame.origin = CGPointZero;
		view.frame = expectedFrame;
		
		if (_delegateFlags.frameForIndexFlag) {
            view.frame =  [_delegate hsbPageView:self frameForIndex:index];
        }
		
        if (_delegateFlags.didLoadViewFlag) [_delegate hsbPageView:self didLoadView:view forIndex:index];
        
        [tempViews addObject:contentView];
        [_scrollView addSubview:contentView];
    }
    
    _views = tempViews;
    
    [self sendSubviewToBack:_scrollView];
}

- (void)scrollToIndex:(NSInteger)index {
    CGPoint point = _scrollView.contentOffset;
    point.x = self.bounds.size.width * index;
    _scrollView.contentOffset = point;
}

- (void)scrollAnimateToIndex:(NSInteger)index duration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    [UIView animateWithDuration:duration animations:^{
        [self scrollToIndex:index];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (UIView *)viewForIndex:(NSInteger)index {
    if (_views.count > index) {
        return _views[index];
    }
    
    return nil;
}

#pragma mark - Private

- (void)initialize {
    _index = 0;
	
    _reuseViewClass = [[NSMutableDictionary alloc] init];
    
    _scrollView = [[CustomScrollView alloc] init];
    _scrollView.delegate = self;
	
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
}
@end

@implementation HSBPageView(UIScrollViewDelegate)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.bounds.size.width;
    NSInteger currentIndex = floor((scrollView.contentOffset.x - width / 3) / width) + 1;
    CGFloat draggingRate = scrollView.contentOffset.x / scrollView.contentSize.width;
    
    if (_delegateFlags.didDraggingRateFlag) [_delegate hsbPageView:self didDraggingRate:draggingRate];
    
    if (_index != currentIndex && currentIndex < _views.count) {
        _index = currentIndex;
        if (_delegateFlags.willDisplayViewFlag) [_delegate hsbPageView:self willDisplayView:_views[_index].subviews.firstObject forIndex:_index];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < 0) {
        if (_delegateFlags.loadMoreFlag) [_delegate hsbPageView:self loadMore:previous];
    } else if (scrollView.contentOffset.x + scrollView.bounds.size.width > scrollView.contentSize.width) {
        if (_delegateFlags.loadMoreFlag) [_delegate hsbPageView:self loadMore:next];
    }
}
@end

@implementation HSBPageView(CustomScrollViewDelegate)

- (void)scrollView:(CustomScrollView *)scrollView selectedIndex:(NSInteger)index {
	if (_delegateFlags.didSelectIndexFlag) [_delegate hsbPageView:self didSelectIndex:index];
}
@end

