//
//  ChangeWaveTextDataAndStyleSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2020/07/20.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

class ChangeWaveTextDataAndStyleSample: APISampleBaseViewController {
    
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
        // WaveText가 처음 표시될 때 사용할 style
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let perLevelStyle1 = PerLevelWaveTextStyle(textStyle: TextStyle(fontSize: 15, fontColor: UIColor.white, strokeThickness: 2, strokeColor: UIColor.red), level: 10)
        let perLevelStyle2 = PerLevelWaveTextStyle(textStyle: TextStyle(fontSize: 20, fontColor: UIColor.white, strokeThickness: 4, strokeColor: UIColor.blue), level: 15)

        let waveTextStyle = WaveTextStyle(styleID: "perLevelWaveTextStyle", styles:[perLevelStyle1, perLevelStyle2])

        manager.addWaveTextStyle(waveTextStyle)
    }
    
    func createChangedWaveTextStyle() {
        // 버튼이 클릭되면 변경할 WaveTextStyle
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let perLevelStyle1 = PerLevelWaveTextStyle(textStyle: TextStyle(fontSize: 15, fontColor: UIColor.white, strokeThickness: 2, strokeColor: UIColor.blue), level: 10)
        let perLevelStyle2 = PerLevelWaveTextStyle(textStyle: TextStyle(fontSize: 20, fontColor: UIColor.white, strokeThickness: 4, strokeColor: UIColor.red), level: 15)
        
        let waveTextStyle = WaveTextStyle(styleID: "perLevelWaveTextStyle2", styles: [perLevelStyle1, perLevelStyle2])

        manager.addWaveTextStyle(waveTextStyle)
    }
    
    func createWaveText() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "WaveTextLayer")
        
        let options = WaveTextOptions(styleID: "perLevelWaveTextStyle", waveTextID: "waveText1")
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
    
    @IBAction func onButtonClicked(_ sender: Any) {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "WaveTextLayer")
        let waveText = layer?.getWaveText(waveTextID: "waveText1")
        
        // 바꿀 WaveTextStyle을 생성한다.
        createChangedWaveTextStyle()
        
        // 바꾸고자 하는 text와 styleID로 waveText의 텍스트 내용과 스타일을 함께 업데이트 한다.
        waveText?.changeTextAndStyle(text: "흐르는 글씨 업데이트", styleID: "perLevelWaveTextStyle2")
    }
    
    override func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
}
