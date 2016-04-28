//
//  DLCollectionViewCell.m
//  瀑布流
//
//  Created by dev on 16/4/28.
//  Copyright © 2016年 donglian@eastunion.net. All rights reserved.
//

#import "DLCollectionViewCell.h"
#import "DLCollection.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"


@interface DLCollectionViewCell ()

@property (nonatomic, weak) UIImageView *collectionViewImg;


@property (nonatomic, weak) UILabel *priceLabel;

@end


@implementation DLCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *collectionViewImg = [[UIImageView alloc] init];
        [self addSubview:collectionViewImg];
        self.collectionViewImg = collectionViewImg;
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:priceLabel];
        self.priceLabel = priceLabel;
        
        [collectionViewImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        
    }
    return self;
}

- (void)setCollection:(DLCollection *)collection
{
    
    _collection = collection;
    
    // 1.图片
    [_collectionViewImg sd_setImageWithURL:[NSURL URLWithString:_collection.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.显示价格
    _priceLabel.text = collection.price;
}

@end
