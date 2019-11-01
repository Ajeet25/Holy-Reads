//
//  ListinMusicVC.swift
//  Holy Reads
//
//  Created by mac-14 on 03/09/19.
//  Copyright © 2019 Ajeet singh Rawat. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import MediaPlayer

class ListinMusicVC: UIViewController, UITableViewDataSource, UITableViewDelegate,AVAudioPlayerDelegate {
    
    //MARK :- Outlets
    
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblBookTitle: UILabel!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet var viewPlaylist: UIView!
    @IBOutlet weak var tblPlaylist: UITableView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var musicPlayerSlider: UISlider!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    
    //MARK :- Variable
    var dictBookDetails = [String: Any]()
    var audioPlayer:AVAudioPlayer! = nil
    var currentAudioPath:URL!
    var audioLength = 0.0
    var audioData = Data()
    var timer:Timer!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        DispatchQueue.main.async { () -> Void in
            self.setBookDetails()
            // self.playAudio()
            if self.audioPlayer.isPlaying{
                self.showHud()
                self.btnPlay.setImage(#imageLiteral(resourceName: "ic_pause_circle_filled"), for: .normal)
            } else{
                self.clearHud()
                self.btnPlay.setImage(#imageLiteral(resourceName: "play_music"), for: .normal)
            }
        }
    }
    
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewPlaylist.addGestureRecognizer(tap)
    }
    
    
    func setBookDetails() {
        if let title =  dictBookDetails["book_title"] as? String{
            lblBookTitle.text = title
        }
        if let author =  dictBookDetails["author"] as? String{
            lblAuthor.text = author
        }
        if let bookThumbnail =  dictBookDetails["cover_image"] as? String {
            self.imgBook.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imgBook.startAnimating()
            let url = URL.init(string: bookThumbnail)
            self.imgBook.sd_setImage(with: url, placeholderImage: UIImage.init(named: ""), options: .refreshCached, completed: { (img, error, cacheType, url) in
            })
            self.imgCover.sd_setImage(with: url, placeholderImage: UIImage.init(named: ""), options: .refreshCached, completed: { (img, error, cacheType, url) in
            })
            self.imgBook.stopAnimating()
        }
        if let audioUrl = dictBookDetails["audio"] as? [[String:Any]]{
            if let dictAudio = audioUrl[0] as? [String:Any] {
                if let strAudioUrl = dictAudio["audio"] as? String{
                    let mediaUrl =  URL.init(string: strAudioUrl)
                    audioData = try! Data.init(contentsOf: mediaUrl!)
                }
            }
        }
        self.prepareMusicPlayer()

    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.viewPlaylist.removeFromSuperview()
    }
    
    // MARK: - NavigationBar Buttons
    @IBAction func btnBack_DidSelect(_ sender: Any) {
        self.stopTimer()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - IBAction
    
    @IBAction func btnShowMusicList_DidSelect(_ sender: UIButton) {
        viewPlaylist.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight)
        self.view.addSubview(viewPlaylist)
    }
    
    @IBAction func btnSkipBackword30SecondsPressed(_ sender: UIButton) {
        let seekDuration: Float64 = 30
        let duration  = audioPlayer.duration
        let playerCurrentTime = audioPlayer!.currentTime
        let newTime = playerCurrentTime - seekDuration
        if newTime < duration {
            audioPlayer.currentTime = newTime
        }
    }
    
