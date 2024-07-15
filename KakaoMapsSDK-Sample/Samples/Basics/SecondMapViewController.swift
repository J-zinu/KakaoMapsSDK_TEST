//
//  SecondMapViewController.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/05/18.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// 하나의 지도뷰를 여러개의 뷰 컨트롤러에서 관리하는 예제
// KakaoMapManager에서 지도뷰를 생성해서 초기화하고, FirstMapViewController -> SecondMapViewController로 넘어가면서 뷰 라이프 사이클에 따라서 지도 렌더링을 컨트롤한다.
class SecondMapViewController: UIViewController, MapControllerDelegate {
    required init?(coder: NSCoder) {
        observerAdded = false
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapManager = KakaoMapManager.getInstance(rect: self.view.frame)
        mapManager?.controller?.delegate = self;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 두번째 뷰가 나타날 때, 기존에 생성해두었던 지도뷰를 가져와서 추가하고, 다시 지도뷰 렌더링을 시작한다.
        self.view.addSubview((mapManager?.container)!)
        mapManager?.controller?.activateEngine()
        addObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        // 사라질 때, 지도뷰 렌더링을 멈춘다.
        removeObservers()
        mapManager?.controller?.pauseEngine()
    }
    
    func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        //지도(KakaoMap)를 그리기 위한 viewInfo를 생성
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 15)
        
        mapManager?.controller?.addView(mapviewInfo)
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    
        observerAdded = true
    }
     
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)

        observerAdded = false
    }
    
    @objc func willResignActive(){
        //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
        mapManager?.controller?.pauseEngine()
    }

    @objc func didBecomeActive(){
        //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
        mapManager?.controller?.activateEngine()
    }
    
    var mapManager: KakaoMapManager?
    var observerAdded: Bool
}
