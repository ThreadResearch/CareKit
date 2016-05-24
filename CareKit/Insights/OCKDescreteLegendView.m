//
//  OCKDescreteLegendView.m
//  CareKit
//
//  Created by Andy Yeung on 5/24/16.
//  Copyright © 2016 carekit.org. All rights reserved.
//

#import "OCKDescreteLegendView.h"

static const CGFloat LegendTitleFontSize = 12;
static const CGFloat LegendSquareSize = 15;
static const CGFloat LegendSpacePadding = 5;

@implementation OCKDescreteLegendView {
    NSArray<NSString *> *_titles;
    NSArray<UIColor *> *_colors;

    NSMutableArray<NSLayoutConstraint *> *_constraints;
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles colors:(NSArray<UIColor *> *)colors {
    self = [super init];
    if (self) {
        _titles = titles;
        _colors = colors;
        _constraints = [NSMutableArray new];
        [self prepareView];
    }
    return self;
}

- (void)prepareView {
    UIView *containerView = [UIView new];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:containerView];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:containerView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:containerView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];

    for (int i = 0; i < _titles.count; i++) {
        UIView *view = [UIView new];
        UIView *legendSquare = [UIView new];
        UILabel *title  = [UILabel new];

        view.translatesAutoresizingMaskIntoConstraints = NO;
        legendSquare.translatesAutoresizingMaskIntoConstraints = NO;
        title.translatesAutoresizingMaskIntoConstraints = NO;

        [view addSubview:legendSquare];
        [view addSubview:title];

        legendSquare.backgroundColor = _colors[i];
        title.text = _titles[i];
        title.textColor = [UIColor darkTextColor];
        title.font = [UIFont systemFontOfSize:LegendTitleFontSize];
        title.textAlignment = NSTextAlignmentLeft;

        [self setUpConstraintsForTitle:title square:legendSquare toView:view];

        [_constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:containerView
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.0
                                                              constant:0.0]];

        [_constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:containerView
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:0.0]];

        if (i == 0) {
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:containerView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0.0]];
        } else {
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:containerView.subviews.lastObject
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:LegendSpacePadding]];

            [_constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:containerView.subviews.lastObject
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:1.0
                                                                  constant:0.0]];
        }

        if (i == (_titles.count - 1)) {
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:containerView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0.0]];
        }

        [containerView addSubview:view];
    }

    [NSLayoutConstraint activateConstraints:_constraints];
}

- (void)setUpConstraintsForTitle:(UILabel *)title square:(UIView *)square toView:(UIView *)view {
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:square
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:LegendSquareSize]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:square
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:LegendSquareSize]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:square
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:square
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:title
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:square
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:LegendSpacePadding]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:title
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:title
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:title
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];
}

@end
