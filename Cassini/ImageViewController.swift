//
//  ImageViewController.swift
//  Cassini
//
//  Created by Sneh on 04/09/18.
//  Copyright © 2018 The Gateway Corp. All rights reserved.
//

import UIKit

class ImageViewController: VCLLoggingViewController, UIScrollViewDelegate {
    
    //Its a MODEL here...
    var imageURL: URL? {
        didSet
        {
            //            imageView.image = nil
            //            imageView.sizeToFit()
            //            scrollView.contentSize = imageView.frame.size
            //
            
            image = nil
            
            // IF any view is on screen than it has window var on it
            if view.window != nil{
                fetchImage()
            }
        }
    }
    
    //In order to remove redundancy,
    private var image: UIImage? {
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            //HERE we used option chaining on scroll view coz, prog was crashed when we prepared for segued before the
            // Outlet was connected.. i.e. err was found nil while unwrapping the optional...
            scrollView?.contentSize = imageView.frame.size
            
            //MARK: TURN off spinner
            spinner?.stopAnimating() //Whenever image sets actually, stop animating it.
        }
    }
    
    // IF view is not on screen, but eventually when it will be on screen then do this...
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil{
            fetchImage()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //When scrollView gets hooked up, add imageView as subView
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var imageView = UIImageView()
    
    private func fetchImage() {
        
        if let url = imageURL{
            //MARK: TURN on spinner
            spinner.startAnimating()
//            do{
//            let urlContents = try Data(contentsOf: url)
//            } catch let error {}
            
            //
            // NOTE : Here we used weak self although we dont have memory cycle here i.e self -> closure nd vice versa...
            //        But if the network req made by the self takes long time to run closure code nd if the user just taps anywhere else i.e.
            //        stop n/w req. to happen than closure keeps self in heap memory so making self weak wont keep it in heap unless anybody
            //        else it fetches image over network
            
            //Means dispatch this closure/thread/Queue in background to fetch image over n/w
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                // There may be network or server time out err so can handle by above code but we dont care here
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL{
                        // data can be JPEG / PNG data
                        self?.image = UIImage(data: imageData) //IT is ui related task so dispatch it back to main queue
                    }
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // First time when imageURL will be nil then load the default image here...
//        if imageURL == nil{
//            imageURL = DemoURLs.stanford
//        }
    }
}
