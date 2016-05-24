//
//  OCKDescreteBarData.h
//  CareKit
//
//  Created by Andy Yeung on 5/21/16.
//  Copyright © 2016 carekit.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCKDescreteBarData : NSObject

@property (nonatomic, copy) NSNumber *highValue;
@property (nonatomic, copy) NSNumber *lowValue;
@property (nonatomic, copy) UIColor *highTintColor;
@property (nonatomic, copy) UIColor *lowTintColor;

@end
