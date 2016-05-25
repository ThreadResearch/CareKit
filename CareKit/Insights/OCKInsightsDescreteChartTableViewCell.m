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


#import "OCKInsightsDescreteChartTableViewCell.h"
#import "OCKHelpers.h"
#import "OCKLabel.h"


static const CGFloat Padding = 10.0;
static const CGFloat ChartHeightPercentage = 0.8;


@implementation OCKInsightsDescreteChartTableViewCell {
    OCKInsightsDropDownView *_dropDownView;
    OCKLabel *_textLabel;
    UIView *_chartView;
    UIView *_space1View;
    UIView *_space2View;
    NSMutableArray *_constraints;
}

- (void)setChart:(OCKChart *)chart {
    _chart = chart;
    self.tintColor = _chart.tintColor;
    [self prepareView];
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    [self prepareView];
}

- (void)prepareView {
    [super prepareView];

    if (!_titles || !_chart) {
        return;
    }

    if (!_dropDownView) {
        _dropDownView = [[OCKInsightsDropDownView alloc] initWithTitles:self.titles];
        [self addSubview:_dropDownView];
    }

    if (!_textLabel) {
        _textLabel = [OCKLabel new];
        _textLabel.textStyle = UIFontTextStyleSubheadline;
        _textLabel.textColor = OCKSystemGrayColor();
        _textLabel.numberOfLines = 2;
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_textLabel];
    }

    if (!_space1View) {
        _space1View = [UIView new];
        [self addSubview:_space1View];
    }

    if (!_space2View) {
        _space2View = [UIView new];
        [self addSubview:_space2View];
    }

    [_chartView removeFromSuperview];
    _chartView = self.chart.chartView;
    [self addSubview:_chartView];

    [self updateView];
    [self setUpConstraints];
}

- (void)updateView {
    _textLabel.text = self.chart.text;
}

- (void)setUpConstraints {
    [NSLayoutConstraint deactivateConstraints:_constraints];

    _constraints = [NSMutableArray new];

    _dropDownView.translatesAutoresizingMaskIntoConstraints = NO;
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _chartView.translatesAutoresizingMaskIntoConstraints = NO;
    _space1View.translatesAutoresizingMaskIntoConstraints = NO;
    _space2View.translatesAutoresizingMaskIntoConstraints = NO;

    [_constraints addObjectsFromArray:@[
                                        [NSLayoutConstraint constraintWithItem:_space1View
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0.0],
                                        [NSLayoutConstraint constraintWithItem:_space1View
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0
                                                                      constant:0.0],
                                        [NSLayoutConstraint constraintWithItem:_space1View
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1.0
                                                                      constant:0.0],
                                        [NSLayoutConstraint constraintWithItem:_space2View
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_textLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:0.0],
                                        [NSLayoutConstraint constraintWithItem:_space2View
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0
                                                                      constant:0.0],
                                        [NSLayoutConstraint constraintWithItem:_space2View
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1.0
                                                                      constant:0.0],
                                        [NSLayoutConstraint constraintWithItem:_dropDownView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_space1View
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:0.0],
                                        [NSLayoutConstraint constraintWithItem:_dropDownView
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0
                                                                      constant:Padding],
                                        [NSLayoutConstraint constraintWithItem:_textLabel
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1.0
                                                                      constant:0.0],
                                        [NSLayoutConstraint constraintWithItem:_textLabel
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0
                                                                      constant:Padding],
                                        [NSLayoutConstraint constraintWithItem:_textLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_dropDownView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:-Padding],
                                        [NSLayoutConstraint constraintWithItem:_chartView
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0
                                                                      constant:0.0],
                                        [NSLayoutConstraint constraintWithItem:_chartView
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTrailing
                                                                    multiplier:1.0
                                                                      constant:0.0],
                                        [NSLayoutConstraint constraintWithItem:_chartView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_space2View
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:0.0],
                                        [NSLayoutConstraint constraintWithItem:_chartView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:0.0],
                                        [NSLayoutConstraint constraintWithItem:_chartView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:ChartHeightPercentage
                                                                      constant:0.0],
                                        [NSLayoutConstraint constraintWithItem:_space1View
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_space2View
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:1.0
                                                                      constant:0.0]
                                        ]];

    [NSLayoutConstraint activateConstraints:_constraints];
}

- (void)animateWithDuration:(NSTimeInterval)duration {
    if (_chartView) {
        [[_chart class] animateView:_chartView withDuration:duration];
    }
}

@end
