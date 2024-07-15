//
//  WaveTextSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/05.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import KakaoMapsSDK

// WaveText 사용 예제.
// WaveText는 지도상에 임의의 경로를 따라 텍스트를 그리기 위한 클래스이다.
class WaveTextSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.02768, latitude: 37.498254)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createLabelLayer()
        createWaveTextStyle()
        createWaveText()
    }
    
    func createLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "WaveTextLayer", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 10001)
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    func createWaveTextStyle() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let perLevelStyle1 = PerLevelWaveTextStyle(textStyle: TextStyle(fontSize: 15, fontColor: UIColor.white, strokeThickness: 2, strokeColor: UIColor.red), level: 10)
        let perLevelStyle2 = PerLevelWaveTextStyle(textStyle: TextStyle(fontSize: 20, fontColor: UIColor.white, strokeThickness:4, strokeColor: UIColor.blue), level: 15)
        
        let waveTextStyle = WaveTextStyle(styleID: "perLevelWaveTextStyle", styles: [perLevelStyle1, perLevelStyle2])
        
        manager.addWaveTextStyle(waveTextStyle)
    }
    
    func createWaveText() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "WaveTextLayer")
        
        let options = WaveTextOptions(styleID: "perLevelWaveTextStyle")
        options.rank = 0
        options.text = "흐르는 글씨"
        // 그려질 경로의 point들을 지정.
        options.points = [MapPoint(longitude: 127.027401, latitude: 37.498469),
                          MapPoint(longitude: 127.027511, latitude: 37.498367),
                          MapPoint(longitude: 127.02768, latitude: 37.498254),
                          MapPoint(longitude: 127.027882, latitude: 37.498195),
                          MapPoint(longitude: 127.028052, latitude: 37.498165)]
        
        let waveText = layer?.addWaveText(options)
        waveText?.show()
    }
    
    override func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
}
