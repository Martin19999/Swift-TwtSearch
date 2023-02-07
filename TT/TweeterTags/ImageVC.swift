//
//  ImageVC.swift
//  TweeterTags
//
//  Created by ActualChilli on 2022/11/30.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
        }
    }
    
    
    private var imageView = UIImageView()
    
    var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            imageView.frame = CGRect(origin: .zero, size: CGSize(width: CGFloat((image?.cgImage!.width)!), height: (view.safeAreaLayoutGuide.layoutFrame.size.height*0.8)))
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.reloadInputViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
}
