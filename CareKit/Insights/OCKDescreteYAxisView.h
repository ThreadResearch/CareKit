//
//  OCKDescreteYAxisView.h
//  CareKit
//
//  Created by Andy Yeung on 5/24/16.
//  Copyright © 2016 carekit.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCKDescreteYAxisView : UIView

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles colors:(NSArray<UIColor *> *)colors isLeftSide:(BOOL)side;

@end
