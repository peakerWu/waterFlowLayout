//
//  DLCollectionViewFlowLayout.m
//  瀑布流
//
//  Created by dev on 16/4/26.
//  Copyright © 2016年 donglian@eastunion.net. All rights reserved.
//

#import "DLCollectionViewFlowLayout.h"

/** 默认列数 */
static const NSInteger defaultColumnCount = 3;
/** 默认列间距 */
static const CGFloat defaultColumnMarigin = 10;
/** 默认行间距 */
static const CGFloat defaultRowMarigin = 10;
/** 边缘间距 */
static const UIEdgeInsets defaultEdgeInsets = {10, 10, 10, 10};



@interface DLCollectionViewFlowLayout ()

/** 存储属性的数组 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
/** 存储所有行高的数组 */
@property (nonatomic, strong) NSMutableArray *columnHeights;

/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;


- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;

@end

@implementation DLCollectionViewFlowLayout

- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMariginCollectionViewFlowLayout:)]) {
        return [self.delegate rowMariginCollectionViewFlowLayout:self];
    }else {
        return defaultRowMarigin;
    }
}
- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMariginCollectionViewFlowLayout:)]) {
        return [self.delegate columnMariginCollectionViewFlowLayout:self];
    }else {
        return defaultColumnMarigin;
    }
    
}
- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountCollectionViewFlowLayout:)]) {
        return [self.delegate columnCountCollectionViewFlowLayout:self];
    }else {
        return defaultColumnCount;
    }
}
- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsCollectionViewFlowLayout:)]) {
        return [self.delegate edgeInsetsCollectionViewFlowLayout:self];
    }else {
        return defaultEdgeInsets;
    }
}
/** 懒加载很重要 */
- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    // 移除所有的高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    // 移除所有的属性
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        // 调用下面的 UICollectionViewLayoutAttributes 方法
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArray addObject:attrs];
    }
    
}
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 计算属性的frame
    
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    CGFloat w = (collectionViewWidth - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin)/self.columnCount;
    
    CGFloat h = [self.delegate collectionViewFlowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    // 高度最小的列
    NSInteger destColumn = 0;
    CGFloat minColumnHeigths = [self.columnHeights[destColumn] doubleValue];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        
        CGFloat columnHeights = [self.columnHeights[i] doubleValue];
        
        if (columnHeights < minColumnHeigths) {
            minColumnHeigths = columnHeights;
            destColumn = i;
        }
    }
    
    
    CGFloat x = self.edgeInsets.left + (w + self.columnMargin) * destColumn;
    CGFloat y = minColumnHeigths;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 更新最短的那列高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    
    return attrs;
}

@end
