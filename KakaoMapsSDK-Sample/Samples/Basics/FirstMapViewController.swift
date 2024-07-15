//
//  FirstMapViewController.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/05/18.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// 하나의 지도뷰를 여러개의 뷰 컨트롤러에서 관리하는 예제
// KakaoMapManager에서 지도뷰를 생성해서 초기화하고, FirstMapViewController -> SecondMapViewController로 넘어가면서 뷰 라이프 사이클에 따라서 지도 렌더링을 컨트롤한다.
// 두 뷰 컨트롤러가 같은 지도뷰 객체를 사용한다.
// KakaoMapManager.swift 및 SecondMapViewController.swift 함께 참조.
class FirstMapViewController: UIViewController, MapControllerDelegate {
    
    required init?(coder: NSCoder) {
        observerAdded = false
        appeared = false
        super.init(coder: coder)
    }
    
    // 초기화.
    override func viewDidLoad() {
        super.viewDidLoad()
        // 지도뷰를 관리하는 KakaoMapManager 인스턴스 가져옴
        mapManager = KakaoMapManager.getInstance(rect: self.view.frame)
        // 지도뷰(KMContainer)를 생성하고, 엔진을 초기화한다.
        // 지도뷰 인스턴스를 계속 유지한채로 들고 사용하려면 initEngine 및 startEngine & stopEngine은 초기화 및 더이상 사용하지 않을때 1번씩만 호출한다.
        // 그 외에 뷰 라이프 싸이클에 따른 지도 렌더링 컨트롤은 startRendering & stopRendering으로만 컨트롤한다.
        mapManager?.controller?.delegate = self;
        mapManager?.controller?.prepareEngine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        // 지도뷰를 추가한다.
        self.view.addSubview((mapManager?.container)!)
        self.view.sendSubviewToBack((mapManager?.container)!)
        
        mapManager?.controller?.activateEngine() // 지도뷰 렌더링 시작.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        appeared = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        mapManager?.controller?.pauseEngine() // 현재 뷰가 사라질 때, 지도뷰 렌더링을 멈춘다.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        appeared = false
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
    
    @IBAction func onNextClicked(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(identifier: "SecondMapViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var observerAdded: Bool
    var appeared: Bool
    var mapManager: KakaoMapManager?
}
