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


#import "OCKInsightsDropDownView.h"
#import "OCKLabel.h"

static const CGFloat Padding = 5.0;
static const CGFloat CarrotImageHeightPercentage = 0.15;


@implementation OCKInsightsDropDownView {
    NSArray<NSString *> *_titles;
    OCKLabel*_title;
    UIImageView *_carrot;

    NSUInteger _selectedIndex;
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles {
    NSAssert(titles.count > 0, @"OCKInsightsDropDownView: The number of titles must be greater than 0.");

    self = [super init];
    if (self) {
        _selectedIndex = 0;
        _titles = titles;
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(tapped)];
        [self addGestureRecognizer:singleFingerTap];
        [self prepareView];
    }
    return self;
}

- (void)tapped {
    OCKInsightsSelectorViewController *selectorVC = [[OCKInsightsSelectorViewController alloc] initWithTitles:_titles withSelectedIndex:_selectedIndex];
    selectorVC.delegate = self;
    selectorVC.view.tintColor = self.tintColor;

    UIViewController *viewController = [self getRootViewController];
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [viewController presentViewController:selectorVC animated:true completion:nil];
}

- (UIViewController *)getRootViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return rootViewController;
}

- (void)prepareView {
    NSMutableArray *constraints = [NSMutableArray new];

    _title = [OCKLabel new];
    _carrot = [[UIImageView alloc] init];

    _title.translatesAutoresizingMaskIntoConstraints = NO;
    _carrot.translatesAutoresizingMaskIntoConstraints = NO;
    _title.userInteractionEnabled = NO;
    _carrot.userInteractionEnabled = NO;

    _title.text = _titles[_selectedIndex];
    _title.textStyle = UIFontTextStyleHeadline;
    _title.textColor = [UIColor darkTextColor];

    UIImage *carrotImage = [UIImage imageNamed:@"dropDownArrow" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    CGFloat carrotWidthRatio = carrotImage.size.width / carrotImage.size.height;
    _carrot.image = carrotImage;

    [self addSubview:_title];
    [self addSubview:_carrot];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_title
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_title
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_title
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_title
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_carrot
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                         constant:-Padding]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_carrot
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_carrot
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_carrot
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:CarrotImageHeightPercentage
                                                         constant:0.0]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:_carrot
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_carrot
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:carrotWidthRatio
                                                         constant:0.0]];

    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - UITableViewDelegate

- (void)selectorView:(OCKInsightsSelectorViewController *)selectorView didSelectTitleAtIndex:(NSUInteger)index {
    _selectedIndex = index;
    _title.text = _titles[index];
}

@end
