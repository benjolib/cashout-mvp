//
// Created by Stefan Walkner on 02.04.15.
// Copyright (c) 2015 Cashout App GbR. All rights reserved.
//

#import "COACurrencyChooserViewController.h"

@interface COACurrencyChooserViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *customConstraints;

@end

static NSString *CellIdentifier = @"COCurrencyChooserViewControllerCell";

@implementation COACurrencyChooserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _customConstraints = [[NSMutableArray alloc] init];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    NSDictionary *views = @{@"tableView":self.tableView};

    for (UIView *view in views.allValues) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self.view removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];

    [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.customConstraints addObject:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

    [self.view addConstraints:self.customConstraints];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self currencies].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }

    cell.textLabel.text = self.currencies[(NSUInteger) indexPath.row];

    return cell;
}

- (NSArray *)currencies {
    return @[
            @"USDCAD",
            @"GPBUSD",
            @"GBPJPY",
            @"USDCHF",
            @"NZDUSD",
            @"EURJPY",
            @"EURGBP",
            @"EURUSD",
            @"EURGBP",
            @"DAX",
            @"GOLD",
            @"DOW",
            @"CRUDE OIL",
            @"NASDAQ",
            @"SP500",
            @"BITCOINS"
    ];
}

@end
