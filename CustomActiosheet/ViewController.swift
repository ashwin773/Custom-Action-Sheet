//
//  ViewController.swift
//  CustomActiosheet
//
//  Created by Ashwin Shrestha on 6/11/16.
//  Copyright © 2016 Ashwin Shrestha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /*
     decleare context for buttons for which we want customized actionSheet
    */
    
    var  contextBtnCenter: Context?
    
    
    @IBOutlet weak var middleBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //creating Context for the button
        self.createContext()
        
    }
    
    
    @IBAction func btnClick(sender: UIButton) {
        
        //All the Button have same clickevtn method here... so using tag to differentiate
        
        let tag = sender.tag
        
        switch tag {
            
        case 5:
            
            self.contextBtnCenter?.beginTouch(middleBtnOutlet, inView: self.view)
     
        default:
            break
        }
    
    }
}


extension ViewController:ContextDelegate{
    
    //All the customization for the action sheet here
    
    func createContext(){
        
        // giving button Items for the Context button
        
        let item1 = ContextItem(withTitle: "Mail", image: UIImage(named: "mail.png")!, highlightedImage: UIImage(named: "mail.png")!)
        item1.itemEnabled = true
        
        let item2 = ContextItem(withTitle: "Gift", image: UIImage(named: "gift")!, highlightedImage: UIImage(named: "gift")!)
        item2.itemEnabled = false
        
        let item3 = ContextItem(withTitle: "Share", image: UIImage(named: "share")!, highlightedImage: UIImage(named: "share")!)
        item3.itemEnabled = false
        
        let item4 = ContextItem(withTitle: "Camera", image: UIImage(named: "camera")!, highlightedImage: UIImage(named: "camera")!)
        item4.itemEnabled = true
        
        let item5 = ContextItem(withTitle: "Camera", image: UIImage(named: "camera")!, highlightedImage: UIImage(named: "camera")!)
        item5.itemEnabled = true
        
        let item6 = ContextItem(withTitle: "Camera", image: UIImage(named: "camera")!, highlightedImage: UIImage(named: "camera")!)
        item6.itemEnabled = true
        let item7 = ContextItem(withTitle: "Camera", image: UIImage(named: "camera")!, highlightedImage: UIImage(named: "camera")!)
        item7.itemEnabled = true

        // Making button array for the context button
        var itemArrayforCenterBtn = [AnyObject]()
        
        
        itemArrayforCenterBtn.append(item1)
        itemArrayforCenterBtn.append(item2)
        itemArrayforCenterBtn.append(item3)
        itemArrayforCenterBtn.append(item4)
        itemArrayforCenterBtn.append(item5)
        itemArrayforCenterBtn.append(item6)
        itemArrayforCenterBtn.append(item7)
        
        // creating Button object with the sub Buttons array and animation type
        /*
         Animation type available:
         
         Animator.Vertical
         Animator.SpreadOut
         
         */
        
        contextBtnCenter = Context(withItems: itemArrayforCenterBtn,animator: Animator.SpreadOut)
        
        contextBtnCenter?.showCenterButton = false
        contextBtnCenter?.maskCenterView = false
        self.contextBtnCenter?.delegate = self
        
    }
    
    func contextSheet(context: Context, didSelectItem item: ContextItem) {
       
        switch context {
        
        case contextBtnCenter!:
            print("center button pressed and sub menu btn title is \(item.title!)")
            
        default:
            break
        }
        
    }
    
}

