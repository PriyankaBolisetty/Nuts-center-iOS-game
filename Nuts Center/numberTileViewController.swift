//
//  numberTileViewController.swift
//  Nuts Center
//
//  Created by Priyanka.
//  Copyright © 2016 Priyanka. All rights reserved.
//
//
//  ViewController.swift
//  TileGame
//
//  Created by lena on 3/16/16.
//  Copyright © 2016 lena. All rights reserved.
//

import UIKit
import QuartzCore

class numberTileViewController: UIViewController {
    
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    let aSelector: Selector = "updateTime"
    
    var timerIsRunning = false
    var array = [0]
    var pos = 0
    var action = ""
    
    @IBOutlet var isRun: UIButton!
   
    
    @IBAction func pause(sender: AnyObject) {
        if timer.valid{
            isRun.setTitle("Start", forState: .Normal)
            timer.invalidate()
            timerIsRunning = true
        }else{
            isRun.setTitle("Pause", forState: .Normal)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        }
        
    }
    
    @IBOutlet var displayTimelabel: UILabel!

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

    
    private var gestureStartPoint:CGPoint!
    func updateTime(){
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between currentTime and startTime
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //Calculate the minutes in elapsed time
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //Calculate the seconds in elapsed time
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and milliseconds
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //Concatenate minutes, seconds and milliseconds and assign it to the displayTimeLabel
        displayTimelabel?.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touches:NSSet!
        
        touches = event!.allTouches()
        let touch = touches.anyObject() as! UITouch
        gestureStartPoint = touch.locationInView(self.view)
        if (!timer.valid && !timerIsRunning) {
            let aSelector: Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            timerIsRunning = true
        }
        
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
                action = "right"
            }else{
                movement.text = "right"
                action = "left"
            }
        }else{
            if deltaY > 0 {
                movement.text = "up"
                action = "down"
                
            }else{
                movement.text = "down"
                action = "up"
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
    }
    
    
    func arrayToTile(){
        for i in 0...15 {
            tileTable[i].text = String(array[i])
        }
        pos = array.indexOf(0)!
        tileTable[pos].text = ""
        if check() || checkVerti() {
            //alert
            let title = "CONGRATULATION!"
            let message = "You have solved the puzzle!!\nPress OK to start a new game"
            let okText = "OK"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
            
            alert.addAction(okButton)
            
            presentViewController(alert, animated: true, completion: nil)
            timer.invalidate()
            timerIsRunning = false
            initTile()
        }
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
    
    func checkVerti() -> Bool {
        let verti = [1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 12, 0]
        if verti[verti.count-1] != 0{
            return false
        }
        for i in 0...verti.count-2{
            if verti[i] != i+1 {
                return false
            }
        }
        
        return true
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
        
        initTile()
        updateTile("up")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

