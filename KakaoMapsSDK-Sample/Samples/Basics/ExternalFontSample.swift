//
//  ExternalFontSample.swift
//  KakaoMapsSDK-Sample
//
//  Created by Joohyun Baek on 4/11/24.
//  Copyright © 2024 kakao. All rights reserved.
//

import Foundation
import UIKit
import KakaoMapsSDK

class ExternalFontSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        let data = NSData(contentsOfFile: Bundle.main.bundlePath + "/ExternalFontFile.ttf") //주의! 샘플 프로젝트에는 폰트파일이 들어 있지 않습니다.
        mapController?.addFont(fontName: "customFont", fontData: Data(referencing: data!))
        
        createLabelLayer()
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        
        let symbol = UIImage(named: "pin_red.png")
        let anchorPoint = CGPoint(x: 0.5, y: 1.0)
        let iconStyle = PoiIconStyle(symbol: symbol, anchorPoint: anchorPoint)
        
        let textLineStyles = [
            PoiTextLineStyle(textStyle: TextStyle(fontSize: 30, fontColor: UIColor.white, strokeThickness: 1, strokeColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0), font: "customFont")),
            PoiTextLineStyle(textStyle: TextStyle(fontSize: 12, fontColor: UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0), strokeThickness: 1, strokeColor: UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 1.0)))
        ]
        let textStyle = PoiTextStyle(textLineStyles: textLineStyles)
        
        let poiStyle = PoiStyle(styleID: "customFontStyle", styles: [
            PerLevelPoiStyle(iconStyle: iconStyle, textStyle: textStyle, level: 0)
        ])
        manager.addPoiStyle(poiStyle)
        
        let option = PoiOptions(styleID: "customFontStyle")
        option.clickable = false
        option.rank = 0
        option.transformType = .default
        option.addText(PoiText(text: "외부폰트텍스트", styleIndex: 0))
        
        let poiLayer = manager.getLabelLayer(layerID: "PoiLayer")
        let marker = poiLayer?.addPoi(option: option, at: view.getPosition(CGPoint(x: view.viewRect.width * 0.5, y: view.viewRect.height * 0.5)))
        marker?.show()
        
        let waveTextStyle = WaveTextStyle(styleID: "waveTextStyle", styles: [PerLevelWaveTextStyle(textStyle: TextStyle(fontSize: 30, font: "customFont"), level: 0)])
        let waveTextOption = WaveTextOptions(styleID: "waveTextStyle")
        waveTextOption.points = [view.getPosition(CGPoint(x: view.viewRect.width * 0.5, y: view.viewRect.height * 0.5)),
                                 view.getPosition(CGPoint(x: view.viewRect.width * 0.7, y: view.viewRect.height * 0.6)),
                                 view.getPosition(CGPoint(x: view.viewRect.width * 0.6, y: view.viewRect.height * 0.9))];
        waveTextOption.text = "~!~@~#~$물%결^텍&스*트(~)~_~+~"
        manager.addWaveTextStyle(waveTextStyle)
        let waveText = poiLayer?.addWaveText(waveTextOption)
        waveText?.show()
    }
    
    func createLabelLayer() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 10001)
        let _ = manager.addLabelLayer(option: layerOption)
    }
}
