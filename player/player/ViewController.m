//
//  ViewController.m
//  player
//
//  Created by whbt_mac on 16/7/5.
//  Copyright © 2016年 StoneMover. All rights reserved.
//

#import "ViewController.h"
#import "BTAvPlayer.h"

@interface ViewController ()<BTAvPlayerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet BTAvPlayer *player;

@property (nonatomic,strong) NSArray * dataSource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) int index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource=[[NSArray alloc]initWithObjects:
                     @"http://images.apple.com/media/us/iphone-6s/2015/dhs3b549_75f9_422a_9470_4a09e709b350/films/feature/iphone6s-feature-cc-us-20150909_1280x720h.mp4",
                     @"http://movies.apple.com/media/us/iphone/2010/tours/apple-iphone4-design_video-us-20100607_848x480.mov",
                     @"https://www.apple.com/media/cn/iphone-7/2016/5937a0dc_edb0_4343_af1c_41ff71808fe5/films/feature/iphone7-feature-tft-cn-20160907_1536x640h.mp4",
                     @"https://www.apple.com/media/cn/iphone-7/2016/5937a0dc_edb0_4343_af1c_41ff71808fe5/films/materials/iphone7-materials-tft-cn-20160907_1536x640h.mp4",
                     nil];
    self.player.dataSource=self.dataSource;
    self.player.delegate=self;
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"UITableViewCell" bundle:nil] forCellReuseIdentifier:@""];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    
}

#pragma mark tableView delegate&dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    //初始化cell并指定其类型，也可自定义cell
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]init];
    }
    cell.textLabel.text=self.dataSource[indexPath.row];
    if(self.index==indexPath.row){
        cell.textLabel.textColor=[UIColor redColor];
    }else{
        cell.textLabel.textColor=[UIColor lightGrayColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.index=(int)indexPath.row;
    [self.player pause];
    [self.player play:self.index];
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)BTAvPlayerStartPlay:(BTAvPlayer *)player{
    
}

@end
