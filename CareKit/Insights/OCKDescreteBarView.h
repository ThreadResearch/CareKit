//
//  OCKDescreteBarView.h
//  CareKit
//
//  Created by Andy Yeung on 5/21/16.
//  Copyright © 2016 carekit.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCKDescreteBarData.h"

@interface OCKDescreteBarView : UIView

- (instancetype)initWithBar:(OCKDescreteBarData *)barData maxValue:(double)maxValue minValue:(double)minValue;

@property (nonatomic, strong) OCKDescreteBarData *barData;

- (void)animationWithDuration:(NSTimeInterval)duration;

@end
