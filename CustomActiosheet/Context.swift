//
//  Context.swift
//  CustomActiosheet
//
//  Created by Ashwin Shrestha on 6/11/16.
//  Copyright © 2016 Ashwin Shrestha. All rights reserved.
//

import UIKit

protocol ContextDelegate {
    
    func contextSheet(context: Context, didSelectItem item: ContextItem)

}

enum ViewDirection {
    
    case Up
    case Down

}

enum Animator {
    
    case SpreadOut
    case Vertical

}

enum Position {
    
    case Left
    case Right

}

class Context: UIView {

    var items:[AnyObject]?
    var itemViews:[AnyObject]?
    var delegate: ContextDelegate!
    var radius: Int?
    var rotation:CGFloat?
    var startAngle = 0
    var rangeAngle: CGFloat?
    var backgroundView: UIView!
    var view: UIView?
    
    
    var viewFinishedAnimating = false
    var touchCenter: CGPoint?
    var centerView : UIView!
    var showCenterButton = false
    var animator: Animator?
    var viewDirection: ViewDirection?
    var position: Position?
    var maskCenterView = false
    
    init(){
        
        super.init(frame: UIScreen.mainScreen().bounds)
    
    }
    
    init(withItems items: [AnyObject], animator: Animator) {
        
        super.init(frame: UIScreen.mainScreen().bounds)
        self.items = [AnyObject]()
        self.items = items
        self.animator = animator
        
        radius = getRadius(items.count)
        rangeAngle = 90
        
        createView()
        createGesture()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    
    }
    
    func getRadius(count: Int) -> Int {
        
        if count < 5 {
            return 100
        }
        else if count >= 5{
            return 150
        }
        
        return 150
    }
    func createView(){
        
        backgroundView = UIView(frame: CGRectZero)
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        self.addSubview(backgroundView)
        
        self.itemViews = [AnyObject]()
        
        let frame = CGRectMake(0, 0, 50, 50)
        
        for item in items!{
            
            if let singleItem = item as? ContextItem{
                
                var itemView = ContextItemView(frame: frame, animator: .SpreadOut)
                
                switch self.animator! {
                    
                case .SpreadOut:
                
                    itemView = ContextItemView(frame: CGRect(x: 0, y: 0, width: 50, height: 50),animator:self.animator!)
                    
                case .Vertical:
                    
                    itemView = ContextItemView(frame: CGRect(x: 0, y: 0, width: 120, height: 50),animator:self.animator!)
                }
                
                itemView.item = singleItem
                itemView.updateView()
                self.addSubview(itemView)
                
                self.itemViews?.append(itemView)
                
            }
        }
        
        let sampleItemView = self.itemViews?[0]
        
        centerView = UIView(frame: CGRect(x: 0, y: 0, width: (sampleItemView?.frame.size.width)!, height: (sampleItemView?.frame.size.height)!))
        self.addSubview(centerView)
        centerView.backgroundColor = UIColor.redColor()
        centerView.hidden = false
            
    }
    
    func beginTouch(btn: UIButton, inView:UIView){
        
        self.backgroundView.frame = inView.frame
        self.touchCenter = btn.center
        
        centerView.frame = btn.frame
        
        if maskCenterView{
            
            centerView.layer.cornerRadius = centerView.frame.size.width/2
            centerView.layer.masksToBounds = true
        
        }
        
        
        centerView.hidden = (showCenterButton) ?  false: true
        
        inView.addSubview(self)
        
        switch animator! {
            
            case .SpreadOut:
                createSpreaderRangeAndAngle(btn, inView: inView)
           
            case .Vertical:
                createVerticalRangeAndAngle(btn, inView: inView)
        
        }
        
        self.openView()
        
    }
    
    func endView(){
        
        self.closeSubViews()
       
    }
    
    func closeSubViews(){
        
        var i: Double = 0
        for view in itemViews!{
            
            if let singleitemView = view as? ContextItemView{
                
                UIView.animateWithDuration(0.5,
                                           delay: i * 0.01,
                                           usingSpringWithDamping: 0.45,
                                           initialSpringVelocity: 7.5,
                                           options: UIViewAnimationOptions.CurveEaseIn ,
                                           animations: {
                                            singleitemView.transform = CGAffineTransformMakeScale(0.2, 0.2);
                                           self.updateItemViewToCenter(singleitemView,index: i)
                                            
                                            
                    }, completion: { void in
                        if Int(i) == self.items?.count {
                            self.removeFromSuperview()
                        }
                })
                i+=1
           }
        }

    }
    
    func openView(){
        
        viewFinishedAnimating = false
        var size = CGSize(width: 0, height: 0)
        
        switch animator! {
           
            case .SpreadOut:
                size = CGSize(width: 50, height: 50)
            
            case .Vertical:
                size = CGSize(width: 100, height: 50)
        
        }
        var i: Double = 0.0
        
        for view in itemViews!{
            
            if let singleitemView = view as? ContextItemView{
                
                singleitemView.transform = CGAffineTransformIdentity
                singleitemView.center = self.touchCenter!
                singleitemView.frame.size = CGSize(width: 0, height: 0)
                
                UIView.animateWithDuration(0.5,
                                           delay: i * 0.01,
                                           usingSpringWithDamping: 0.45,
                                           initialSpringVelocity: 7.5,
                                           options: UIViewAnimationOptions.CurveEaseIn ,
                                           animations: {
                                            singleitemView.frame.size = size
                                            self.updateItemViewNotAnimated(singleitemView,touchDistance: 0.0, index: i)
                    
                
                                            }, completion: { void in
                                                self.viewFinishedAnimating = true
                                        })
                i+=1
            }
        }
        
    }
    
}

