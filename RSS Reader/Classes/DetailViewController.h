//
//  DetailViewController.h
//  RSS Reader
//
//  Created by Basav Nagur on 7/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController {
	
	IBOutlet UIWebView *webView ;
	IBOutlet UILabel *lblText;
	NSString *link ;

}

@property (nonatomic, retain) IBOutlet UIWebView *webView ;
@property (nonatomic, retain) NSString *link ;

@end
