//
//  ViewController.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/05/19.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import KakaoMapsSDK

class FirstViewController: UIViewController, MapControllerDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        _observerAdded = false
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapContainer = self.view as? KMViewContainer
        
        mapController = KMController(viewContainer: mapContainer!)
        mapController!.delegate = self        
    }

    override func viewWillAppear(_ animated: Bool) {
        addObservers()

        if mapController?.isEnginePrepared == false {
            mapController?.prepareEngine()
        }
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        mapController?.pauseEngine()
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.resetEngine()
    }
    
    func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        print("OK")
        let view = mapController?.getView("mapview") as! KakaoMap
        view.viewRect = mapContainer!.bounds
    }
  
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)

    }
    
    func addObservers(){
         NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    
         _observerAdded = true
     }
     
     func removeObservers(){
         NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
     
          _observerAdded = false
     }
     
     @objc func willResignActive(){
         mapController?.pauseEngine()
     }
     
     @objc func didBecomeActive(){
         mapController?.activateEngine()
     }
     
   
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var _observerAdded: Bool
}

