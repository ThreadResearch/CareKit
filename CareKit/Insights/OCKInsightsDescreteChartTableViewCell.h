//
//  OCKInsightsDescreteChartTableViewCell.h
//  CareKit
//
//  Created by Andy Yeung on 5/23/16.
//  Copyright © 2016 carekit.org. All rights reserved.
//

#import "OCKTableViewCell.h"

@interface OCKInsightsDescreteChartTableViewCell : OCKTableViewCell

@property (nonatomic) OCKChart *chart;

- (void)animateWithDuration:(NSTimeInterval)duration;

@end
