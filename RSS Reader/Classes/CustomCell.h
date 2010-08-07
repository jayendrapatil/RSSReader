#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell {
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *colorLabel;
	IBOutlet UIView *thumbnailImage ;
}
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *colorLabel;
@property (nonatomic, retain) IBOutlet UIView *thumbnailImage ;


@end
