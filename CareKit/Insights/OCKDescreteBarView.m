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


#import "OCKDescreteBarView.h"

static const CGFloat BarWidthPercentage = 0.35;
static const CGFloat IndicatorHeightPercentage = 0.05;

@implementation OCKDescreteBarView {
    double _maxValue;
    double _minValue;
    UIView *_highBarView;
    UIView *_highIndicatorView;
    UIView *_lowBarView;
    UIView *_lowIndicatorView;
    CAShapeLayer *_highBarLayer;
    CAShapeLayer *_lowBarLayer;
}

- (instancetype)initWithBar:(OCKDescreteBarData *)barData maxValue:(double)maxValue minValue:(double)minValue {
    self = [super init];
    if (self) {
        _maxValue = maxValue;
        _minValue = minValue;
        _barData = barData;
        [self prepareView];
    }
    return self;
}

- (double)normalizedValueForValue:(double)value {
    return (value - _minValue) / (_maxValue - _minValue);
}

- (void)animationWithDuration:(NSTimeInterval)duration {
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @0;
        animation.toValue = @1;
        animation.duration = duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeBoth;
        animation.removedOnCompletion = true;

        [_highBarLayer addAnimation:animation forKey:animation.keyPath];
    }

    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @0;
        animation.toValue = @1;
        animation.duration = duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeBoth;
        animation.removedOnCompletion = true;

        [_lowBarLayer addAnimation:animation forKey:animation.keyPath];
    }

    {
        CGPoint position = CGPointMake(_highIndicatorView.layer.position.x, _highIndicatorView.layer.position.y);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];

        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(position.x, position.y + _highBarView.frame.size.height)];
        animation.toValue = [NSValue valueWithCGPoint:position];

        animation.duration = duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeBoth;
        animation.removedOnCompletion = true;

        [_highIndicatorView.layer addAnimation:animation forKey:animation.keyPath];
    }

    {
        CGPoint position = CGPointMake(_lowIndicatorView.layer.position.x, _lowIndicatorView.layer.position.y);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];

        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(position.x, position.y - _lowBarView.frame.size.height)];
        animation.toValue = [NSValue valueWithCGPoint:position];

        animation.duration = duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeBoth;
        animation.removedOnCompletion = true;

        [_lowIndicatorView.layer addAnimation:animation forKey:animation.keyPath];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat barWidth = _highBarView.bounds.size.width;
    CGFloat barHeight = _highBarView.bounds.size.height;
    if (_highBarLayer == nil || _highBarLayer.bounds.size.height != barHeight) {

        [_highBarLayer removeFromSuperlayer];
        _highBarLayer = [[CAShapeLayer alloc] init];
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(barWidth / 2, barHeight)];
        [path addLineToPoint:CGPointMake(barWidth / 2, 0)];
        path.lineWidth = barWidth;

        _highBarLayer.path = path.CGPath;
        _highBarLayer.strokeColor = _barData.barTintColor.CGColor;
        _highBarLayer.lineWidth = barWidth;
        [_highBarView.layer addSublayer:_highBarLayer];
    }
    if (_lowBarLayer == nil || _lowBarLayer.bounds.size.height != barHeight) {

        [_lowBarLayer removeFromSuperlayer];
        _lowBarLayer = [[CAShapeLayer alloc] init];
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(barWidth / 2, 0)];
        [path addLineToPoint:CGPointMake(barWidth / 2, barHeight)];
        path.lineWidth = barWidth;

        _lowBarLayer.path = path.CGPath;
        _lowBarLayer.strokeColor = _barData.barTintColor.CGColor;
        _lowBarLayer.lineWidth = barWidth;
        [_lowBarView.layer addSublayer:_lowBarLayer];
    }
}

- (void)prepareView {
    _highBarView = [UIView new];
    _lowBarView = [UIView new];
    _highIndicatorView = [UIView new];
    _lowIndicatorView = [UIView new];

    _highIndicatorView.backgroundColor = _barData.highTintColor;
    _lowIndicatorView.backgroundColor = _barData.lowTintColor;

    _highBarView.translatesAutoresizingMaskIntoConstraints = NO;
    _lowBarView.translatesAutoresizingMaskIntoConstraints = NO;
    _highIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    _lowIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:_highBarView];
    [self addSubview:_lowBarView];
    [self addSubview:_highIndicatorView];
    [self addSubview:_lowIndicatorView];

    NSDictionary *views = @{@"highBarView":_highBarView,
                            @"lowBarView":_lowBarView,
                            @"highIndicatorView":_highIndicatorView,
                            @"lowIndicatorView":_lowIndicatorView};

    NSMutableArray *constraints = [NSMutableArray new];
    NSArray *highBarConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[highIndicatorView]-(-1)-[highBarView]"
                                                                         options:NSLayoutFormatAlignAllLeft
                                                                         metrics:nil
                                                                           views:views];
    NSArray *lowBarConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lowBarView]-(-1)-[lowIndicatorView]"
                                                                        options:NSLayoutFormatAlignAllLeft
                                                                        metrics:nil
                                                                          views:views];

    [constraints addObjectsFromArray:highBarConstraint];
    [constraints addObjectsFromArray:lowBarConstraint];

    double normalizedHighValue = [self normalizedValueForValue:_barData.highValue.doubleValue];
    double normalizedLowValue = [self normalizedValueForValue:_barData.lowValue.doubleValue];
    double normalizedHeightValue = (normalizedHighValue - normalizedLowValue) / 2;
    double normalizedHeightPercentage = normalizedHeightValue - IndicatorHeightPercentage;
    double normalizedMidPoint = normalizedLowValue + normalizedHeightValue;

    normalizedHeightPercentage = normalizedHeightPercentage > 0 ? normalizedHeightPercentage : 0;

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_highBarView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:BarWidthPercentage
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_highBarView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:normalizedHeightPercentage
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_highBarView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_highBarView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1-normalizedMidPoint
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_lowBarView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:BarWidthPercentage
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_lowBarView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:normalizedHeightPercentage
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_lowBarView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_lowBarView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1-normalizedMidPoint
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_highIndicatorView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:IndicatorHeightPercentage
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_highIndicatorView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_lowIndicatorView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:IndicatorHeightPercentage
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_lowIndicatorView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0.0]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end
