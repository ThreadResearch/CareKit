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

#import "OCKInsightsSelectorViewController.h"
#import "OCKDefines_Private.h"

static const CGFloat AnimationDuration = 0.40;
static const CGFloat CancelFontSize = 17.0;
static const CGFloat SelectorViewHeaderHeight = 44.0;
static const CGFloat SelectorViewCellHeight = 80.0;
static const CGFloat SelectorViewButtonWidth = 100.0;
static NSString *SelectCellReuseIdentifer = @"Select Cell";

@implementation OCKInsightsSelectorViewController {
    UITableView *_tableView;

    NSArray<NSString *> * _titles;
    NSUInteger _selectedIndex;
    CGRect _downFrame;
    CGRect _upFrame;
}

- (id)initWithTitles:(NSArray<NSString *> *)titles withSelectedIndex:(NSUInteger)index {
    NSAssert(titles.count > 0, @"OCKInsightsSelectorViewController: The number of titles must be greater than 0.");

    self = [super init];
    if (self) {
        _titles = titles;
        _selectedIndex = index;
        [self prepareView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
}

- (void)viewWillAppear:(BOOL)__unused animated {
    [super viewWillAppear:animated];

    [_tableView reloadData];
    [self moveUpTableViewWithCompletion:nil];
}

#pragma mark - Helper Functions

- (void)dismissView {
    [self dismissViewControllerAnimated:true completion:nil];
//    [self moveDownTableViewWithCompletion:^(BOOL finished) {
//        [self dismissViewControllerAnimated:NO completion:nil];
//    }];
}

- (void)prepareView {
    _downFrame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 20);
    _upFrame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);

    _tableView = [[UITableView alloc] initWithFrame:_upFrame style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.sectionHeaderHeight = SelectorViewHeaderHeight;
    _tableView.rowHeight = SelectorViewCellHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];

    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SelectCellReuseIdentifer];
}

- (void)moveUpTableViewWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    [UIView
     animateWithDuration:AnimationDuration
     delay:0.0
     options:UIViewAnimationOptionCurveEaseIn
     animations:^{
         _tableView.frame = _upFrame;
     }
     completion:^(BOOL finished) {
         if (completion) {
             completion(finished);
         }
     }];
}

- (void)moveDownTableViewWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    [UIView
     animateWithDuration:AnimationDuration
     delay:0.0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^{
         _tableView.frame = _downFrame;
     }
     completion:^(BOOL finished) {
         if (completion) {
             completion(finished);
         }
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)__unused tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)__unused tableView numberOfRowsInSection:(NSInteger)__unused section {
    return _titles.count;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)__unused tableView viewForHeaderInSection:(NSInteger)section {
    NSString *cancelString = OCKLocalizedString(@"CANCEL", nil);
    NSString *selectString = OCKLocalizedString(@"SELECT", nil);
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(_tableView.frame.size.width - SelectorViewButtonWidth,
                              0,
                              SelectorViewButtonWidth,
                              SelectorViewHeaderHeight);
    [cancel setTitle:cancelString forState:UIControlStateNormal];
    [cancel setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    cancel.titleLabel.font = [UIFont systemFontOfSize:CancelFontSize];

    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] init];
    headerView.textLabel.text = selectString;
    [headerView addSubview:cancel];

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectCellReuseIdentifer forIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];

    cell.textLabel.text = _titles[indexPath.row];

    if (indexPath.row == _selectedIndex) {
        cell.textLabel.textColor = self.view.tintColor;
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        cell.textLabel.textColor = [UIColor darkTextColor];
    }

    return cell;
}

- (void)tableView:(UITableView *)__unused tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    [self.delegate selectorView:self didSelectTitleAtIndex:_selectedIndex];

    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    [self dismissView];
}

@end
