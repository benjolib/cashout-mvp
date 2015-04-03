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
            @"GBPUSD",
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

- (NSDictionary *)currencyDictionary {
    return @{
            @"USDCAD":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DUSDCAD%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"GBPUSD":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DGBPUSD%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"GBPJPY":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DGBPJPY%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"USDCHF":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DUSDCHF%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"NZDUSD":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DNZDUSD%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"EURJPY":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DEURJPY%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"EURGBP":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DEURGBP%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"EURUSD":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DEURUSD%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"EURGBP":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DEURGBP%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"DAX":@"",
            @"GOLD":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3D274702%3DX%22%3B&format=json&diagnostics=true&callback=",
            @"DOW":@"",
            @"CRUDE OIL":@"",
            @"NASDAQ":@"",
            @"SP500":@"",
            @"BITCOINS":@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3DBTCUSD%3DX%22%3B&format=json&diagnostics=true&callback="
    };
}

@end
