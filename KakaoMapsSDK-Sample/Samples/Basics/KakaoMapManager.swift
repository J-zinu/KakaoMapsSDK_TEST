//
//  KakaoMapManager.swift
//  KakaoMapOpenApi-Sample
//
//  Created by narr on 2021/05/18.
//  Copyright © 2021 kakao. All rights reserved.
//

import Foundation
import KakaoMapsSDK

// 지도뷰를 관리하는 클래스. 인스턴스 생성시 KMViewContainer를 생성하여 초기화하고, 들고있다.
// 필요한 뷰 컨트롤러에서 해당 인스턴스의 KMViewContainer를 추가하여 지도를 표시한다.
public class KakaoMapManager {
    
    // KakaoMapManager를 최초 한번 생성할 때 지도뷰 컨테이너 및 컨트롤러를 생성한다.
    public init(rect: CGRect) {
        container = KMViewContainer(frame: rect)
        controller = KMController(viewContainer: container!)
        
        initialized = true
    }
    
    // 더이상 인스턴스가 쓰이지 않을 때 엔진을 stop해서 사용한 리소스를 모두 제거한다.
    deinit {
        controller?.pauseEngine()
        controller?.resetEngine()
    }
    
    public static func getInstance(rect: CGRect) -> KakaoMapManager {
        if instance != nil {
            return instance!
        }
        else {
            let ref = KakaoMapManager(rect: rect)
            instance = ref;
            return ref;
        }
    }
    
    static weak var instance: KakaoMapManager? = nil
    var initialized: Bool = false
    var kakaoMap: KakaoMap?
    var controller: KMController?
    var container: KMViewContainer?
}
