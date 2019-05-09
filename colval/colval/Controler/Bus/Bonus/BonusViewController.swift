//
//  BonusViewController.swift
//  colval
//
//  Created by user150454 on 5/7/19.
//  Copyright © 2019 Alexandre Arsenault. All rights reserved.
//
import UIKit
import Foundation


class BonusViewController: UIViewController ,UIScrollViewDelegate{
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    var staireIndex = 1
    @IBOutlet weak var decrease: UIButton!
    
    @IBOutlet weak var increase: UIButton!
    @IBOutlet weak var StaireTitle: UILabel!
    
    
    
    
    
    
    var STAIRE_LEVELS: [String] = ["SOUS SOL","REZ DE CHAUSSÉE","ÉTAGE 1", "ÉTAGE 2","ÉTAGE 3", "ÉTAGE 4","MEZZANINE-1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setView()
        
        
        
        
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 1.0
    }
    
    
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: Selector("handleDoubleTap:"))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    
    
    @IBAction func add(_ sender: Any) {
        self.staireIndex += 1
        setView()
        if (self.staireIndex < 6){
            decrease.isHidden = false
        }else
        {
          increase.isHidden = true
        }
    }
    
    
    
    @IBAction func remove(_ sender: Any) {
        self.staireIndex -= 1
        setView()
        if (self.staireIndex < 1){
            decrease.isHidden = true
        }else{
            increase.isHidden = false
        }
    }
    
    func setView() {
        
        if ( scrollView != nil) {
        scrollView.removeFromSuperview()
        // scrollView.addSubview(UIImageView(image: UIImage(named: STAIRE_LEVELS[staireIndex])))
        
        self.scrollView.zoomScale = 1
        
        }
        
        increase.layer.zPosition = 10;
        decrease.layer.zPosition = 10;
        
        imageView = UIImageView(image: UIImage(named: STAIRE_LEVELS[staireIndex]))
        StaireTitle.text = STAIRE_LEVELS[staireIndex]
        
        scrollView = UIScrollView(frame: view.bounds)
        
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        
        scrollView.contentOffset = CGPoint(x: 500, y: 450)
        scrollView.addSubview(imageView)
        scrollView.layer.zPosition = -55
        self.view.addSubview(scrollView)
        self.view.addSubview(increase)
        self.view.addSubview(decrease)
        self.view.addSubview(StaireTitle)
        self.view.layer.zPosition = -55;
        
        
        setZoomScale()
        setupGestureRecognizer()
    }
    

    
    
    
}
