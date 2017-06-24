//
//  DropdownMenuView.m
//  LeoaoApp
//
//  Created by Karos on 15/12/22.
//  Copyright © 2015年 LK. All rights reserved.
//

#import "LKShareMenuView.h"
#import "LKShareMenuCollectionCell.h"

static NSString *LKShareMenuCollectionCellIdentifier = @"LKShareMenuCollectionCell";

@interface LKShareMenuView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (assign, nonatomic) NSInteger columnCount;
@property (assign, nonatomic) NSInteger columnSpace;
@property (assign, nonatomic) NSInteger rowSpace;
@property (assign, nonatomic) UIEdgeInsets insets;
@property (assign, nonatomic) CGFloat height;

@property (strong, nonatomic) NSArray *datasoure;
@property (copy, nonatomic) LKShareMenuChooseItemBlock chooseItemBlock;

@end

@implementation LKShareMenuView

+ (void)show:(NSArray<NSString *> *)datasoure block:(LKShareMenuChooseItemBlock)block {
    LKShareMenuView *menu = [[LKShareMenuView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [menu initWithDataSource:datasoure block:block];
    [[UIApplication sharedApplication].keyWindow addSubview:menu];
    [menu show];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        bundle = [NSBundle bundleWithURL:[bundle URLForResource:@"LKShareMenu" withExtension:@"bundle"]];
        self = [[bundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        self.frame = frame;
        
        _columnCount = 3;
        _columnSpace = 0;
        _rowSpace = 20;
        _insets = UIEdgeInsetsMake(20, 0, 20, 0);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapParentView:)];
        [self addGestureRecognizer:tapGesture];
        tapGesture.cancelsTouchesInView = NO;
        
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0) collectionViewLayout:self.flowLayout];
        [self.collectionView registerNib:[UINib nibWithNibName:LKShareMenuCollectionCellIdentifier bundle:bundle] forCellWithReuseIdentifier:LKShareMenuCollectionCellIdentifier];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
    }
    
    return self;
}

- (void)initWithDataSource:(NSArray *)datasoure block:(LKShareMenuChooseItemBlock)block {
    _datasoure = datasoure;
    _chooseItemBlock = block;
    
    [self initUI];
}

- (void)initUI {
    self.flowLayout.minimumLineSpacing = self.rowSpace;
    self.flowLayout.minimumInteritemSpacing = self.columnSpace;
    CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width - self.insets.left - self.insets.right - (self.columnCount - 1) * self.columnSpace) / self.columnCount;
    CGFloat cellHeight = 70;
    self.flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.flowLayout.sectionInset = self.insets;

    NSInteger rowCount = self.datasoure.count % self.columnCount > 0 ? self.datasoure.count / self.columnCount + 1 : self.datasoure.count / self.columnCount;
    self.height = self.rowSpace * (rowCount - 1) + cellHeight * rowCount + self.insets.top + self.insets.bottom;
    self.collectionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.height);
    [self.collectionView reloadData];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)show {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        self.collectionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.height, [UIScreen mainScreen].bounds.size.width, self.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    } completion:^(BOOL finished) {

    }];
}

- (void)dismiss:(void (^)(void))completion {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.collectionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasoure.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    bundle = [NSBundle bundleWithURL:[bundle URLForResource:@"LKShareMenu" withExtension:@"bundle"]];
    
    LKShareMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LKShareMenuCollectionCellIdentifier forIndexPath:indexPath];
    NSString *snsPlatform = self.datasoure[indexPath.row];
    if ([snsPlatform isEqualToString:LKShareToWechatSession]) {
        cell.icon.image = [UIImage imageNamed:@"LK_wechat_session_icon" inBundle:bundle compatibleWithTraitCollection:nil];
        cell.text.text = @"微信好友";
    } else if ([snsPlatform isEqualToString:LKShareToWechatTimeline]) {
        cell.icon.image = [UIImage imageNamed:@"LK_wechat_timeline_icon" inBundle:bundle compatibleWithTraitCollection:nil];
        cell.text.text = @"微信朋友圈";
    } else if ([snsPlatform isEqualToString:LKShareToQQ]) {
        cell.icon.image = [UIImage imageNamed:@"LK_qq_icon" inBundle:bundle compatibleWithTraitCollection:nil];
        cell.text.text = @"QQ";
    } else if ([snsPlatform isEqualToString:LKShareToQzone]) {
        cell.icon.image = [UIImage imageNamed:@"LK_qzone_icon" inBundle:bundle compatibleWithTraitCollection:nil];
        cell.text.text = @"QQ空间";
    } else if ([snsPlatform isEqualToString:LKShareToWeibo]) {
        cell.icon.image = [UIImage imageNamed:@"LK_sina_icon" inBundle:bundle compatibleWithTraitCollection:nil];
        cell.text.text = @"新浪微博";
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectItem:self.datasoure[indexPath.row]];
}

#pragma mark - gesture
- (void)handleTapParentView:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    CGPoint pointForTargetView = [self.collectionView convertPoint:point fromView:gesture.view];
    
    if (!CGRectContainsPoint(self.collectionView.bounds, pointForTargetView)) {
        [self dismiss:nil];
    }
}

#pragma mark - user action
- (void)selectItem:(NSString *)value {
    __weak typeof(self) weakSelf = self;
    [self dismiss:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.chooseItemBlock) {
            strongSelf.chooseItemBlock(value);
        }
    }];
}

@end
