//
//  MovementViewcontroller.swift
//  ChallengeIOS
//
//  Created by Igor Maldonado Floor on 16/11/17.
//  Copyright © 2017 Igor Maldonado Floor. All rights reserved.
//

import UIKit
import GoogleMaps

class MovementViewcontroller: UIViewController, GMSMapViewDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var configButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var configurationView: UIView!
    @IBOutlet weak var tapLabel: UILabel!
    
    //MARK: - Variables
    var storedPositions : Array<Position> = []
    var knownPositions : Array<Position> = []
    var locationManager = CLLocationManager()
    var currentPosition = CLLocationCoordinate2DMake(-21.9936372, -47.8970922)
    var positionMarker : GMSMarker?
    var animationDuration : Double = 5
    var configIsShown = false
    var firstDBCheck = true
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.camera(withLatitude: self.currentPosition.latitude, longitude: self.currentPosition.longitude, zoom: 12)
        
        self.mapView.camera = camera
        self.mapView.delegate = self
        
        self.loadPositions()
        self.setupMarker()
        self.setupStartButton()
        
     
        self.durationSlider.value = Float(self.animationDuration)
        self.setDurationAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
        
        if(firstDBCheck){
            firstDBCheck = false
            let positions = RealmManager.getInstance().realm.objects(Position.self)
            if (positions.count > 0){
                let alertController = UIAlertController(title: "Realm database", message: String(format: "Do you want to delete previous positions saved? (%lu)", positions.count), preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    try! RealmManager.getInstance().realm.write {
                        RealmManager.getInstance().realm.deleteAll()
                    }
                })
                let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
                alertController.addAction(yesAction)
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        self.getLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - UI Actions
    @IBAction func startButtonTapped(_ sender: Any) {
        self.startButton.isHidden = true
        self.configButton.isHidden = false
        self.moveToNextPosition()
    }
    
    @IBAction func configButtonTapped(_ sender: Any) {
        self.configIsShown = !self.configIsShown
        
        self.configurationView.isHidden = !self.configIsShown
    }
    
    @IBAction func durationSliderValueChanged(_ sender: Any) {
        self.animationDuration = Double(self.durationSlider.value)
        self.setDurationAnimation()
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - UI Setup
    
    func setDurationAnimation(){
        self.durationLabel.text = String(format: "%f.0s", self.animationDuration)
    }
    
    func centerMapTo(position: Position){
        self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude: position.lat, longitude: position.lng))
    }
    
    func centerUserTo(){
        self.positionMarker!.position = self.currentPosition
        self.mapView.animate(toLocation: self.currentPosition)
    }
    
    //MARK: - Movimentation methods
    func moveToNextPosition(){
        if let nextPosition = self.storedPositions.first{
            NSLog("Going to: %f %f", nextPosition.lat, nextPosition.lng)
            self.storedPositions.removeFirst()
            self.processPosition(nextPosition: nextPosition)
            
        }else{
            ConsolePrinter.printToConsole(output: "Stored positions ended")
            self.tapLabel.isHidden = false
        }
    }
    
    func processPosition(nextPosition: Position){
        self.postPosition(position: nextPosition)
        
        let transitionStart = Double(Date().timeIntervalSince1970)
        let currentAnimationDuration = animationDuration
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(currentAnimationDuration)
        
        CATransaction.setCompletionBlock({
            let transitionEnded = Double(Date().timeIntervalSince1970)
            let transitionTime = transitionEnded - transitionStart
            var missingDelay: Double = 0.01
            if(currentAnimationDuration > transitionTime){
                missingDelay = currentAnimationDuration - transitionTime
            }
            
            //Transitions finishes instantly when the viewcontroller is not presented, so is necessary a delay to start the next step
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + missingDelay, execute: {
                self.finishedLastMovimentation(movedTo: nextPosition)
            })
        })
        self.positionMarker!.position = CLLocationCoordinate2DMake(nextPosition.lat, nextPosition.lng)
        CATransaction.commit()
    }
    
    func finishedLastMovimentation(movedTo: Position){
        NSLog("Finished moving")
        self.centerMapTo(position: movedTo)
        self.moveToNextPosition()
    }
    
    func postPosition(position: Position){
        APIService.postPosition(position: position) { (statusCode, error) in
            if(statusCode == 0){
                position.postedToBackend = true
            }else{
                position.postedToBackend = false
            }
            
            try! RealmManager.getInstance().realm.write {
                RealmManager.getInstance().realm.add(position)
            }
            NotificationServer.getInstance().notify(event: NotificationType.NewPosition)
        }
        
    }
    
    //MARK: - utils methods
    func loadPositions(){
        let positions = FileUtils.parseArrayFromJson(filename: "posicoes")
        
        for positionDictionary in positions{
            if let pstDictionary = positionDictionary as? Dictionary<String, AnyObject>{
                let position = Position.parseObjFromDictionary(dictionary: pstDictionary)
                storedPositions.append(position)
            }
        }
        
        storedPositions = storedPositions.sorted(by: { return $0.date < $1.date })
    }
    
    func setupMarker(){
        self.positionMarker = GMSMarker(position: currentPosition)
        let personImage = UIImage(named: "person")
        self.positionMarker!.icon = personImage
        self.positionMarker!.map = self.mapView
        self.positionMarker!.appearAnimation = .pop
    }
    
    func setupStartButton(){
        self.startButton.layer.cornerRadius = 5
    }
    
    //MARK: - MapView delegate
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if(!self.tapLabel.isHidden){
            self.tapLabel.isHidden = true
            
            let position = Position()
            position.lat = coordinate.latitude
            position.lng = coordinate.longitude
            position.date = Date()
            
            self.processPosition(nextPosition: position)
        }
    }

}
