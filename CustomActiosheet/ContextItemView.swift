//
//  ContextItemView.swift
//  CustomActiosheet
//
//  Created by Ashwin Shrestha on 6/11/16.
//  Copyright © 2016 Ashwin Shrestha. All rights reserved.
//

import UIKit
import CoreImage

class ContextItemView: UIView {

    var item: ContextItem?
    var isHighlighted = false
    var titleLabel: UILabel?
    var image: UIImageView?
    var highlightedImage: UIImageView?

    
    init(frame: CGRect, animator: Animator) {
        
        super.init(frame: frame)
        self.frame = frame
        self.createSubView(animator)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    
    }
    
    func createSubView(animator: Animator){
        
        switch animator {
        
        case .SpreadOut:
            
            image = UIImageView(frame: self.frame)
            highlightedImage = UIImageView(frame:self.frame)
        
        case .Vertical:
            
            titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 50))
            self.addSubview(titleLabel!)
            image = UIImageView(frame: CGRectMake(70, 0, 50, 50))
            highlightedImage = UIImageView(frame: image!.frame)
        
        }
        
        self.addSubview(image!)
        highlightedImage?.alpha = 0.0
        self.addSubview(highlightedImage!)
        
    }
    
    func updateView(){
        
        self.updateImage()
        
    }
    
    func updateImage(){
        
        self.image?.image = self.item?.image
        self.highlightedImage?.image = self.item?.highlightedImage
        self.titleLabel?.text = self.item?.title
        self.image?.alpha = ((self.item?.itemEnabled)!) ? 1.0 : 0.3
            
    }
    
}
