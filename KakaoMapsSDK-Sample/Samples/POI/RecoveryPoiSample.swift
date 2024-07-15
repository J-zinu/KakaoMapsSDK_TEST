//
//  RecoveryPoiSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/05/07.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// Poi를 생성하고 사용한 후 엔진이 stop되었을 때 PoiOptions을 재사용해서 생성했던 Poi를 다시 복구하는 예제.
// 먼저 Poi생성을 위한 서비스쪽 데이터(Poi의 위치정보 등)를 이용하여 Poi를 표시하기 위해 PoiOptions을 생성하고, 화면에 표시한다.
// 예제 실행 후 Next버튼을 누르면 NavigationController에 의해 다음 뷰(SecondViewController.swfit 참조)로 넘어가는데, 이때 생성해두었던 PoiOptions 재사용을 위해 PoiOptions배열을 함께 전달한다.
// 그리고 SecondViewController 클래스에서 이 PoiOptions을 재사용해서 똑같은 Poi를 다시 화면에 표시한다.
class RecoveryPoiSample: APISampleBaseViewController {
 
    // Poi 표시를 위한 서비스쪽의 Poi Dummy Data(PoiDataSample.swift 참조)
    // 해당 예제에서는 임의로 id, 위치정보, styleID, Poi의 이름으로 지정함.
    // 엔진과는 관계없는 데이터로, Poi 정보를 담고있는 서비스쪽의 데이터를 의미한다.
    override func viewDidLoad() {
        // Poi 생성을 위한 임의의 dummy data를 불러와서, 화면에 Poi표시를 위해 PoiOptions을 생성하여 저장한다.
        let datas = PoiDataSample.createPoiData()
        for data in datas {
            let option = PoiOptions(styleID: data.styleID, poiID: data.id)
            options.append(option)
        }
        
        // Poi 표시 위치를 지정하기위해, dummy data에서 위치정보만 빼내서 따로 저장해둠.
        positions = PoiDataSample.datas.map {
            MapPoint(longitude: $0.position.longitude, latitude: $0.position.latitude)
        }
        
        super.viewDidLoad()
    }
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        
        // Style 생성
        createPoiStyles()
        // LabelLayer 생성.
        createLabelLayer()
        // LabelLayer 생성.
        createPois()
    }
    
    // Poi가 어떻게 표시될지를 지정하는 Style 생성.
    func createPoiStyles() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let labelManager = mapView.getLabelManager()
        
        let icon1 = PoiIconStyle(symbol: UIImage(named: "pin_orange.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle1 = PerLevelPoiStyle(iconStyle: icon1, level: 0)
        let poiStyle1 = PoiStyle(styleID: "orange", styles: [perLevelStyle1])
        labelManager.addPoiStyle(poiStyle1)
        
        let icon2 = PoiIconStyle(symbol: UIImage(named: "pin_red.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle2 = PerLevelPoiStyle(iconStyle: icon2, level: 0)
        let poiStyle2 = PoiStyle(styleID: "red", styles: [perLevelStyle2])
        labelManager.addPoiStyle(poiStyle2)
        
        let icon3 = PoiIconStyle(symbol: UIImage(named: "pin_green.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle3 = PerLevelPoiStyle(iconStyle: icon3, level: 0)
        let poiStyle3 = PoiStyle(styleID: "green", styles: [perLevelStyle3])
        labelManager.addPoiStyle(poiStyle3)
        
        let icon4 = PoiIconStyle(symbol: UIImage(named: "pin_blue.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle4 = PerLevelPoiStyle(iconStyle: icon4, level: 0)
        let poiStyle4 = PoiStyle(styleID: "blue", styles: [perLevelStyle4])
        labelManager.addPoiStyle(poiStyle4)
    }
    
    // LabelLayer 생성. 하나의 LabelLayer는 여러개의 Poi를 포함할 수 있다.
    func createLabelLayer() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let labelManager = mapView.getLabelManager()
        
        let layer = LabelLayerOptions(layerID: "layer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let _ = labelManager.addLabelLayer(option: layer)
    }
    
    // PoiOptions을 이용하여 Poi를 화면에 표시한다.
    func createPois() {
        let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
        let labelManager = mapView.getLabelManager()
        
        let layer = labelManager.getLabelLayer(layerID: "layer")
        if let items = layer?.addPois(options: options, at: positions) {
            
            // 생성해둔 Poi 객체들은 따로 저장해두고, 엔진에서 지워지기 전이나 사용자가 지우기 전까지는 자유롭게 사용할 수 있다.
            for item in items {
                pois[item.itemID] = item
            }
        }
        
        mapView.moveCamera(CameraUpdate.make(area: AreaRect(points: positions)))
        layer?.showAllPois()
    }
    
    // 현재 view가 사라질 때
    override func viewDidDisappear(_ animated: Bool) {
        // 엔진이 stop되면 추가했던 Poi는 모두 지워진다.
        mapController?.resetEngine()
        // Poi가 모두 지워졌으므로, 별도로 사용자가 들고있던 Poi Table도 모두 삭제한다.
        pois.removeAll()
    }
    
    // prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 다음 뷰로 넘어갈때, 미리 생성해두었던 PoiOptions 배열을 다음 ViewController의 프로퍼티로 전달하여 PoiOptions을 재사용한다.
        // 이 PoiOptions을 재활용해서 해당 뷰에서 생성했던 Poi를 그대로 Recovery한다.
        // SecondViewController.swift 참조.
        if segue.destination is SecondViewController {
            let vc = segue.destination as? SecondViewController
            vc?.options = self.options
        }
    }
    
    var positions = [MapPoint]()
    var options = [PoiOptions]()
    var pois = [String: Poi]()
}

