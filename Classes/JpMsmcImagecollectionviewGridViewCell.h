//
//  JpMsmcImagecollectionviewGridViewCell.h
//  tiimagecollectionview
//
//  Created by KATAOKA,Atsushi on 2012/09/23.
//
//

#import "AQGridViewCell.h"

@interface JpMsmcImagecollectionviewGridViewCell : AQGridViewCell
{
    UIImageView *imageView;
    UIView *imageContentView;
    UIImage *placeholderImage;
}
@property (nonatomic, retain) NSString *url;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)aReuseIdentifier placeholderImage:(UIImage *)aPlaceholderImage;

@end
