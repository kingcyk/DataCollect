//
//  FirstViewController.swift
//  DataCollect
//
//  Created by kingcyk on 22/10/2017.
//  Copyright © 2017 kingcyk. All rights reserved.
//

import UIKit
import CoreMotion
import MediaPlayer
import Zip

class FirstViewController: UIViewController {

    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var pedometerView: UIView!
    @IBOutlet weak var placeView: UIView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    
    @IBOutlet weak var pedometerDataLabel: UILabel!
    @IBOutlet weak var pedometerTimeLabel: UILabel!
    
    @IBOutlet weak var dataTextView: UITextView!
    
    let path = Bundle.main.path(forResource: "muzik", ofType: "mp3")
    
    var stepString: String = ""
    
    var documentInteractionController: UIDocumentInteractionController!
    
    var player = AVAudioPlayer()
    var place = 1
    var state = 0
    var stepCount = 0
    let updateInterval = 1.0 / 30
    let motionManager = CMMotionManager()
    
    let motionDataPath = NSHomeDirectory() + "/Documents/motionData.txt"
    let stepDataPath = NSHomeDirectory() + "/Documents/stepData.txt"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.tintColor = tintColor
        
        tabBarController?.tabBar.tintColor = tintColor
        
        pedometerView.backgroundColor = UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 0.54)
        
        dataView.backgroundColor = UIColor(red: 191 / 255, green: 249 / 255, blue: 241 / 255, alpha: 0.16)
        
        mainButton.tintColor = UIColor.black
        mainButton.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        
        setupPlaceButtons()
        
        pedometerTimeLabel.text = "time"
        pedometerDataLabel.text = "\(0)"
        
        dataTextView.layoutManager.allowsNonContiguousLayout = false
        
        roundView(placeView, withCornerRadius: 8)
        roundView(pedometerView, withCornerRadius: 8)
        roundView(dataView, withCornerRadius: 8)
        roundView(mainButton, withCornerRadius: 8)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectMainButton(_ sender: Any) {
        switch state {
        case 0:
            // Start update
            player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            player.numberOfLoops = -1
            player.play()
            UIApplication.shared.beginReceivingRemoteControlEvents()
            self.becomeFirstResponder()
            state = 1
            stepString = ""
            stepCount = 0
            pedometerDataLabel.text = "\(stepCount)"
            dataTextView.text = "Device name: \(deviceName)\nPlace: \(place)\n"
            UIApplication.shared.isIdleTimerDisabled = true
            if motionManager.isDeviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = updateInterval
                motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (data, error) in
                    if let motionData = data {
                        var dataString = "\(dateFormatter.string(from: Date())): "
                        dataString = dataString + String(format: "%.3lf %.3lf %.3lf %.3lf %.3lf %.3lf %.3lf %.3lf %.3lf %.3lf %.3lf %.3lf %.3lf %.3lf %.3lf", motionData.gravity.x, motionData.gravity.y, motionData.gravity.z, motionData.userAcceleration.x, motionData.userAcceleration.y, motionData.userAcceleration.z, motionData.rotationRate.x, motionData.rotationRate.y, motionData.rotationRate.z, motionData.magneticField.field.x, motionData.magneticField.field.y, motionData.magneticField.field.z, motionData.attitude.pitch, motionData.attitude.roll, motionData.attitude.yaw)
                        self.dataTextView.text = self.dataTextView.text + dataString + "\n"
                        self.dataTextView.scrollRectToVisible(CGRect(x: 0, y: self.dataTextView.contentSize.height - 15, width: self.dataTextView.contentSize.width, height: 10), animated: false)
                    }
                })
            }
            mainButton.setTitle("停止", for: .normal)
        case 1:
            // Stop update
            state = 0
            motionManager.stopDeviceMotionUpdates()
            UIApplication.shared.isIdleTimerDisabled = false
            try! dataTextView.text.write(toFile: motionDataPath, atomically: true, encoding: .utf8)
            try! stepString.write(toFile: stepDataPath, atomically: true, encoding: .utf8)
            do {
                let filename = "\(deviceName)_\(dateFormatter.string(from: Date()))"
                let zipFilePath = try Zip.quickZipFiles([URL(fileURLWithPath: motionDataPath), URL(fileURLWithPath: stepDataPath)], fileName: filename)
                documentInteractionController = UIDocumentInteractionController(url: zipFilePath)
                documentInteractionController.presentOptionsMenu(from: view.frame, in: view, animated: true)
            }
            catch {
                print(error.localizedDescription)
            }
            mainButton.setTitle("开始", for: .normal)
        default:
            return
        }
    }
    
    @IBAction func selectButton1(_ sender: Any) {
        place = 1
        refreshState()
    }
    
    @IBAction func selectButton2(_ sender: Any) {
        place = 2
        refreshState()
    }
    
    @IBAction func selectButton3(_ sender: Any) {
        place = 3
        refreshState()
    }
    
    @IBAction func selectButton4(_ sender: Any) {
        place = 4
        refreshState()
    }
    
    @IBAction func selectButton5(_ sender: Any) {
        place = 5
        refreshState()
    }
    
    @IBAction func selectButton6(_ sender: Any) {
        place = 6
        refreshState()
    }
    
    func setupPlaceButtons() {
        refreshState()
        button1.titleLabel?.textAlignment = .center
        button2.titleLabel?.textAlignment = .center
        button3.titleLabel?.textAlignment = .center
        button4.titleLabel?.textAlignment = .center
        button5.titleLabel?.textAlignment = .center
        button6.titleLabel?.textAlignment = .center

        button1.setTitle("""
        左侧衣兜
        屏幕朝向身体
        """, for: .normal)
        button2.setTitle("""
        右侧衣兜
        屏幕朝向身体
        """, for: .normal)

        button3.setTitle("""
        左手握持
        屏幕朝向身体
        """, for: .normal)
        button4.setTitle("""
        右手握持
        屏幕朝向身体
        """, for: .normal)

        button5.setTitle("""
        左侧裤兜
        屏幕朝向身体
        """, for: .normal)
        button6.setTitle("""
        右侧裤兜
        屏幕朝向身体
        """, for: .normal)
    }
    
    func refreshState() {
        switch place {
        case 1:
            resetButtons()
            button1.backgroundColor = tintColor
            button1.setTitleColor(UIColor.black, for: .normal)
        case 2:
            resetButtons()
            button2.backgroundColor = tintColor
            button2.setTitleColor(UIColor.black, for: .normal)
        case 3:
            resetButtons()
            button3.backgroundColor = tintColor
            button3.setTitleColor(UIColor.black, for: .normal)
        case 4:
            resetButtons()
            button4.backgroundColor = tintColor
            button4.setTitleColor(UIColor.black, for: .normal)
        case 5:
            resetButtons()
            button5.backgroundColor = tintColor
            button5.setTitleColor(UIColor.black, for: .normal)
        case 6:
            resetButtons()
            button6.backgroundColor = tintColor
            button6.setTitleColor(UIColor.black, for: .normal)
        default:
            break
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        stepCount += 1
        pedometerView.backgroundColor = pulseActiveColor
        pedometerDataLabel.text = "\(stepCount)"
        pedometerTimeLabel.text = "\(dateFormatter.string(from: Date()))"
        stepString = stepString + "\(dateFormatter.string(from: Date())): Step\n"
        UIView.animate(withDuration: 0.8) {
            self.pedometerView.backgroundColor = pulseNormalColor
        }
    }
    
    func resetButtons() {
        button1.backgroundColor = inactiveColor
        button2.backgroundColor = inactiveColor
        button3.backgroundColor = inactiveColor
        button4.backgroundColor = inactiveColor
        button5.backgroundColor = inactiveColor
        button6.backgroundColor = inactiveColor
        button1.setTitleColor(UIColor.white, for: .normal)
        button2.setTitleColor(UIColor.white, for: .normal)
        button3.setTitleColor(UIColor.white, for: .normal)
        button4.setTitleColor(UIColor.white, for: .normal)
        button5.setTitleColor(UIColor.white, for: .normal)
        button6.setTitleColor(UIColor.white, for: .normal)
        button1.titleLabel?.numberOfLines = 0
        button2.titleLabel?.numberOfLines = 0
        button3.titleLabel?.numberOfLines = 0
        button4.titleLabel?.numberOfLines = 0
        button5.titleLabel?.numberOfLines = 0
        button6.titleLabel?.numberOfLines = 0
    }

}
