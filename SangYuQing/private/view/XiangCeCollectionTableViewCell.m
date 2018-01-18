//
//  XiangCeCollectionTableViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "XiangCeCollectionTableViewCell.h"
#import "SZDetailModel.h"
#import "XiangCeCollectionViewCell.h"
#import "PhotoModel.h"

@interface XiangCeCollectionTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
//@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong, nonatomic) UICollectionView *collectionview;
@property(nonatomic,strong)NSArray *images;

@end
@implementation XiangCeCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configWithModel:(SZDetailModel*)model{
    

    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-40)/3, ([UIScreen mainScreen].bounds.size.width-40)/3*4);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.contentView addSubview:_collectionview];
    [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    [_collectionview registerNib:[UINib nibWithNibName:@"XiangCeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"xiangce_cell"];
    _collectionview.backgroundColor = [UIColor clearColor];
    
    
    _images = model.photos;
    [_collectionview reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XiangCeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xiangce_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    PhotoModel *model = _images[indexPath.row];
    [cell configWithXiangCeModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}


@end
