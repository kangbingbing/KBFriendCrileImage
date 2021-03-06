//
//  KBFriendCirleView.m
//  friendCirle
//
//  Created by kangbing on 16/6/17.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "KBFriendCirleView.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"
#import "YYWebImage.h"
#import "KBPhotoBrowser.h"

#define kMarGin 10

@interface KBFriendCirleView ()<KBPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation KBFriendCirleView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor darkGrayColor];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}


- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    
    if (_imageUrls.count > 9 ) {
        return;  // 大于9 , 就不显示, 必须小于9张
    }
    
    for (long i = _imageUrls.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        // 5个地址, 小于9个, 后面的全部隐藏
        imageView.hidden = YES;
    }
    
    //  如果是0个地址, 就不显示
    if (_imageUrls.count == 0) {
        self.height = 0;
        
        return;
    }
    
    // 根据图片数量订item的宽高
    CGFloat itemW = [self itemWidthForPicPathArray:_imageUrls];
    CGFloat itemH = 0;
    if (_imageUrls.count == 1) {  // 如果是一张, 高度是宽的1.5
        
        itemH = itemW * 1.5;
        
    } else {
        
        // 正方形
        itemH = itemW;
    }
    
    // 返回多少列
    long perRowItemCount = [self perRowItemCountForPicPathArray:_imageUrls];
    CGFloat margin = kMarGin;
    
    [_imageUrls enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        
        imageView.hidden = NO;
        // 显示的imageView赋值
//        [imageView setImageWithURL:[NSURL URLWithString:obj] placeholderImage:nil];
        [imageView yy_setImageWithURL:[NSURL URLWithString:obj] options:YYWebImageOptionProgressive];
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
        
    }];
    
    
    // 这个view的宽和高
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_imageUrls.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
    
    
    
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)sender
{
    KBPhotoBrowser *bro = [[KBPhotoBrowser alloc]init];
    bro.imageCount = self.imageUrls.count;
    bro.delegate = self;
    bro.currentImageIndex = sender.view.tag;
    [bro show];
    
}

#pragma mark 返回item的宽
- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return [UIScreen mainScreen].bounds.size.width / 2;
    } else {
//        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? 110 : 90;
        
        CGFloat w = ([UIScreen mainScreen].bounds.size.width - 2 * kMarGin)/3;
        return w;
    }
}

#pragma mark 返回列数
- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count <= 3) {
        return array.count;
        
    } else if (array.count <= 4) {
        
        return 2;
    } else {
        return 3;
    }
}

#pragma mark  返回图片的地址或者名字
- (void)photoBrowser:(KBPhotoBrowser *)browser andWithCurentImageView:(UIImageView *)curentImageView highImageURLForIndex:(NSInteger)index{
    
    [curentImageView yy_setImageWithURL:[NSURL URLWithString:self.imageUrls[index]] options:YYWebImageOptionProgressive];
    
}






@end
