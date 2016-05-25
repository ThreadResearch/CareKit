/*
 Copyright (c) 2016, ThreadResearch. All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.

 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


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
