//
//  JpMsmcImagecollectionviewImageCollectionView.h
//  tiimagecollectionview
//
//  Created by KATAOKA,Atsushi on 2012/09/23.
//
//

#import <UIKit/UIKit.h>
#import "TiUIView.h"
#import "AQGridView.h"

@interface JpMsmcImagecollectionviewImageCollectionView : TiUIView <AQGridViewDelegate, AQGridViewDataSource>
{
    AQGridView *gridView;
    NSArray *images;
    
    CGSize cellSize;
    CGSize cellPadding;
    
    UIImage *placeHolder;
    UIColor *selectionGlowColor;
    CGFloat selectionGlowRadius;
}

@end
