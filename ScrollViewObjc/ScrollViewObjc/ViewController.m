//
//  ViewController.m
//  ScrollViewObjc
//
//  Created by hsb9kr on 2017. 10. 27..
//  Copyright © 2017년 hsb9kr. All rights reserved.
//

#import "ViewController.h"
#import "HSBPageView.h"
#import "ImageView.h"
@interface ViewController (HSBPageView) <HSBPageViewDataSource, HSBPageViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [[UIView alloc] init];
    UIView *view2 = [[UIView alloc] init];
    UIView *view3 = [[UIView alloc] init];
    _views = @[view1, view2, view3];
    view1.backgroundColor = UIColor.blueColor;
    view2.backgroundColor = UIColor.redColor;
    view3.backgroundColor = UIColor.yellowColor;
//    [_pageView registerReuseViewIdentifier:@"imageView" class:ImageView.class];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)reaload:(id)sender {
    [_pageView reloadData];
}

@end

@implementation ViewController (HSBPageView)

- (NSInteger)numberOfViewInHSBPageView:(HSBPageView *)hsbPageView {
    return _views.count;
}

- (UIView *)hsbPageView:(HSBPageView *)hsbPageView viewForIndex:(NSInteger)index {
//    ImageView *imageView = (ImageView *)[hsbPageView dequeueReusableViewWithIdentifier:@"imageView" forIndex:index];
//    return imageView;
    return _views[index];
}
@end
