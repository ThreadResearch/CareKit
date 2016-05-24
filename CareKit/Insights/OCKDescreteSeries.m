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


#import "OCKDescreteSeries.h"
#import "OCKHelpers.h"


@implementation OCKDescreteSeries

+ (instancetype)new {
    OCKThrowMethodUnavailableException();
    return nil;
}

- (instancetype)initWithHighTitle:(NSString *)highTitle
                         lowTitle:(NSString *)lowTitle
                           values:(NSArray<NSArray<NSNumber *> *> *)values
                    highTintColor:(UIColor *)highTintColor
                     lowTintColor:(UIColor *)lowTintColor {
    NSAssert((values.count > 0), @"The number of values must be greater than 0.");

    for (int i = 0; i < values.count; i++) {
        NSAssert((values[i].count == 2 || values[i].count == 0), @"Each array within the values array should only have 2 or no values.");
        NSAssert((values[i][0] > values[i][1]), @"The first value of the sub-value array should be greater than the second value.");
    }

    self = [super init];
    if (self) {
        _highTitle = [highTitle copy];
        _lowTitle = [lowTitle copy];
        _values = OCKArrayCopyObjects(values);
        _highTintColor = highTintColor;
        _lowTintColor = lowTintColor;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([self class] != [object class]) {
        return NO;
    }

    __typeof(self) castObject = object;
    return (OCKEqualObjects(self.highTitle, castObject.highTitle) &&
            OCKEqualObjects(self.lowTitle, castObject.lowTitle) &&
            OCKEqualObjects(self.values, castObject.values) &&
            OCKEqualObjects(self.highTintColor, castObject.highTintColor) &&
            OCKEqualObjects(self.lowTintColor, castObject.lowTintColor));
}

- (NSNumber *)getHighestValue {
    double max = DBL_MIN;
    for (int i = 0; i < _values.count; i++) {
        if (_values[i].count > 0 && _values[i][0].doubleValue > max) {
            max = _values[i][0].doubleValue;
        }
    }

    return [NSNumber numberWithDouble:max];
}

- (NSNumber *)getLowestValue {
    double min = DBL_MAX;
    for (int i = 0; i < _values.count; i++) {
        if (_values[i].count > 0 && _values[i][1].doubleValue < min) {
            min = _values[i][1].doubleValue;
        }
    }

    return [NSNumber numberWithDouble:min];
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        OCK_DECODE_OBJ_CLASS(aDecoder, highTitle, NSString);
        OCK_DECODE_OBJ_CLASS(aDecoder, lowTitle, NSString);
        OCK_DECODE_OBJ_ARRAY(aDecoder, values, NSArray);
        OCK_DECODE_OBJ_CLASS(aDecoder, highTintColor, UIColor);
        OCK_DECODE_OBJ_CLASS(aDecoder, lowTintColor, UIColor);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    OCK_ENCODE_OBJ(aCoder, highTitle);
    OCK_ENCODE_OBJ(aCoder, lowTitle);
    OCK_ENCODE_OBJ(aCoder, values);
    OCK_ENCODE_OBJ(aCoder, highTintColor);
    OCK_ENCODE_OBJ(aCoder, lowTintColor);
}


#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    OCKDescreteSeries *series = [[[self class] allocWithZone:zone] init];
    series->_highTitle = [_highTitle copy];
    series->_lowTitle = [_lowTitle copy];
    series->_values = OCKArrayCopyObjects(_values);
    series->_highTintColor = _highTintColor;
    series->_lowTintColor = _lowTintColor;
    return series;
}

@end
