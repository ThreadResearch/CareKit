//
//  OCKDescreteYAxisView.m
//  CareKit
//
//  Created by Andy Yeung on 5/24/16.
//  Copyright © 2016 carekit.org. All rights reserved.
//

#import "OCKDescreteYAxisView.h"

static const CGFloat YAxisFontSize = 14;

@implementation OCKDescreteYAxisView {
    NSArray<NSString *> *_titles;
    NSArray<UIColor *> *_colors;

    BOOL _isLeftSide;
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles colors:(NSArray<UIColor *> *)colors isLeftSide:(BOOL)side {
    NSAssert(titles.count == colors.count, @"Number of titles must equal the number of colors.");

    self = [super init];
    if (self) {
        _titles = titles;
        _colors = colors;
        _isLeftSide = side;
        [self prepareView];
    }
    return self;
}

- (void)prepareView {
    NSMutableArray *constraints = [NSMutableArray new];

    for (int i = 0; i < _titles.count; i++) {
        UILabel *title = [UILabel new];
        title.translatesAutoresizingMaskIntoConstraints = NO;
        title.text = _titles[i];
        title.textColor = _colors[i];
        title.textAlignment = _isLeftSide ? NSTextAlignmentLeft : NSTextAlignmentRight;
        title.font = [UIFont systemFontOfSize:YAxisFontSize];
        [title sizeToFit];

        [constraints addObject:[NSLayoutConstraint constraintWithItem:title
                                                            attribute:NSLayoutAttributeLeading
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeading
                                                           multiplier:1.0
                                                             constant:0.0]];

        [constraints addObject:[NSLayoutConstraint constraintWithItem:title
                                                            attribute:NSLayoutAttributeTrailing
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTrailing
                                                           multiplier:1.0
                                                             constant:0.0]];

        if (i == 0) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:title
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:-(YAxisFontSize / 2)]];
        } else if (_titles.count > 2) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:title
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.subviews.lastObject
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:0.0]];
        } else {

        }

        if (i == (_titles.count - 1)) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:title
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:(YAxisFontSize / 2)]];
        }

        [self addSubview:title];
    }

    [NSLayoutConstraint activateConstraints:constraints];
}

@end