    @IBAction func btnSkipForward30SecondsPressed(_ sender: UIButton) {
        let seekDuration: Float64 = 30
        let duration  = audioPlayer.duration
        let playerCurrentTime = audioPlayer!.currentTime
        let newTime = playerCurrentTime + seekDuration
        if newTime < duration {
            audioPlayer.currentTime = newTime
        }
    }
    @IBAction func btnNext(_ sender: UIButton) {
        
    }
    @IBAction func btnPrev(_ sender: UIButton) {
        
    }
    @IBAction func btnPlay(_ sender: UIButton) {
        if audioPlayer.isPlaying{
            pauseAudio()
            btnPlay.setImage(#imageLiteral(resourceName: "play_music"), for: .normal)
        }else{
            playAudio()
            btnPlay.setImage(#imageLiteral(resourceName: "ic_pause_circle_filled"), for: .normal)
        }
    }
    
    @IBAction func audioSlider(_ sender : UISlider) {
        audioPlayer.currentTime = TimeInterval(sender.value)
    }
    
    @IBAction func DownloadAudio(_ sender: UIButton) {
        if let audioUrl = dictBookDetails["audio"] as? [[String:Any]]{
            if let dictAudio = audioUrl[0] as? [String:Any] {
                if let strAudioUrl = dictAudio["audio"] as? String{
                    if let audioUrl = URL(string:strAudioUrl) {
                        // then lets create your document folder url
                        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        // lets create your destination file url
                        let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                        self.view.makeToast(message: "Downloaded Sucessfully")
                        print(destinationUrl)
                        // to check if it exists before downloading it
                        if FileManager.default.fileExists(atPath: destinationUrl.path) {
                            print("The file already exists at path")
                            // if the file doesn't exist
                        } else {
                            // you can use NSURLSession.sharedSession to download the data asynchronously
                            URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                                guard let location = location, error == nil else { return }
                                do {
                                    // after downloading your file you need to move it to your destination url
                                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                                    print("File moved to documents folder")
                                } catch let error as NSError {
                                    print(error.localizedDescription)
                                }
                            }).resume()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadListCell", for: indexPath) as! ReadListCell
        if indexPath.row == 2{
            cell.imgMusic.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    // MARK: - AV Player Methods
    func prepareMusicPlayer()  {
        //        do {
        //            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        //        } catch _ {
        //
        //        }
        //        do {
        //            try AVAudioSession.sharedInstance().setActive(true)
        //        } catch _ {
        //
        //        }
        //        UIApplication.shared.beginReceivingRemoteControlEvents()
        audioPlayer = try! AVAudioPlayer.init(data: audioData, fileTypeHint: "mp3")
        audioPlayer.delegate = self
        audioLength = audioPlayer.duration
        musicPlayerSlider.maximumValue = CFloat(audioPlayer.duration)
        musicPlayerSlider.minimumValue = 0.0
        musicPlayerSlider.value = 0.0
        audioPlayer.prepareToPlay()
        calculateSongLength()
    }
    
    func playAudio(){
        startTimer()
        audioPlayer.play()
    }
    func pauseAudio(){
        audioPlayer.pause()
    }
    
    func calculateSongLength(){
        let time = calculateTimeFromNSTimeInterval(audioLength)
        lblEndTime.text = "\(time.minute):\(time.second)"
    }
    
    func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update(_:)), userInfo: nil,repeats: true)
            timer.fire()
        }
    }
    
    @objc func update(_ timer: Timer){
        if !audioPlayer.isPlaying{
            return
        }
        let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
        lblStartTime.text  = "\(time.minute):\(time.second)"
        musicPlayerSlider.value = CFloat(audioPlayer.currentTime)
        UserDefaults.standard.set(musicPlayerSlider.value , forKey: "playerProgressSliderValue")
    }
    
    func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) ->(minute:String, second:String){
        //let hour_   = abs(Int(duration)/3600)
        let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
        let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
        
        //var hour = hour_ > 9 ? "\(hour_)" : "0\(hour_)"
        let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
        let second = second_ > 9 ? "\(second_)" : "0\(second_)"
        return (minute,second)
    }
    
    func stopTimer(){
        if timer != nil {
            timer!.invalidate()
        }
    }
    
    func retrievePlayerProgressSliderValue(){
        let playerProgressSliderValue =  UserDefaults.standard.float(forKey: "playerProgressSliderValue")
        if playerProgressSliderValue != 0 {
            musicPlayerSlider.value  = playerProgressSliderValue
            audioPlayer.currentTime = TimeInterval(playerProgressSliderValue)
            
            let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
            lblStartTime.text  = "\(time.minute):\(time.second)"
            musicPlayerSlider.value = CFloat(audioPlayer.currentTime)
            
        }else{
            musicPlayerSlider.value = 0.0
            audioPlayer.currentTime = 0.0
            lblStartTime.text = "00:00"
        }
    }
    
    // MARK:- AVAudioPlayer Delegate's Callback method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        btnPlay.setImage(#imageLiteral(resourceName: "play_music"), for: .normal)
    }
    
    
}

