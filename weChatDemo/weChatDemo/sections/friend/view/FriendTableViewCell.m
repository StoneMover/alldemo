//
//  FriendTableViewCell.m
//  weChatDemo
//
//  Created by stonemover on 2019/2/24.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "FriendTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FriendTableViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelContentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewH;
@end


@implementation FriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(FriendModel*)model{
    
    self.labelNick.text=model.sender.nick;
    [self.imgViewIcon sd_setImageWithURL:URL(model.sender.avatar) placeholderImage:PLACE_HOLDER];
    
    if (model.content) {
        self.labelContent.hidden=NO;
        self.labelContentH.constant=model.contentH;
        self.labelContent.text=model.content;
        self.collectionViewTop.constant=11;
    }else{
        self.labelContent.hidden=YES;
        self.labelContentH.constant=0;
        self.collectionViewTop.constant=3;
    }
    
    if (model.images) {
        self.viewImg.hidden=NO;
        self.viewImg.dataArray=model.images;
        self.collectionViewW.constant=model.imgContainerW;
        self.collectionViewH.constant=model.imgContainerH;
    }else{
        self.viewImg.hidden=YES;
    }
    
    if (model.comments) {
        self.viewComment.hidden=NO;
        self.commentViewH.constant=model.commentH;
        self.viewComment.dataArray=model.comments;
    }else{
        self.commentViewH.constant=0;
        self.viewComment.hidden=YES;
    }
    
}

@end
