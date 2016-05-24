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


#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class OCKDescreteChartView;

/**
 The data source provides the information for a OCKDescreteChartView object to draw a descrete chart.
 */
@protocol OCKDescreteChartViewDataSource <NSObject>

@required
/**
 Number of data series in this chart.

 @param     chartView   An object representing the chart view requesting this information.
 @return    Number of data series.
 */
- (NSInteger)numberOfDataSeriesInChartView:(OCKDescreteChartView *)chartView;

/**
 Numeric high value for descrete bar at category index in a data series.

 @param     chartView           An object representing the chart view requesting this information.
 @param     index               Index of a data series.
 @return    Numeric high value for descrete bar.
 */
- (nullable NSNumber *)chartView:(OCKDescreteChartView *)chartView highValueForDataSeriesAtIndex:(NSUInteger)index;

/**
 Numeric low value for descrete bar at category index in a data series.

 @param     chartView           An object representing the chart view requesting this information.
 @param     index               Index of a data series.
 @return    Numeric low value for descrete bar.
 */
- (nullable NSNumber *)chartView:(OCKDescreteChartView *)chartView lowValueForDataSeriesAtIndex:(NSUInteger)index;

/**
 Title for index at x-axis.
 It will be shown in x-axis index label.

 @param     chartView           An object representing the chart view requesting this information.
 @param     index               Index of the x-axis.
 @return    Title of a x-axis index.
 */
- (NSString *)chartView:(OCKDescreteChartView *)chartView titleForXAxisAtIndex:(NSUInteger)index;

/**
 The high tint color of a specified descrete bar series.

 @param     chartView           An object representing the chart view requesting this information.
 @return    High tint color of a specified descrete bar series.
 */
- (UIColor *)highTintColorForChartView:(OCKDescreteChartView *)chartView;

/**
 The low tint color of a specified descrete bar series.

 @param     chartView           An object representing the chart view requesting this information.
 @return    Low tint color of a specified descrete bar series.
 */
- (UIColor *)lowTintColorForChartView:(OCKDescreteChartView *)chartView;

/**
 Maximum high value of descrete bar.
 It will be shown in the descrete bar y-axis.

 @param     chartView           An object representing the chart view requesting this information.
 @return    Maximum high value of descrete bar.
 */
- (NSNumber *)maximumHighValueOfChartView:(OCKDescreteChartView *)chartView;

/**
 Minimum low value of descrete bar.
 It will be shown in the descrete bar y-axis.

 @param     chartView           An object representing the chart view requesting this information.
 @return    Minimum low value of descrete bar.
 */
- (NSNumber *)minimumLowValueOfChartView:(OCKDescreteChartView *)chartView;

/**
 Name of the high values for the descrete bar series.
 It will be shown in legend view.

 @param     chartView           An object representing the chart view requesting this information.
 @return    Name of the high values.
 */
- (NSString *)nameForHighValuesForChartView:(OCKDescreteChartView *)chartView;

/**
 Name of the low values for the descrete bar series.
 It will be shown in legend view.

 @param     chartView           An object representing the chart view requesting this information.
 @return    Name of the low values.
 */
- (NSString *)nameForLowValuesForChartView:(OCKDescreteChartView *)chartView;

@optional

/**
 Subtitle for a x-axis title.
 It will be shown as a x-axis index subtitle label.

 @param     chartView           An object representing the chart view requesting this information.
 @param     index               Index of the x-axis.
 @return    Subtitle of the x-axis.
 */
- (nullable NSString *)chartView:(OCKDescreteChartView *)chartView subtitleForXAXISAtIndex:(NSUInteger)index;

@end


/**
 Class `OCKGroupedBarChartView` defines a view which can draw a grouped bar chart.
 */
@interface OCKDescreteChartView : UIView

/*
 All the information for charting are provided by OCKDescreteChartViewDataSource.
 */
@property (nonatomic, weak, nullable) id<OCKDescreteChartViewDataSource> dataSource;


/*
 Show animation of all the descrete bars and line graph.

 @param duration Animation duration in seconds.
 */
- (void)animateWithDuration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
