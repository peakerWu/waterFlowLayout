//
//  ViewController.m
//  瀑布流
//
//  Created by dev on 16/4/26.
//  Copyright © 2016年 donglian@eastunion.net. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "DLCollection.h"
#import "DLCollectionViewCell.h"
#import "DLCollectionViewFlowLayout.h"

@interface ViewController () <UICollectionViewDataSource, DLCollectionViewFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *collectionArray;

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation ViewController


static NSString * const collectionCellID = @"collectionCell";

- (NSMutableArray *)collectionArray
{
    if (!_collectionArray) {
        
        _collectionArray = [NSMutableArray array];
        
    }
    return _collectionArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    
    [self setupRefresh];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)setupRefresh
{
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewCollection)];
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreColletion)];
    self.collectionView.footer.hidden = YES;
    
}
- (void)loadNewCollection
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *array = [DLCollection objectArrayWithFilename:@"1.plist"];
        [self.collectionArray removeAllObjects];
        [_collectionArray addObjectsFromArray:array];
        
        [self.collectionView reloadData];
        
        [self.collectionView.header endRefreshing];
        
    });
    
}

- (void)loadMoreColletion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    NSArray *array = [DLCollection objectArrayWithFilename:@"1.plist"];
    [_collectionArray addObjectsFromArray:array];
    
    [self.collectionView reloadData];
    [self.collectionView.footer endRefreshing];
    
    });
    
}
- (void)setupLayout
{
    
    DLCollectionViewFlowLayout *layout = [[DLCollectionViewFlowLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[DLCollectionViewCell class] forCellWithReuseIdentifier:collectionCellID];
    
    self.collectionView = collectionView;
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 当 self.collectionArray.count==0 为hidden。
    
//    if (self.collectionArray.count == 0) {
//        self.collectionView.footer.hidden = YES;
//    }else {
//        self.collectionView.footer.hidden = NO;
//        
//    }
    
    self.collectionView.footer.hidden = self.collectionArray.count == 0;
    
    return self.collectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[DLCollectionViewCell alloc] init];
    }
    
    cell.collection = self.collectionArray[indexPath.item];
    
    return cell;
}
#pragma mark - <DLCollectionViewFlowLayoutDelegate>
- (CGFloat)collectionViewFlowLayout:(DLCollectionViewFlowLayout *)collectionViewFlowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    DLCollection *collection = self.collectionArray[index];
    return collection.h / collection.w * itemWidth;
}

- (NSInteger)columnCountCollectionViewFlowLayout:(DLCollectionViewFlowLayout *)collectionViewFlowLayout
{
    if (self.collectionArray.count <= 50) return 2;
    if (self.collectionArray.count > 50 && self.collectionArray.count <= 100) return 3;
    return 4;
}
- (CGFloat)columnMariginCollectionViewFlowLayout:(DLCollectionViewFlowLayout *)collectionViewFlowLayout
{
    return 20;
}
- (CGFloat)rowMariginCollectionViewFlowLayout:(DLCollectionViewFlowLayout *)collectionViewFlowLayout
{
    return 20;
}
//- (UIEdgeInsets)edgeInsetsCollectionViewFlowLayout:(DLCollectionViewFlowLayout *)collectionViewFlowLayout
//{
//    return UIEdgeInsetsMake(10, 20, 30, 100);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
