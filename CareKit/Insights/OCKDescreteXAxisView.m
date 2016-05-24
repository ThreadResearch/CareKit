//
//  OCKDescreteXAxisView.m
//  CareKit
//
//  Created by Andy Yeung on 5/24/16.
//  Copyright © 2016 carekit.org. All rights reserved.
//

#import "OCKDescreteXAxisView.h"

static const CGFloat XAxisLineWidthPercentage = 1.2;
static const CGFloat XAxisPadding = 5;
static const CGFloat XAxisTitleFontSize = 14;
static const CGFloat XAxisSubtitleFontSize = 12;

@implementation OCKDescreteXAxisView {
    NSArray<NSString *> *_titles;
    NSArray<NSString *> *_subtitles;

    NSMutableArray<NSLayoutConstraint *> *_constraints;
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles subtitles:(NSArray<NSString *> *)subtitles{
    NSAssert(titles.count == subtitles.count, @"Number of titles must equal the number of subtitles.");

    self = [super init];
    if (self) {
        _titles = titles;
        _subtitles = subtitles;
        _constraints = [NSMutableArray new];
        [self prepareView];
    }
    return self;
}

- (void)prepareView {
    bool hasMidPoint = (_titles.count % 2 != 0);
    int midPoint = ceil(_titles.count / 2);

    UIView *lineView = [UIView new];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:lineView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:XAxisPadding]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:lineView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:lineView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:1.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:lineView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:XAxisLineWidthPercentage
                                                          constant:1.0]];

    for (int i = 0; i < _titles.count; i++) {
        UIView *axisView = [UIView new];
        UILabel *title = [UILabel new];
        UILabel *subtitle = [UILabel new];

        axisView.translatesAutoresizingMaskIntoConstraints = NO;
        title.translatesAutoresizingMaskIntoConstraints = NO;
        subtitle.translatesAutoresizingMaskIntoConstraints = NO;

        title.text = _titles[i];
        title.textColor = [UIColor darkTextColor];
        title.font = [UIFont systemFontOfSize:XAxisTitleFontSize];
        title.textAlignment = NSTextAlignmentCenter;
        subtitle.text = _subtitles[i];
        subtitle.textColor = [UIColor lightGrayColor];
        subtitle.font = [UIFont systemFontOfSize:XAxisSubtitleFontSize];

        [title sizeToFit];
        [subtitle sizeToFit];
        [axisView addSubview:title];
        [axisView addSubview:subtitle];

        NSTextAlignment alignment = NSTextAlignmentRight;
        if (hasMidPoint && midPoint == i) {
            alignment = NSTextAlignmentCenter;
        } else if (i <= midPoint) {
            alignment = NSTextAlignmentLeft;
        }

        [self setUpAxisConstraintsWithTitle:title subtitle:subtitle toView:axisView wihtAlignment:alignment];

        [_constraints addObject:[NSLayoutConstraint constraintWithItem:axisView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:lineView
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0.0]];

        [_constraints addObject:[NSLayoutConstraint constraintWithItem:axisView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0.0]];

        if (i == 0) {
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:axisView
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeading
                                                                multiplier:1.0
                                                                  constant:0.0]];
        } else {
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:axisView
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.subviews.lastObject
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:0.0]];

            [_constraints addObject:[NSLayoutConstraint constraintWithItem:axisView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.subviews.lastObject
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0.0]];
        }

        if (i == (_titles.count - 1)) {
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:axisView
                                                                 attribute:NSLayoutAttributeTrailing
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:0.0]];
        }

        [self addSubview:axisView];
    }

    [NSLayoutConstraint activateConstraints:_constraints];
}

- (void)setUpAxisConstraintsWithTitle:(UILabel *)title subtitle:(UILabel *)subtitle toView:(UIView *)view wihtAlignment:(NSTextAlignment)alignment{
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
                                                            toItem:subtitle
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:title
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:title
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:subtitle
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:title
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:subtitle
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                          constant:0.0]];

    if (alignment == NSTextAlignmentLeft) {
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:subtitle
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:title
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:XAxisPadding]];
    } else if (alignment == NSTextAlignmentRight) {
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:subtitle
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:title
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:-XAxisPadding]];
    } else {
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:subtitle
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:title
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
    }
}

@end
