//
//  DLCollectionViewCell.h
//  瀑布流
//
//  Created by dev on 16/4/28.
//  Copyright © 2016年 donglian@eastunion.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLCollection;

@interface DLCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) DLCollection *collection;

@end
