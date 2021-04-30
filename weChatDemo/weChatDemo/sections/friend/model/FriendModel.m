//
//  FriendModel.m
//  weChatDemo
//
//  Created by stonemover on 2019/2/24.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "FriendModel.h"
#import <BTHelp/BTUtils.h>
#import "FriendCommentModel.h"


@implementation FriendModel

- (void)initSelf{
    self.classDict=@{@"sender":@"PersonModel",@"images":@"FriendImgModel",@"comments":@"FriendCommentModel"};
}


- (void)calculate{
    CGFloat basicH=50;
    self.contentH=[BTUtils calculateStrHeight:self.content width:KScreenWidth-65-16 font:SystemFont(15, UIFontWeightMedium)]+1;
    self.height=basicH+self.contentH;
    [self calculateImg];
    [self calculateComment];
}

- (void)calculateImg{
    if (!self.images) {
        return;
    }
    
    CGFloat cellHeight=(KScreenWidth-67-16-10)/3;
    int line =self.images.count%3==0?self.images.count/3:self.images.count/3+1;
    self.imgContainerH=cellHeight*line+(line-1)*5;
    if (self.images.count==4) {
        self.imgContainerW=KScreenWidth-67-16-cellHeight-5;
        self.imgContainerH=self.imgContainerW;
    }else{
        self.imgContainerW=KScreenWidth-67-16;
    }
    self.height+=self.imgContainerH+11;
}

- (void)calculateComment{
    if (!self.comments) {
        return;
    }
    
    for (FriendCommentModel * model in self.comments) {
        NSString * str=[NSString stringWithFormat:@"%@ : %@",model.sender.nick,model.content];
        model.h=[BTUtils calculateStrHeight:str width:KScreenWidth-67-16-10 font:SystemFont(15, UIFontWeightMedium)]+2;
        self.commentH+=model.h;
        
        NSRange hightlightTextRange = [str rangeOfString:model.sender.nick];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:KBlueColor range:hightlightTextRange];
        model.resultStr=attributeStr;
    }
    self.commentH+=10;
    self.height+=self.commentH+18;
}

@end
