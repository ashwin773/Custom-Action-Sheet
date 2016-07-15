//
//  ContextItem.swift
//  CustomActiosheet
//
//  Created by Ashwin Shrestha on 6/11/16.
//  Copyright © 2016 Ashwin Shrestha. All rights reserved.
//

import UIKit

class ContextItem: NSObject {
    
    var title:String?
    var image: UIImage?
    var highlightedImage: UIImage?
    var itemEnabled: Bool?
    
    init(withTitle title: String, image: UIImage, highlightedImage: UIImage) {
        
        self.title = title
        self.image = image
        self.highlightedImage = highlightedImage
        self.itemEnabled = true
        
        super.init()
    
    }
}
