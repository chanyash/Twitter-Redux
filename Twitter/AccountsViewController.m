//
//  AccountsViewController.m
//  Twitter
//
//  Created by Joanna Chan on 2/16/15.
//  Copyright (c) 2015 yahoo. All rights reserved.
//

#import "AccountsViewController.h"
#import "ProfileCell.h"
#import "User.h"
#import "AddAccountTableViewCell.h"

@interface AccountsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *accounts;

@end

@implementation AccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddAccountTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddAccountTableViewCell"];
    self.tableView.rowHeight = 113;
    
    self.accounts = [NSMutableArray array];
    [self.accounts addObject: [User currentUser]];
    
    NSLog(@"count: %lu", (unsigned long)self.accounts.count);
    
    [self.tableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accounts.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row < self.accounts.count){
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        cell.currentUser = self.accounts[indexPath.row];
        cell.showBgImage = @"YES";
        return cell;
    }else{
        AddAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddAccountTableViewCell"];
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 113;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
