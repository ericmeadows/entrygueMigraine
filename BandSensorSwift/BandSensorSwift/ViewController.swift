//
//  ViewController.swift
//  BandSensorSwift
//
//  Created by Mark Thistle on 4/7/15.
//  Copyright (c) 2015 New Thistle LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MSBClientManagerDelegate {
    
    @IBOutlet weak var txtOutput: UITextView!
    @IBOutlet weak var debugPrintShit: UILabel!
    @IBOutlet weak var accelLabel: UILabel!
//    @IBOutlet var hrSensorButton:  UIButton!
    
    var destinationPath: String! = NSTemporaryDirectory() + "tempSensorDump.txt"
    weak var client: MSBClient?
    var accStrings = [String]()
    var airTempStrings = [String]()
    var baroPressureStrings = [String]()
    var hrStrings = [String]()
    var srStrings = [String]()
    var stStrings = [String]()
    var uvStrings = [String]()
    var timeData = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MSBClientManager.sharedManager().delegate = self
        if let client = MSBClientManager.sharedManager().attachedClients().first as? MSBClient {
            self.client = client
            MSBClientManager.sharedManager().connectClient(self.client)
            self.output("Please wait. Connecting to Band...")
        } else {
            self.output("Failed! No Bands attached.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//    @IBAction func didTapStartHRSensorButton(sender: AnyObject) {
//        markSampleReady(false)
//        if let client = self.client {
//            if client.sensorManager.heartRateUserConsent() == MSBUserConsent.Granted {
//                startHeartRateUpdates()
//            } else {
//                output("Requesting user consent for accessing HeartRate...")
//                client.sensorManager.requestHRUserConsentWithCompletion( { (userConsent: Bool, error: NSError!) -> Void in
//                    if userConsent {
//                        self.startHeartRateUpdates()
//                    } else {
//                        self.sampleDidCompleteWithOutput("User consent declined.")
//                    }
//                })
//            }
//        }
//    }
    
//    func startHeartRateUpdates() {
//        output("Starting Heart Rate updates...")
//        if let client = self.client {
//            do {
//                try client.sensorManager.startHeartRateUpdatesToQueue(nil, withHandler: { (heartRateData: MSBSensorHeartRateData!, error: NSError!) in
//                    self.hrStrings.append(String(format: "Heart Rate: %3u %@",
//                        heartRateData.heartRate,
//                        heartRateData.quality == MSBSensorHeartRateQuality.Acquiring ? "Acquiring" : "Locked") as String)
//                })
//                self.performSelector(Selector("stopHeartRateUpdates"), withObject: nil, afterDelay: 60)
//            } catch let error as NSError {
//                output("startHeartRateUpdatesToQueue failed: \(error.description)")
//            }
//        } else {
//            output("Client not connected, can not start heart rate updates")
//        }
//    }
//    
//    func stopHeartRateUpdates() {
//        if let client = self.client {
//            do {
//                try client.sensorManager.stopHeartRateUpdatesErrorRef()
//            } catch let error as NSError {
//                output("stopHeartRateUpdatesErrorRef failed: \(error.description)")
//            }
//            sampleDidCompleteWithOutput("Heart Rate updates stopped...")
//        }
//    }
    
//    func sampleDidCompleteWithOutput(output: String) {
//        self.output(output)
//        markSampleReady(true)
//    }
    
//    func markSampleReady(ready: Bool) {
//        self.hrSensorButton.enabled = ready
//        self.hrSensorButton.alpha = ready ? 1.0 : 0.2
//    }

    @IBAction func startTesting(sender: AnyObject) { //I NEED TO RESET ARRAYS here!
        if let client = self.client {
            if client.isDeviceConnected == false {
                self.output("Band is not connected. Please wait....")
                return
            }
            
            // Fetch heart rate readings
            
            // Fetch accelerometer readings
            try! client.sensorManager.startAccelerometerUpdatesToQueue(nil, withHandler: { (accelerometerData: MSBSensorAccelerometerData!, error: NSError!) in
//                if (self.accStrings.count == 64) {
//                    self.accStrings.removeAll()
//                }
                    self.accStrings.append(String(format: "%+0.2f,%+0.2f,%+0.2f", accelerometerData.x, accelerometerData.y, accelerometerData.z) as String) // Log Rate not adjustable on iOS
            })
            
            // Fetch skin temperature readings
            try! client.sensorManager.startSkinTempUpdatesToQueue(nil, withHandler: {
                (skinTempData:  MSBSensorSkinTemperatureData!, error: NSError!) in
                    self.stStrings.append(String(format: "%+0.3f", skinTempData.temperature))
            })
            
            // Fetch UV exposure readings
            try! client.sensorManager.startUVUpdatesToQueue(nil, withHandler: {
                (uvData: MSBSensorUVData!, error: NSError!) in
                    self.uvStrings.append(String(format: "%@",String(uvData.uvIndexLevel.rawValue)))
            })
            
            // Fetch Galvanic Skin Resistance readings
            try! client.sensorManager.startGSRUpdatesToQueue(nil, withHandler: {
                (skinResistanceData: MSBSensorGSRData!, error: NSError!) in
                print(skinResistanceData.resistance)
                self.srStrings.append(String(format: "%8u", skinResistanceData.resistance))
            })
            
//            NSError *stateError;
//            if (![self.client.sensorManager startGSRUpdatesToQueue:nil errorRef:&stateError withHandler:handler])
//            {
//                [self sampleDidCompleteWithOutput:stateError.description];
//                return;
//            }
//            
//            [self performSelector:@selector(stopGSRUpdates) withObject:nil afterDelay:40];
            
            // Fetch ambient light readings
//            try! client.sensorManager.startAmbientLightUpdatesToQueue(nil, withHandler: {
//                (lightData: MSBSensorAmbientLightData!, error: NSError!) in
//                if (error == nil) {
//                    self.srStrings.append(String(format: "%d",lightData.brightness))
//                }
//            })

            // Fetch barometer readings
//            try! client.sensorManager.startBarometerUpdatesToQueue(nil, withHandler:  {
//                (barometerData:  MSBSensorBarometerData!, error:  NSError!) in
//                if (error != nil) {
//                    print("dang BAROMETER")
//                }
//                else {
//                    self.baroPressureStrings.append(String(format: "%+0.3f",barometerData.airPressure))
//                    self.airTempStrings.append(String(format: "%+0.3f",barometerData.airPressure))
//                }
//            })
            
            //Stop stream updates after 30 seconds
            let delay = 30.0 * Double(NSEC_PER_SEC)
            var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                self.output("Stopping Accelerometer updates...")
                if let client = self.client {
                    try! client.sensorManager.stopAccelerometerUpdatesErrorRef()
//                    try! client.sensorManager.stopAmbientLightUpdatesErrorRef()
                    try! client.sensorManager.stopCaloriesUpdatesErrorRef()
                    try! client.sensorManager.stopDistanceUpdatesErrorRef()
                    try! client.sensorManager.stopGyroscopeUpdatesErrorRef()
                    try! client.sensorManager.stopPedometerUpdatesErrorRef()
                    try! client.sensorManager.stopBandContactUpdatesErrorRef()
//                    try! client.sensorManager.stopRRIntervalUpdatesErrorRef()
//                    try! client.sensorManager.stopGSRUpdatesErrorRef()
//                    try! client.sensorManager.stopHeartRateUpdatesErrorRef()
                    try! client.sensorManager.stopSkinTempUpdatesErrorRef()
//                    try! client.sensorManager.stopBarometerUpdatesErrorRef()
                    try! client.sensorManager.stopUVUpdatesErrorRef()
                }
//                self.printFileLog()
                print(self.accStrings)
                print(self.airTempStrings)
                print(self.baroPressureStrings)
                //                print(self.hrStrings)
                print(self.srStrings)
                print(self.stStrings)
                print(self.uvStrings)
            })
        } else {
            self.output("Band is not connected. Please wait....")
        }
    }
    
    func output(message: String) {
        self.txtOutput.text = NSString(format: "%@\n%@", self.txtOutput.text, message) as String
        let p = self.txtOutput.contentOffset
        
        self.txtOutput.setContentOffset(p, animated: false)
        self.txtOutput.scrollRangeToVisible(NSMakeRange(self.txtOutput.text.lengthOfBytesUsingEncoding(NSASCIIStringEncoding), 0))
    }
    
    // Output data to log file
    func logToFile(logString: String) {
        // For logging purposes
//        self.destinationPath = NSTemporaryDirectory() + "tempSensorDump.txt"
        //        var error:NSError?
        let written = try! logString.writeToFile(self.destinationPath, atomically: true, encoding: NSUTF8StringEncoding)
    }
    
    // For testing:  file logging
    func printFileLog() {
    // Line by line printing of file
        print("File exists")
        var data = try! String(contentsOfFile:self.destinationPath, encoding: NSUTF8StringEncoding)
        if let content = String?(data){
            print("String exists")
            let myStrings = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            self.txtOutput.text = NSString(format: "%@\n%@", self.txtOutput.text, myStrings[0]) as String
            let p = self.txtOutput.contentOffset
            print(myStrings)
            print("")
            print(myStrings[0])
        }
        
        
        
        self.debugPrintShit.text? = self.destinationPath
        let readFile:NSString? = try! NSString(contentsOfFile: self.destinationPath, encoding: NSUTF8StringEncoding)
        if let fileContents = readFile {
            self.accelLabel.text = "FUCKING WIN"
//            self.output(fileContents as String)
        }
        else {
            self.txtOutput.text = "I fucked up!!!"
        }
        let p = self.txtOutput.contentOffset
        self.txtOutput.setContentOffset(p, animated: false)
        self.txtOutput.scrollRangeToVisible(NSMakeRange(self.txtOutput.text.lengthOfBytesUsingEncoding(NSASCIIStringEncoding), 0))
    }
    
    // Mark - Client Manager Delegates
    func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
        self.output("Band connected.")
    }
    
    func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
        self.output(")Band disconnected.")
    }
    
    func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
        self.output("Failed to connect to Band.")
        self.output(error.description)
    }
}

