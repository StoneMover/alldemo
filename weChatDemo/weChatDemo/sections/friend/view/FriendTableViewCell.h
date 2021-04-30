//
//  FriendTableViewCell.h
//  weChatDemo
//
//  Created by stonemover on 2019/2/24.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendImgContainerView.h"
#import "FriendCommentView.h"
#import "FriendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelNick;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet FriendImgContainerView *viewImg;
@property (weak, nonatomic) IBOutlet FriendCommentView *viewComment;

- (void)setData:(FriendModel*)model;

@end

NS_ASSUME_NONNULL_END
