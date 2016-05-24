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


#import <UIKit/UIKit.h>
#import "OCKDefines.h"


NS_ASSUME_NONNULL_BEGIN

/**
 The `OCKDescreteSeries` class represents the data set in `OCKDescreteChart`.
 */
OCK_CLASS_AVAILABLE
@interface OCKDescreteSeries : NSObject <NSSecureCoding, NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 Returns an initialzed step series using the specified values.

 @param highTitle       The title for the high values of the step series.
 @param lowTitle        The title for the low values of the step series.
 @param values          An array of an array of values. Each array within the array should only contain 2 or no values, where the first value is greater than the second value. Or if there are no values, then it counts as if there are no data for that particular index.
 @param highTintColor   The step series tint color for high values.
 @param lowTintColor    The step series tint color for low values.

 @return An initialzed bar series object.
 */
- (instancetype)initWithHighTitle:(NSString *)highTitle
                         lowTitle:(NSString *)lowTitle
                           values:(NSArray<NSArray< NSNumber *> *> *)values
                    highTintColor:(nullable UIColor *)highTintColor
                     lowTintColor:(nullable UIColor *)lowTintColor;

/**
 The high value title of the step series.
 */
@property (nonatomic, copy, readonly) NSString *highTitle;

/**
 The low value title of the step series.
 */
@property (nonatomic, copy, readonly) NSString *lowTitle;

/**
 The high values of the steps.
 */
@property (nonatomic, copy, readonly) NSArray<NSArray<NSNumber *> *> *values;

/**
 The tint color of the high values.

 If the value is not specified, the app's tint color is used.
 */
@property (nonatomic, readonly, nullable) UIColor *highTintColor;

/**
 The tint color of the low values.

 If the value is not specified, the app's tint color is used.
 */
@property (nonatomic, readonly, nullable) UIColor *lowTintColor;

/**
 Returns the greatest value in values.

 @return The greatest value in values.
 */
- (NSNumber *)getHighestValue;

/**
 Returns the lowest value in values.

 @return The lowest value in values.
 */
- (NSNumber *)getLowestValue;

@end

NS_ASSUME_NONNULL_END
