//
//  ViewController.m
//  camera
//
//  Created by Zhengxq on 14-1-22.
//  Copyright (c) 2014年 Zhengxq. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

static CGRect oldframe;
static UIImageView *photoView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *photoButton = [[UIButton alloc]initWithFrame:CGRectMake(15,25, 100, 20)];
    
    
    photoButton.backgroundColor = [UIColor redColor];
    [photoButton setTitle:@"Click me" forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(selImgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoButton];
    photoView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 55, 60, 60)] ;
    photoView.backgroundColor = [UIColor clearColor];
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:photoView];
    //    UIButton *photoViewButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 60, 60, 60)];
    //    [self.view addSubview:photoViewButton];
    //    if(photoView.image)
    //    {
    //
    //
    //
    //    [photoViewButton addTarget:self action:@selector(magnifyImage:) forControlEvents:UIControlEventTouchUpInside];
    //
    //          }
    //    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    //    tap.cancelsTouchesInView=NO;
    //    [photoView addGestureRecognizer:tap];
    
}
- (void)magnifyImage:(id)sender
{
    NSLog(@"局部放大");
    [self showImage:photoView];//调用方法
}

- (void)selImgBtnClicked:(id)sender
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"相片来源"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"相机拍摄", @"手机相册", nil];
    [menu showInView:self.view];
}

#pragma mark UIActionSheetDelegate implementation
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            // 相机拍摄
        case 0:
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable:sourceType])
            {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
                imagePickerController.sourceType = sourceType;
                imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                imagePickerController.allowsEditing = YES;
                imagePickerController.delegate = self;
                [self presentModalViewController:imagePickerController animated:YES];
            }
            break;
        }
            // 手机相册
        case 1:
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if ([UIImagePickerController isSourceTypeAvailable:sourceType])
            {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
                imagePickerController.sourceType = sourceType;
                imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                imagePickerController.allowsEditing = YES;
                imagePickerController.delegate = self;
                [self presentModalViewController:imagePickerController animated:YES];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark UIImagePickerControllerDelegate implementation
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    photoView.image = image;
    
    [picker dismissModalViewControllerAnimated:YES];
    UIButton *photoViewButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 55, 60, 60)];
    [self.view addSubview:photoViewButton];
    if(photoView.image)
    {
        
        
        
        [photoViewButton addTarget:self action:@selector(magnifyImage:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}


-(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
