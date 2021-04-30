//
//  FriendComment.m
//  weChatDemo
//
//  Created by stonemover on 2019/2/25.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "FriendCommentView.h"
#import "CommentTableViewCell.h"
#import "FriendCommentModel.h"
#import <BTHelp/UIView+BTViewTool.h>

@interface FriendCommentView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation FriendCommentView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSelf];
}

- (void)initSelf{
    self.tableView=[[UITableView alloc] init];
    self.tableView.backgroundColor=KLightGray;
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentTableViewCellId"];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self addSubview:self.tableView];
}

- (void)layoutSubviews{
    self.tableView.frame=CGRectMake(5, 5, self.width-10, self.height-10);
}

#pragma mark tableView data delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCellId"];
    FriendCommentModel * model =self.dataArray[indexPath.row];
    [cell.labelContent setAttributedText:model.resultStr];
    
    return cell;
}


#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendCommentModel * model =self.dataArray[indexPath.row];
    return model.h;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray=dataArray;
    [self.tableView reloadData];
}



@end
