//
//  pictureTileViewController.swift
//  Nuts Center
//
//  Created by lena on 3/28/16.
//  Copyright © 2016 lena. All rights reserved.
//
//  ViewController.swift
//  TileGame
//
//  Created by lena on 3/16/16.
//  Copyright © 2016 lena. All rights reserved.
//

import UIKit
import QuartzCore

class pictureTileViewController: UIViewController {
    
    
    @IBOutlet var hitview: UIImageView!
    @IBOutlet var tileTable:[UILabel]!
    
    @IBOutlet var cell1: UILabel!
    @IBOutlet var cell2: UILabel!
    @IBOutlet var cell3: UILabel!
    @IBOutlet var cell4: UILabel!
    @IBOutlet var cell5: UILabel!
    @IBOutlet var cell6: UILabel!
    @IBOutlet var cell7: UILabel!
    @IBOutlet var cell8: UILabel!
    @IBOutlet var cell9: UILabel!
    @IBOutlet var cell10: UILabel!
    @IBOutlet var cell11: UILabel!
    @IBOutlet var cell12: UILabel!
    @IBOutlet var cell13: UILabel!
    @IBOutlet var cell14: UILabel!
    @IBOutlet var cell15: UILabel!
    @IBOutlet var cell16: UILabel!
    
    
    @IBOutlet var movement: UILabel!
    var array = [0]
    var pos = 0
    var action = ""
    
    private var gestureStartPoint:CGPoint!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touches:NSSet!
        
        touches = event!.allTouches()
        let touch = touches.anyObject() as! UITouch
        gestureStartPoint = touch.locationInView(self.view)
        
    }
    
    
    override func touchesMoved(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        let touches = event!.allTouches() as NSSet!
        let touch = touches.anyObject() as! UITouch
        let currentPosition = touch.locationInView(self.view)
        
        let deltaX = Float(gestureStartPoint.x - currentPosition.x)
        let deltaY = Float(gestureStartPoint.y - currentPosition.y)
        
        pos = array.indexOf(0)!
        if abs(deltaX) > abs(deltaY){
            if deltaX > 0 {
                movement.text = "left"
                //updateTile("right")
                action = "right"
                //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(10*NSEC_PER_SEC)), dispatch_get_main_queue(), {})
            }else{
                movement.text = "right"
                //updateTile("left")
                action = "left"
                //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(10*NSEC_PER_SEC)), dispatch_get_main_queue(), {})
            }
        }else{
            if deltaY > 0 {
                movement.text = "up"
                //updateTile("down")
                action = "down"
                //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(10*NSEC_PER_SEC)), dispatch_get_main_queue(), {})
                
            }else{
                movement.text = "down"
                //updateTile("up")
                action = "up"
                //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(10*NSEC_PER_SEC)), dispatch_get_main_queue(), {})
            }
            
        }
        
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        updateTile(action)
        action = ""
    }
    
    
    //randomize.
    func initTile(){
        for i in 1...15 {
            array.append(i)
        }
        
        for i in 0...15 {
            let j = Int(arc4random_uniform(UInt32(16 - i))) + i
            guard i != j else { continue }
            swap(&array[i], &array[j])
        }
        arrayToTile()
        updateTileImage()
    }
    
    
    func arrayToTile(){
        for i in 0...15 {
            tileTable[i].text = String(array[i])
            
        }
        //pos = array.indexOf(0)!
        //tileTable[pos].text=""
        if check() {
            //alert
            let title = "CONGRATULATION!"
            let message = "You have solved the puzzle!!\nPress OK to start a new game"
            let okText = "OK"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
            
            alert.addAction(okButton)
            
            presentViewController(alert, animated: true, completion: nil)
            initTile()
        }
        updateTileImage()
    }
    
    func updateTile( action:String ){
        if( action == "left"){
            if(pos % 4 != 0 ){
                swap( &array[pos], &array[pos-1])
                arrayToTile()
            }
            return
        }
        if( action == "right"){
            if(pos % 4 != 3 ){
                swap( &array[pos], &array[pos+1])
                arrayToTile()
            }
            return
        }
        if action == "up" {
            if(![0,1,2,3].contains(pos)){
                swap( &array[pos], &array[pos-4])
                arrayToTile()
            }
            return
        }
        
        if action == "down" {
            if(![12,13,14, 15].contains(pos)){
                swap( &array[pos], &array[pos+4])
                arrayToTile()
            }
            return
        }
        
        
    }
    
    func check() -> Bool {
        if array[array.count-1] != 0{
            return false
        }
        for i in 0...array.count-2{
            if array[i] != i+1 {
                return false
            }
        }
        return true
    }
    
    var goImage = [
        "Image.jpeg", "Image1.jpeg","Image2.jpeg","Image3.jpeg",
        "Image4.jpeg","Image5.jpeg","Image6.jpeg","Image7.jpeg",
        "Image8.jpeg","Image9.jpeg","Image10.jpeg","Image11.jpeg",
        "Image12.jpeg","Image13.jpeg","Image14.jpeg","Image15.png"
    ]
    var viewImage = [
        "IMG_2638-0-0.jpeg","IMG_2638-0-1.jpeg","IMG_2638-0-2.jpeg","IMG_2638-0-3.jpeg",
        "IMG_2638-1-0.jpeg","IMG_2638-1-1.jpeg","IMG_2638-1-2.jpeg","IMG_2638-1-3.jpeg",
        "IMG_2638-2-0.jpeg","IMG_2638-2-1.jpeg","IMG_2638-2-2.jpeg","IMG_2638-2-3.jpeg",
        "IMG_2638-3-0.jpeg","IMG_2638-3-1.jpeg","IMG_2638-3-2.jpeg","Image15.png"
    ]
    
    
    func updateTileImage(){
        for tile in tileTable {
            
            let name = goImage[ (Int(tile.text!)!+15)%16]
            let hasAlpha = true
            let image = UIImage(named: name)
            //var imgSize = tile.frame.size;
            //print(self.view.frame.size.width)
            //if(imgSize.width > 80){
                let size = ((self.view.frame.size.width - 15 - 40) / 4 ) - (0.024 * self.view.frame.size.width)
                let imgSize = CGSize(width: size, height: size);
            //}
            
            let scale: CGFloat = 0.0
            UIGraphicsBeginImageContextWithOptions(imgSize, !hasAlpha, scale)
            image!.drawInRect(CGRect(origin: CGPointZero, size: imgSize))
            let newimage = UIGraphicsGetImageFromCurrentImageContext()
            tile.backgroundColor = UIColor(patternImage: newimage!)
            tile.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0 )
            //tile.hidden = false;
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cell1.layer.cornerRadius = 10
        cell2.layer.cornerRadius = 10
        cell3.layer.cornerRadius = 10
        cell4.layer.cornerRadius = 10
        cell5.layer.cornerRadius = 10
        cell6.layer.cornerRadius = 10
        cell7.layer.cornerRadius = 10
        cell8.layer.cornerRadius = 10
        cell9.layer.cornerRadius = 10
        cell10.layer.cornerRadius = 10
        cell11.layer.cornerRadius = 10
        cell12.layer.cornerRadius = 10
        cell13.layer.cornerRadius = 10
        cell14.layer.cornerRadius = 10
        cell15.layer.cornerRadius = 10
        cell16.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view, typically from a nib.
        //initTile()
        //updateTileImage()
        initTile()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        updateTile("up")
        updateTile("down")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

