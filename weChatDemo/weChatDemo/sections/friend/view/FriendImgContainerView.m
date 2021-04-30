//
//  FriendImgContainerView.m
//  weChatDemo
//
//  Created by stonemover on 2019/2/24.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "FriendImgContainerView.h"
#import "FriendCollectionViewCell.h"
#import <BTHelp/UIView+BTViewTool.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "FriendImgModel.h"

@interface FriendImgContainerView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, assign) CGFloat imgSize;

@end


@implementation FriendImgContainerView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSelf];
}

- (void)initSelf{
    
    self.imgSize=(KScreenWidth-67-16-10)/3;
    
    UICollectionViewFlowLayout * layout =[[UICollectionViewFlowLayout alloc] init];
    self.collectionView=[[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor=KWhiteColor;
    [self addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FriendCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"FriendCollectionViewCellId"];
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
}

- (void)layoutSubviews{
    self.collectionView.frame=self.bounds;
}

#pragma mark uicollection delegate
//cell 数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FriendCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"FriendCollectionViewCellId"
                                                                          forIndexPath:indexPath];
    FriendImgModel * model =self.dataArray[indexPath.row];
    [cell.imgViewContent sd_setImageWithURL:URL(model.url) placeholderImage:PLACE_HOLDER];
    return cell;
}

//每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.imgSize, self.imgSize);
}


//上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//左右间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray=dataArray;
    [self.collectionView reloadData];
}



@end
