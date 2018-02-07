//
//  CustomScrollView.h
//  ScrollViewObjc
//
//  Created by 홍상보 on 2018. 2. 7..
//  Copyright © 2018년 hsb9kr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomScrollViewDelegate;

@interface CustomScrollView : UIScrollView {
	struct {
		unsigned int selectedFlag    :1;
	}_delegateFlags;
	
	id<CustomScrollViewDelegate> _customDelegate;
}

@end

@protocol CustomScrollViewDelegate <NSObject>

@optional
- (void)scrollView:(CustomScrollView *)scrollView selectedIndex:(NSInteger)index;

@end
