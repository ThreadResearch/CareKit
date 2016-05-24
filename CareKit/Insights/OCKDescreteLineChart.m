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


#import "OCKDescreteLineChart.h"
#import "OCKHelpers.h"
#import "OCKDescreteChartView.h"


@interface OCKDescreteLineChart() <OCKDescreteChartViewDataSource>

@end


@implementation OCKDescreteLineChart

+ (instancetype)new {
    OCKThrowMethodUnavailableException();
    return nil;
}

- (instancetype)init {
    OCKThrowMethodUnavailableException();
    return nil;
}


- (instancetype)initWithTitle:(NSString *)title
                         text:(NSString *)text
                    tintColor:(UIColor *)tintColor
                   axisTitles:(NSArray<NSString *> *)axisTitles
                axisSubtitles:(NSArray<NSString *> *)axisSubtitles
               descreteSeries:(OCKDescreteSeries *)descreteSeries
       minimumScaleRangeValue:(NSNumber *)minimumScaleRangeValue
       maximumScaleRangeValue:(NSNumber *)maximumScaleRangeValue {
    NSAssert((axisTitles.count == descreteSeries.values.count), @"The number of axisTitles must equal to the number of values in descreteSeries.");

    self = [super init];
    if (self) {
        self.title = [title copy];
        self.text = [text copy];
        self.tintColor = tintColor;
        _axisTitles = OCKArrayCopyObjects(axisTitles);
        _axisSubtitles = OCKArrayCopyObjects(axisSubtitles);
        _descreteSeries = [descreteSeries copy];
        _minimumScaleRangeValue = minimumScaleRangeValue;
        _maximumScaleRangeValue = maximumScaleRangeValue;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                         text:(NSString *)text
                    tintColor:(UIColor *)tintColor
                   axisTitles:(NSArray<NSString *> *)axisTitles
                axisSubtitles:(NSArray<NSString *> *)axisSubtitles
               descreteSeries:(OCKDescreteSeries *)descreteSeries {
    return [[OCKDescreteLineChart alloc] initWithTitle:title
                                                  text:text
                                             tintColor:tintColor
                                            axisTitles:axisTitles
                                         axisSubtitles:axisSubtitles
                                        descreteSeries:descreteSeries
                                minimumScaleRangeValue:nil
                                maximumScaleRangeValue:nil];
}

- (BOOL)isEqual:(id)object {
    BOOL isParentSame = [super isEqual:object];

    __typeof(self) castObject = object;
    return (isParentSame &&
            OCKEqualObjects(self.axisTitles, castObject.axisTitles) &&
            OCKEqualObjects(self.axisSubtitles, castObject.axisSubtitles) &&
            OCKEqualObjects(self.descreteSeries, castObject.descreteSeries) &&
            OCKEqualObjects(self.minimumScaleRangeValue, castObject.minimumScaleRangeValue) &&
            OCKEqualObjects(self.maximumScaleRangeValue, castObject.maximumScaleRangeValue));
}


#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        OCK_DECODE_OBJ_ARRAY(aDecoder, axisTitles, NSArray);
        OCK_DECODE_OBJ_ARRAY(aDecoder, axisSubtitles, NSArray);
        OCK_DECODE_OBJ_CLASS(aDecoder, descreteSeries, OCKDescreteSeries);
        OCK_DECODE_OBJ_CLASS(aDecoder, minimumScaleRangeValue, NSNumber);
        OCK_DECODE_OBJ_CLASS(aDecoder, maximumScaleRangeValue, NSNumber);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    OCK_ENCODE_OBJ(aCoder, axisTitles);
    OCK_ENCODE_OBJ(aCoder, axisSubtitles);
    OCK_ENCODE_OBJ(aCoder, descreteSeries);
    OCK_ENCODE_OBJ(aCoder, minimumScaleRangeValue);
    OCK_ENCODE_OBJ(aCoder, maximumScaleRangeValue);
}


#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    OCKDescreteLineChart *chart = [super copyWithZone:zone];
    chart->_axisTitles = OCKArrayCopyObjects(self.axisTitles);
    chart->_axisSubtitles = OCKArrayCopyObjects(self.axisSubtitles);
    chart->_descreteSeries = self.descreteSeries;
    chart->_minimumScaleRangeValue = self.minimumScaleRangeValue;
    chart->_maximumScaleRangeValue = self.maximumScaleRangeValue;
    return chart;
}


#pragma mark - Helpers

- (BOOL)isCategoryIndex:(NSUInteger)index outofBoundsInArray:(NSArray *)array {
    return (index > array.count - 1);
}


#pragma mark - OCKBarChart

- (UIView *)chartView {
    OCKDescreteChartView *barChartView = [OCKDescreteChartView new];
    barChartView.dataSource = self;
    return barChartView;
}

+ (void)animateView:(UIView *)view withDuration:(NSTimeInterval)duration {
    NSAssert([view isKindOfClass:[OCKDescreteChartView class]], @"View must be of type OCKDescreteChartView");
    OCKDescreteChartView *chartView = (OCKDescreteChartView *)view;
    [chartView animateWithDuration:duration];
}


#pragma mark - OCKDescreteChartViewDataSource

- (NSInteger)numberOfDataSeriesInChartView:(OCKDescreteChartView *)chartView {
    return self.descreteSeries.values.count;
}

- (nullable NSNumber *)chartView:(OCKDescreteChartView *)chartView highValueForDataSeriesAtIndex:(NSUInteger)index {
    return self.descreteSeries.values[index].firstObject;
}

- (nullable NSNumber *)chartView:(OCKDescreteChartView *)chartView lowValueForDataSeriesAtIndex:(NSUInteger)index {
    return self.descreteSeries.values[index].lastObject;
}

- (NSString *)chartView:(OCKDescreteChartView *)chartView titleForXAxisAtIndex:(NSUInteger)index {
    return self.axisTitles[index];
}

- (nullable NSString *)chartView:(OCKDescreteChartView *)chartView subtitleForXAXISAtIndex:(NSUInteger)index {
    return self.axisSubtitles[index];
}

- (UIColor *)highTintColorForChartView:(OCKDescreteChartView *)chartView {
    return self.descreteSeries.highTintColor ?: [self tintColor];
}

- (UIColor *)lowTintColorForChartView:(OCKDescreteChartView *)chartView {
    return self.descreteSeries.lowTintColor ?: [self tintColor];
}

- (NSNumber *)maximumHighValueOfChartView:(OCKDescreteChartView *)chartView {
    return self.maximumScaleRangeValue ?: [self.descreteSeries getHighestValue];
}

- (NSNumber *)minimumLowValueOfChartView:(OCKDescreteChartView *)chartView {
    return self.minimumScaleRangeValue ?: [self.descreteSeries getLowestValue];
}

- (NSString *)nameForHighValuesForChartView:(OCKDescreteChartView *)chartView {
    return self.descreteSeries.highTitle;
}

- (NSString *)nameForLowValuesForChartView:(OCKDescreteChartView *)chartView {
    return self.descreteSeries.lowTitle;
}

@end
