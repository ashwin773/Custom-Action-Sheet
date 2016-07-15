# CustomActionSheet

Custom ActionSheet in an IOs Library, where you can pass a button and your view and specify the type of Animaton (SpreadOut or Vertical) for the items to pass as ActionSheet items for the button.

##steps:

###step 1: Create Context for Button
```
var contextSheetTopLeft: Context?

```



```
  let item1 = ContextItem(withTitle: "Mail", image: UIImage(named: "mail.png")!, highlightedImage: UIImage(named: "mail.png")!)
  item1.itemEnabled = true
        
  let item2 = ContextItem(withTitle: "Gift", image: UIImage(named: "gift")!, highlightedImage: UIImage(named: "gift")!)
  item2.itemEnabled = false
        
  let item3 = ContextItem(withTitle: "Share", image: UIImage(named: "share")!, highlightedImage: UIImage(named: "share")!)
  item3.itemEnabled = false
        
  let item4 = ContextItem(withTitle: "Camera", image: UIImage(named: "camera")!, highlightedImage: UIImage(named: "camera")!)
  item4.itemEnabled = true

  var itemsArrayforTopLeftBtn = [AnyObject]()
  itemsArrayforTopLeftBtn.append(item1)
  itemsArrayforTopLeftBtn.append(item2)
  itemsArrayforTopLeftBtn.append(item3)
  itemsArrayforTopLeftBtn.append(item4)
  
  contextSheetTopLeft = Context(withItems: itemsArrayforTopLeftBtn,animator: Animator.SpreadOut)
  contextSheetTopLeft?.showCenterButton = true
  contextSheetTopLeft?.maskCenterView = true
  contextSheetTopLeft?.centerView.backgroundColor = UIColor.blueColor()
  
  self.contextSheetTopLeft?.delegate = self 
  
  
```

###Step 2: On Button Click

```
  self.contextSheetTopLeft?.beginTouch(BtnOutlet, inView: self.view)

```

####Step 3: Maintain the option Click Delegate Function

```
extension ViewController:ContextDelegate{
    func contextSheet(context: Context, didSelectItem item: ContextItem) {
       
      switch context {
        case contextSheetTopLeft!:
            print("top left button pressed and sub menu btn title is \(item.title!)")
        default:
            break
        }
        
    }
  }
```

![alt text](https://github.com/ashwin773/CustomActionSheet/blob/master/1.png "Main Screen")

![alt text](https://github.com/ashwin773/CustomActionSheet/blob/master/2.png "Vertical Action Sheet")

![alt text](https://github.com/ashwin773/CustomActionSheet/blob/master/3.png "Spread Out Animation")
