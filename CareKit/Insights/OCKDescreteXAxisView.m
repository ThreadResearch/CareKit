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
                                                          constant:0.0]];

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