extension Context{
    
    //MARK: ANIMATION METHODS
    
    func updateItemViewNotAnimated(itemView: ContextItemView, touchDistance: CGFloat, index: Double){
        
        let itemIndex = Double(index)
        
        switch animator! {
        
        case .SpreadOut:
            
            let angle = Double(self.startAngle) + (Double(rangeAngle!)/Double((self.itemViews?.count)! - 1 )) * itemIndex

            let x = (self.touchCenter?.x)! +  (CGFloat(Double(self.radius!) * cos(degreeToRadian(angle))))
            let y = (self.touchCenter?.y)! -  (CGFloat(Double(self.radius!) * sin(degreeToRadian(angle))))
            itemView.center = CGPointMake(x, y)
            
        case .Vertical:
            
            var x = 0.0
            
            switch position! {
            
            case .Left:
                x = Double((self.touchCenter?.x)!/2)  + Double(itemView.frame.size.width/2)
            
            case .Right:
                 x = Double((self.touchCenter?.x)!)  - Double(itemView.frame.size.width/2) + Double(self.centerView.frame.size.width/6)
           
            }
            
            var y = 0.0
            
            switch viewDirection! {
            
            case .Up:
                
                y = Double((self.touchCenter?.y)!) - ((itemIndex + 1) * 55.0)
                
            case .Down:
                y = Double((self.touchCenter?.y)!) + ((itemIndex + 1) * 55.0)
            
            }
            
            itemView.center = CGPointMake(CGFloat(x), CGFloat(y))
        
        }
        
        itemView.tag = Int(index)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        itemView.addGestureRecognizer(gesture)
        
    }
    
    func updateItemViewToCenter(itemView: ContextItemView, index: Double){
        
        itemView.center = self.touchCenter!
    
    }
    
}

extension Context{
    
    //MARK: GESTURE RECOGNIZERS AND INITIALIZERS
    
    
    func createGesture(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.backGroundTapped))
        self.backgroundView.addGestureRecognizer(tapGesture)
        
    }
    
    func backGroundTapped(gesturerecognizer: UITapGestureRecognizer){
        
        self.endView()
    }
    
    func viewTapped(gesture: UITapGestureRecognizer){
        
        let itemNumber = gesture.view?.tag
        let item = self.items?[itemNumber!] as! ContextItem
        
        if item.itemEnabled!{
            
            self.delegate.contextSheet(self, didSelectItem: item)
            self.endView()
        
        }
    }
    
}

extension Context{
    
    //MARK: HELPER FUNCTIONS
    
    func degreeToRadian(degree : Double) -> Double {
        
        let radValue = ( 3.14 / 180 ) * degree
        return radValue
        
    }
    
    func createSpreaderRangeAndAngle(btn: UIButton, inView:UIView){
        
        if ((Double(btn.center.x) - Double(self.radius!)) < Double(inView.frame.origin.x)) {
            
            if (Double(btn.center.y) - Double(self.radius!)) < (Double(inView.frame.origin.y)) {
                
                self.rangeAngle = 90
                self.startAngle = 270
                
            }
            else if (Double(btn.center.y) + Double(self.radius!)) > (Double(inView.frame.size.height)){
                
                self.rangeAngle = 90
                self.startAngle = 0
                
            }
            else{
                
                self.rangeAngle = 180
                self.startAngle = 270
                
            }
            
        }
        else if  ((Double(btn.center.x) + Double(self.radius!)) > Double(inView.frame.size.width)){
            
            if (Double(btn.center.y) - Double(self.radius!)) < (Double(inView.frame.origin.y)) {
                
                self.rangeAngle = 90
                self.startAngle = 180
                
            }
            else if (Double(btn.center.y) + Double(self.radius!)) > (Double(inView.frame.size.height)){
                
                self.rangeAngle = 90
                self.startAngle = 90
                
            }
            else{
                
                self.rangeAngle = 180
                self.startAngle = 90
                
            }
        }
        else{
            
            if (Double(btn.center.y) - Double(self.radius!)) < (Double(inView.frame.origin.y)) {
                
                self.rangeAngle = 180
                self.startAngle  = 180
                
            }
            else if (Double(btn.center.y) + Double(self.radius!)) > (Double(inView.frame.size.height)){
                
                self.rangeAngle = 180
                self.startAngle = 0
                
            }
            else{
                
                self.rangeAngle = 180
                self.startAngle = 0
                
            }
        }
        
    }
    
    func createVerticalRangeAndAngle(btn: UIButton, inView:UIView){
    
        let totalRange: Double = Double((self.items?.count)! * 55)
        
        if (Double(self.touchCenter!.y) - totalRange ) < Double(inView.frame.origin.y){
           
            self.viewDirection = ViewDirection.Down
        
        }
        else{
           
            self.viewDirection = ViewDirection.Up
        
        }
        
        if (Double(self.touchCenter!.x)) < Double(inView.frame.size.width / 2){
            
            self.position = Position.Left
        
        }
        else{
            
            self.position = Position.Right
       
        }
    
    }
    
}
