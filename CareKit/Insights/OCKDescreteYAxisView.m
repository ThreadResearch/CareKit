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
