//
//  BasicGUISample.swift
//  KakaoMapOpenApi-Sample
//
//  Created by chase on 2020/06/04.
//  Copyright © 2020 kakao. All rights reserved.
//

import UIKit
import KakaoMapsSDK

class BasicGUISample: APISampleBaseViewController {
    
    override func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        showBasicGUIs()
    }
    
    func showBasicGUIs() {
        let view = mapController?.getView("mapview") as! KakaoMap
        //나침반의 위치를 지정(좌하단의 원점을 기준으로 x + 10, y + 10)
        view.setCompassPosition(origin: GuiAlignment(vAlign: .bottom, hAlign: .left), position: CGPoint(x: 10.0, y: 10.0))
        view.showCompass()  //나침반을 표시한다.
        //축척의 위치를 지정(우하단의 원점을 기준으로 x + 10, y + 10). offset의 방향에 주의. offset의 + 방향은 각 정렬기준점에서 화면 중심 방향이다(center는 우,하단 방향이 +).
        view.setScaleBarPosition(origin: GuiAlignment(vAlign: .bottom, hAlign: .right), position: CGPoint(x: 10.0, y: 10.0))
        view.showScaleBar() //축척을 표시한다.
        view.setScaleBarFadeInOutOption(FadeInOutOptions(fadeInTime: 1000, fadeOutTime: 1000, retentionTime: 5000))  //축척에 Fade In/Out 효과 옵션을 지정한다. 자동으로 사라질지 여부 및 FadeIn/Out시간과 FadeIn이 끝나고 유지되는 시간을 지정한다.
    }
}
