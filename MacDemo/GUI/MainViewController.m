//
//  MainViewController.m
//  MacDemo
//
//  Created by liuqin on 2018/1/16.
//  Copyright © 2018年 liuqin. All rights reserved.
//

#import "MainViewController.h"
#import "WebServiceController.h"
#import "Public.h"
#import "PublicCItem.h"
@interface MainViewController ()<NSCollectionViewDelegate,NSCollectionViewDataSource>{
    
    __weak IBOutlet NSCollectionView *_collectionView;
    NSArray *_publicArr;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_collectionView registerClass:[PublicCItem class] forItemWithIdentifier:@"Public"];
    NSCollectionViewFlowLayout * layout = [[NSCollectionViewFlowLayout alloc] init];
    layout.itemSize = NSSizeFromCGSize(CGSizeMake(180, 180));
    layout.minimumInteritemSpacing = 10;// 设置列的最小间距
    layout.minimumLineSpacing = 10;// 设置最小行间距
    layout.scrollDirection = NSCollectionViewScrollDirectionVertical; // 滚动方向
    _collectionView.collectionViewLayout = layout;
    
    [[WebServiceController getInstance] getSharePublicListWithPageNum:0 requestNum:20 typeId:@"not_other_but_this_as_empty" Suc:^(NSArray *result) {
        _publicArr = result;
        [_collectionView reloadData];
    } Failure:^(int error) {
        
    }];
}
- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _publicArr.count;
}
- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath{
    PublicCItem *item = [collectionView makeItemWithIdentifier:@"Public" forIndexPath:indexPath];
    Public *public = _publicArr[indexPath.item];
    item.imageView.image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:public.imageUrl]];
    item.titleLab.stringValue = public.shareName;
    item.view.wantsLayer = YES;
    item.view.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
    return item;
}
- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths{
    
}
@end
