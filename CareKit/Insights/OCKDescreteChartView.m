/*
 Copyright (c) 2016, Apple Inc. All rights reserved.

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


#import "OCKDescreteChartView.h"
#import "OCKDescreteBarView.h"
#import "OCKDescreteLegendView.h"
#import "OCKDescreteXAxisView.h"
#import "OCKDescreteYAxisView.h"
#import "OCKLabel.h"
#import "OCKHelpers.h"

static const CGFloat DescreteChratTopPadding = 10.0;
static const CGFloat GraphBoxHeightPercentage = 0.55;
static const CGFloat GraphBoxWidthPercentage = 0.7;
static const CGFloat YAxisHeightPercentage = 0.55;
static const CGFloat YAxisWidthPercentage = 0.15; // Two Y-Axis, so both will be 0.3
static const CGFloat XAxisHeightPercentage = 0.15;
static const CGFloat XAxisWidthPercentage = 0.7;

@interface OCKDescreteBarChartBarType : NSObject

@property (nonatomic, copy) NSString *highTitle;
@property (nonatomic, copy) NSString *lowTitle;
@property (nonatomic, strong) UIColor *highTintColor;
@property (nonatomic, strong) UIColor *lowTintColor;
@property (nonatomic, strong) NSNumber *maxValueRange;
@property (nonatomic, strong) NSNumber *minValueRange;

@end


@implementation OCKDescreteBarChartBarType

@end


@interface OCKXAxisType : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy, nullable) NSString *subTitle;

@end


@implementation OCKXAxisType

@end

@implementation OCKDescreteChartView {
    NSMutableArray<OCKXAxisType *> *_xAxisTypes;
    NSMutableArray<OCKDescreteBarData *> *_descreteBarDatas;
    OCKDescreteBarChartBarType *_descreteBarType;

    NSMutableArray<NSLayoutConstraint *> *_constraints;

    UIView *_graphBox;
    UIView *_leftYAxisBox;
    UIView *_rightYAxisBox;
    UIView *_xAxisBox;
    UIView *_legendBox;

    BOOL _shouldInvalidateLegendViewIntrinsicContentSize;
    CGFloat _descreteBarWidth;
    CGFloat _descreteBarHeight;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)setDataSource:(id<OCKDescreteChartViewDataSource>)dataSource {
    _dataSource = dataSource;

    if (_dataSource) {
        NSUInteger numberOfDataSeries = [_dataSource numberOfDataSeriesInChartView:self];

        _descreteBarType = [OCKDescreteBarChartBarType new];
        _descreteBarType.highTitle = [_dataSource nameForHighValuesForChartView:self];
        _descreteBarType.lowTitle = [_dataSource nameForLowValuesForChartView:self];
        _descreteBarType.highTintColor = [_dataSource highTintColorForChartView:self];
        _descreteBarType.lowTintColor = [_dataSource lowTintColorForChartView:self];
        _descreteBarType.maxValueRange = [_dataSource maximumHighValueOfChartView:self];
        _descreteBarType.minValueRange = [_dataSource minimumLowValueOfChartView:self];

        CGRect viewFrame = [self frame];
        _descreteBarWidth = numberOfDataSeries / viewFrame.size.width;
        _descreteBarHeight = viewFrame.size.height;

        _descreteBarDatas = [NSMutableArray new];
        _xAxisTypes = [NSMutableArray new];
        for (int index = 0; index < numberOfDataSeries; index++) {
            OCKDescreteBarData *barData = [OCKDescreteBarData new];
            barData.highValue = [_dataSource chartView:self highValueForDataSeriesAtIndex:index];
            barData.lowValue = [_dataSource chartView:self lowValueForDataSeriesAtIndex:index];
            barData.highTintColor = _descreteBarType.highTintColor;
            barData.lowTintColor = _descreteBarType.lowTintColor;
            [_descreteBarDatas addObject:barData];

            OCKXAxisType *axisType = [OCKXAxisType new];
            axisType.title = [_dataSource chartView:self titleForXAxisAtIndex:index];
            axisType.subTitle = [_dataSource chartView:self subtitleForXAXISAtIndex:index];
            [_xAxisTypes addObject:axisType];
        }
    }
    [self recreateViews];
}

- (void)animateWithDuration:(NSTimeInterval)duration {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (OCKDescreteBarView *descreteBarView in _graphBox.subviews) {
            [descreteBarView animationWithDuration:duration];
        }
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_shouldInvalidateLegendViewIntrinsicContentSize) {
        _shouldInvalidateLegendViewIntrinsicContentSize = NO;
    }
}

- (void)recreateViews {
    [NSLayoutConstraint deactivateConstraints:_constraints];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }

    _constraints = [NSMutableArray new];

    _graphBox = [UIView new];
    _leftYAxisBox = [UIView new];
    _rightYAxisBox = [UIView new];
    _xAxisBox = [UIView new];
    _legendBox = [UIView new];

    _graphBox.translatesAutoresizingMaskIntoConstraints = NO;
    _leftYAxisBox.translatesAutoresizingMaskIntoConstraints = NO;
    _rightYAxisBox.translatesAutoresizingMaskIntoConstraints = NO;
    _xAxisBox.translatesAutoresizingMaskIntoConstraints = NO;
    _legendBox.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:_graphBox];
    [self addSubview:_leftYAxisBox];
    [self addSubview:_rightYAxisBox];
    [self addSubview:_xAxisBox];
    [self addSubview:_legendBox];

    // Graph Box Constraints
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_graphBox
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:DescreteChratTopPadding]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_graphBox
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_xAxisBox
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_graphBox
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_leftYAxisBox
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_graphBox
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_rightYAxisBox
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_graphBox
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:GraphBoxWidthPercentage
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_graphBox
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:GraphBoxHeightPercentage
                                                          constant:0.0]];

    // Left Y-Axis Constraints
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_leftYAxisBox
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:DescreteChratTopPadding]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_leftYAxisBox
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_xAxisBox
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_leftYAxisBox
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_leftYAxisBox
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_graphBox
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_leftYAxisBox
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:YAxisWidthPercentage
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_leftYAxisBox
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:YAxisHeightPercentage
                                                          constant:0.0]];

    // Right Y-Axis Constraints
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_rightYAxisBox
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:DescreteChratTopPadding]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_rightYAxisBox
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_xAxisBox
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_rightYAxisBox
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_graphBox
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_rightYAxisBox
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_rightYAxisBox
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:YAxisWidthPercentage
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_rightYAxisBox
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:YAxisHeightPercentage
                                                          constant:0.0]];

    // X-Axis Constraints
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_xAxisBox
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_graphBox
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_xAxisBox
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_legendBox
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_xAxisBox
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:XAxisWidthPercentage
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_xAxisBox
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_xAxisBox
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:XAxisHeightPercentage
                                                          constant:0.0]];

    // Legend Constraints
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_legendBox
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_xAxisBox
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_legendBox
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_legendBox
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_legendBox
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:0.0]];


    [self setUpGraphBox];
    [self setUpRightYAxis];
    [self setUpLeftYAxis];
    [self setUpXAxis];
    [self setUpLegend];

    [NSLayoutConstraint activateConstraints:_constraints];
}

- (void)setUpGraphBox {
    for (int i = 0; i < _descreteBarDatas.count; i++) {
        OCKDescreteBarData *barData = _descreteBarDatas[i];
        OCKDescreteBarView *descreteBarView = [[OCKDescreteBarView alloc] initWithBar:barData
                                                                             maxValue:_descreteBarType.maxValueRange.doubleValue
                                                                             minValue:_descreteBarType.minValueRange.doubleValue];
        descreteBarView.translatesAutoresizingMaskIntoConstraints = NO;

        [_constraints addObject:[NSLayoutConstraint constraintWithItem:descreteBarView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_graphBox
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0.0]];

        [_constraints addObject:[NSLayoutConstraint constraintWithItem:descreteBarView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_graphBox
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0.0]];

        if (i == 0) {
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:descreteBarView
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_graphBox
                                                                 attribute:NSLayoutAttributeLeading
                                                                multiplier:1.0
                                                                  constant:0.0]];
        } else {
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:descreteBarView
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_graphBox.subviews.lastObject
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:0.0]];

            [_constraints addObject:[NSLayoutConstraint constraintWithItem:_graphBox.subviews.lastObject
                                                                 attribute:NSLayoutAttributeTrailing
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:descreteBarView
                                                                 attribute:NSLayoutAttributeLeading
                                                                multiplier:1.0
                                                                  constant:0.0]];

            [_constraints addObject:[NSLayoutConstraint constraintWithItem:descreteBarView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_graphBox.subviews.lastObject
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0.0]];
        }

        if (i == (_descreteBarDatas.count - 1)) {
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:descreteBarView
                                                                 attribute:NSLayoutAttributeTrailing
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_graphBox
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:0.0]];
        }
        
        [_graphBox addSubview:descreteBarView];
    }
}

- (void)setUpRightYAxis {
    NSString *max = [NSString stringWithFormat:@"%@-", _descreteBarType.maxValueRange];
    NSString *min = [NSString stringWithFormat:@"%@-", _descreteBarType.minValueRange];

    NSArray *titles = @[max, min];
    NSArray *colors = @[_descreteBarType.highTintColor, _descreteBarType.lowTintColor];
    OCKDescreteYAxisView *yAxis = [[OCKDescreteYAxisView alloc] initWithTitles:titles colors:colors isLeftSide:NO];
    yAxis.translatesAutoresizingMaskIntoConstraints = NO;

    [_rightYAxisBox addSubview:yAxis];
    [self setUpBasicConstraintWithView:yAxis toView:_rightYAxisBox];
}

- (void)setUpLeftYAxis {
    
}

- (void)setUpXAxis {
    NSMutableArray<NSString *> *titles = [NSMutableArray new];
    NSMutableArray<NSString *> *subtitles = [NSMutableArray new];

    for (int i = 0; i < _xAxisTypes.count; i++) {
        [titles addObject:_xAxisTypes[i].title];
        [subtitles addObject:_xAxisTypes[i].subTitle ?: @""];
    }

    OCKDescreteXAxisView *xAxis = [[OCKDescreteXAxisView alloc] initWithTitles:titles subtitles:subtitles];
    xAxis.translatesAutoresizingMaskIntoConstraints = NO;

    [_xAxisBox addSubview:xAxis];
    [self setUpBasicConstraintWithView:xAxis toView:_xAxisBox];
}

- (void)setUpLegend {
    NSArray *titles = @[_descreteBarType.highTitle, _descreteBarType.lowTitle];
    NSArray *colors = @[_descreteBarType.highTintColor, _descreteBarType.lowTintColor];

    OCKDescreteLegendView *legendView = [[OCKDescreteLegendView alloc] initWithTitles:titles colors:colors];
    legendView.translatesAutoresizingMaskIntoConstraints = NO;

    [_legendBox addSubview:legendView];
    [self setUpBasicConstraintWithView:legendView toView:_legendBox];
}

- (void)setUpBasicConstraintWithView:(UIView *)view1 toView:(UIView *)view2 {
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:view1
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view2
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:view1
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view2
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:view1
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view2
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:view1
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view2
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:0.0]];
}

@end
