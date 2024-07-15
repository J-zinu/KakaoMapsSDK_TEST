//
//  TextStyleSample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2022/04/01.
//  Copyright © 2022 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// 폰트 설정 및 행간,자간,장평을 조절하는 예제
// 임의의 Poi하나에 5개의 PoiTextLineStyle을 추가해서 폰트/행간/자간/장평을 조절한다

class TextStyleSample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createStyle()
        createPoi()
    }
    
    func createStyle() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        
        let iconStyle1 = PoiIconStyle(symbol: UIImage(named: "pin_green.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        
        // TextStyle에 폰트 선택 및 행간,자간,장평을 조절할 수 있다.
        var textLineStyles = [PoiTextLineStyle]()
        
        // 텍스트 스타일 구성 설명
        // PoiStyle
        //  ㄴ PoiTextStyle
        //      ㄴ PoiTextLineStyle[0]
        //          ㄴ textStyle : Noto Sans KR Bold  ||  0  || 1.0 || 0.6
        //          ㄴ textLayout : .center
        //      ㄴ PoiTextLineStyle[1]
        //          ㄴ textStyle : Noto Sans KR Bold  ||  1  || 1.2 || 0.8
        //          ㄴ textLayout : .center
        //      ㄴ PoiTextLineStyle[2]
        //          ㄴ textStyle : Noto Sans KR Bold  ||  2  || 1.4 || 1.0
        //          ㄴ textLayout : .center
        //      ㄴ PoiTextLineStyle[3]
        //          ㄴ textStyle : Noto Sans KR Bold  ||  3  || 1.6 || 1.2
        //          ㄴ textLayout : .center
        //      ㄴ PoiTextLineStyle[4]
        //          ㄴ textStyle : Noto Sans KR Bold  ||  4  || 1.8 || 1.4
        //          ㄴ textLayout : .center
        //  추가한 각각의 PoiTextLineStyle을 PoiText를 생성할 때 인덱스로 지정할 수 있다.
        for i in 0...4 {
            let text = TextStyle(fontSize: 20,
                                  fontColor: UIColor.white,
                                  strokeThickness: 2,
                                  strokeColor: UIColor.blue,
                                  font: "Noto Sans KR Bold",                // 폰트 설정.
                                  charSpace: i,                             // 자간. 0~4까지 설정
                                  lineSpace: 1.0 + Float(i) * 0.2,          // 행간. [1.0, 1.2, 1.4, 1.6, 1.8]으로 설정
                                  aspectRatio: 0.6 + Float(i) * 0.2)        // 장평. [0.6, 0.8, 1.0, 1.2, 1.4]으로 설정
            let textLineStyle = PoiTextLineStyle(textStyle: text)
            textLineStyles.append(textLineStyle)
        }


        let textStyle1 = PoiTextStyle(textLineStyles: textLineStyles)
        textStyle1.textLayouts = [.center]
        let poiStyle1 = PoiStyle(styleID: "customStyle1", styles: [
            PerLevelPoiStyle(iconStyle: iconStyle1, textStyle: textStyle1, level: 0)
        ])
        
        manager.addPoiStyle(poiStyle1)
    }
    
    func createPoi() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let layer = manager.addLabelLayer(option: layerOption)
        let poiOption = PoiOptions(styleID: "customStyle1", poiID: "poi1")
        poiOption.rank = 0
        poiOption.addText(PoiText(text: "텍스트 스타일 테스트", styleIndex: 0)) // PoiTextLineStyle[0] 적용
        poiOption.addText(PoiText(text: "텍스트 스타일 테스트", styleIndex: 1)) // PoiTextLineStyle[1] 적용
        poiOption.addText(PoiText(text: "텍스트 스타일 테스트", styleIndex: 2)) // PoiTextLineStyle[2] 적용
        poiOption.addText(PoiText(text: "텍스트 스타일 테스트", styleIndex: 3)) // PoiTextLineStyle[3] 적용
        poiOption.addText(PoiText(text: "텍스트 스타일 테스트", styleIndex: 4)) // PoiTextLineStyle[4] 적용
        let poi1 = layer?.addPoi(option:poiOption, at: MapPoint(longitude: 127.108678, latitude: 37.402001))
        poi1?.show()
    }
    
}
