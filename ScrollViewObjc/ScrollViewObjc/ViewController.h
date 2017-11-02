//
//  ViewController.h
//  ScrollViewObjc
//
//  Created by hsb9kr on 2017. 10. 27..
//  Copyright © 2017년 hsb9kr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSBPageView;
@interface ViewController : UIViewController <UITableViewDelegate> {
    NSArray<UIView *> *_views;
}
@property (weak, nonatomic) IBOutlet HSBPageView *pageView;


@end

