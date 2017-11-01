//
//  HSBPageView.h
//  ScrollViewObjc
//
//  Created by hsb9kr on 2017. 10. 27..
//  Copyright © 2017년 hsb9kr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    previous,
    next
} HSBPageLoadMore;

@protocol HSBPageViewDataSource;
@protocol HSBPageViewDelegate;

@interface HSBPageView : UIView {
    @private
    UIScrollView *_scrollView;
    NSInteger _index;
    NSArray<UIView *> *_views;
    NSMutableDictionary<NSString*, Class> *_reuseViewClass;

    struct {
        unsigned int numberOfViewFlag   :1;
        unsigned int viewForIndexFlag   :1;
    }_dataSourceFlags;
    
    struct {
        unsigned int willDisplayViewFlag    :1;
        unsigned int frameForIndexFlag      :1;
        unsigned int didLoadViewFlag        :1;
        unsigned int loadMoreFlag           :1;
        unsigned int didSelectIndexFlag     :1;
        unsigned int didDraggingRateFlag    :1;
    }_delegateFlags;
    
    
}
@property (weak, nonatomic) IBOutlet id<HSBPageViewDataSource> dataSource;
@property (weak, nonatomic) IBOutlet id<HSBPageViewDelegate> delegate;
@property (strong, nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable BOOL bounces;


@property (nonatomic, readonly) NSInteger currentIndex;
@property (strong, nonatomic, readonly) UIView *currentView;

- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index;
- (void)scrollAnimateToIndex:(NSInteger)index duration:(NSTimeInterval)duration completion:(void(^)(void))completion;
- (void)registerReuseViewIdentifier:(NSString *)identifier class:(Class)aClass;
- (UIView *)dequeueReusableViewWithIdentifier:(NSString *)identifier forIndex:(NSInteger)index;
- (UIView *)viewForIndex:(NSInteger)index;
@end

@protocol HSBPageViewDataSource <NSObject>
- (NSInteger)numberOfViewInHSBPageView:(HSBPageView *)hsbPageView;
- (UIView *)hsbPageView:(HSBPageView *)hsbPageView viewForIndex:(NSInteger)index;
@end

@protocol HSBPageViewDelegate <NSObject>
@optional
- (void)hsbPageView:(HSBPageView *)hsbPageView willDisplayView:(UIView *)view forIndex:(NSInteger)index;
- (CGRect)hsbPageView:(HSBPageView *)hsbPageView frameForIndex:(NSInteger)index;
- (void)hsbPageView:(HSBPageView *)hsbPageView didLoadView:(UIView *)view forIndex:(NSInteger)index;
- (void)hsbPageView:(HSBPageView *)hsbPageView loadMore:(HSBPageLoadMore)loadMore;
- (void)hsbPageView:(HSBPageView *)hsbPageView didSelectIndex:(NSInteger)index;
- (void)hsbPageView:(HSBPageView *)hsbPageView didDraggingRate:(CGFloat)rate;
@end
