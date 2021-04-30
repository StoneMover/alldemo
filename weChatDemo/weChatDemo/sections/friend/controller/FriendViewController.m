//
//  FriendViewController.m
//  weChatDemo
//
//  Created by stonemover on 2019/2/25.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "FriendViewController.h"
#import "FriendNet.h"
#import "FriendModel.h"
#import "FriendHeadView.h"
#import "FriendTableViewCell.h"
#import "PersonModel.h"
#import "Const.h"
#import <BTHelp/UIImage+BTImage.h>

@interface FriendViewController ()

@property (nonatomic, strong) FriendHeadView * headView;

@property (nonatomic, strong) NSMutableArray * dataArrayAll;

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArrayAll=[NSMutableArray new];
    [self initTitle:@"朋友圈"];
    [self navSet];
    
    [self initTableView:@[@"FriendTableViewCell"]];
    [self setTableViewNoMoreEmptyLine];
    [self initHeadView];
    self.isNeedFootRefresh=YES;
    self.isNeedHeadRefresh=YES;
    self.loadFinishDataNum=5;
    
    [self initLoading];
    [self getData];
}

- (void)navSet{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:KRGBColor(235, 235, 235)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)initHeadView{
    self.headView=[[FriendHeadView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 250)];
    [self.tableView setTableHeaderView:self.headView];
}

#pragma mark tableView data delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCellId"];
    FriendModel * model =self.dataArray[indexPath.row];
    [cell setData:model];
    return cell;
}


#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendModel * model =self.dataArray[indexPath.row];
    return model.height;
}

#pragma mark refresh
- (void)headRefreshLoad{
    [self loadNextPage:1 isRefresh:YES];
}
- (void)footRefreshLoad{
    [self loadNextPage:1 isRefresh:NO];
}

#pragma mark data request
- (void)getData{
    [FriendNet getUserInfo:self.loadingHelp success:^(id obj) {
        PersonModel * model =[PersonModel modelWithDict:obj];
        [self.headView setData:model];
        [self getFriendData];
    } fail:^(NSError *error) {
        
    }];
}

- (void)getFriendData{
    [FriendNet getFirendInfo:self.loadingHelp success:^(id obj) {
        NSArray * array=obj;
        for (NSDictionary * dict in array) {
            FriendModel * model =[FriendModel modelWithDict:dict];
            if (!model.error&&(model.content||model.images)) {
                //这里过滤掉一些脏数据
                [model calculate];
                [self.dataArrayAll addObject:model];
            }
        }
        [self loadNextPage:0 isRefresh:NO];
    } fail:^(NSError *error) {
        
    }];
}

- (void)loadNextPage:(CGFloat)time isRefresh:(BOOL)isRefresh{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isRefresh) {
            [self.dataArray removeAllObjects];
        }
        NSInteger nowNum=self.dataArray.count;
        for (NSInteger i=self.dataArray.count; i<self.dataArrayAll.count&&i<nowNum+5; i++) {
            FriendModel * model =self.dataArrayAll[i];
            [self.dataArray addObject:model];
        }
        self.pageNumber++;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endFootRefresh];
            [self endHeadRefresh];
            [self.tableView reloadData];
            self.isLoadFinish=self.dataArrayAll.count==self.dataArray.count;
        });
    });
}

- (void)refreshPage{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
}

@end
