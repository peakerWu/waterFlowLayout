//
//  DLCollectionViewFlowLayout.h
//  瀑布流
//
//  Created by dev on 16/4/26.
//  Copyright © 2016年 donglian@eastunion.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLCollectionViewFlowLayout;

@protocol DLCollectionViewFlowLayoutDelegate <NSObject>

@required
- (CGFloat)collectionViewFlowLayout:(DLCollectionViewFlowLayout *)collectionViewFlowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
/** 列间距 */
- (CGFloat)columnMariginCollectionViewFlowLayout:(DLCollectionViewFlowLayout *)collectionViewFlowLayout;
/** 行间距 */
- (CGFloat)rowMariginCollectionViewFlowLayout:(DLCollectionViewFlowLayout *)collectionViewFlowLayout;
/** 列数 */
- (NSInteger)columnCountCollectionViewFlowLayout:(DLCollectionViewFlowLayout *)collectionViewFlowLayout;

- (UIEdgeInsets)edgeInsetsCollectionViewFlowLayout:(DLCollectionViewFlowLayout *)collectionViewFlowLayout;


@end



@interface DLCollectionViewFlowLayout : UICollectionViewLayout


@property (nonatomic, assign) id<DLCollectionViewFlowLayoutDelegate> delegate;

@end
