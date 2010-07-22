//
//  CustomCell.h
//  RSS Reader
//
//  Created by Basav Nagur on 7/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell {
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *colorLabel;
	IBOutlet UIImageView *thumbnailImage ;
}
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *colorLabel;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImage ;


@end
