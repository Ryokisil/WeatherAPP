//
//  SunnyScene.swift
//  OPWeather
//
//  Created by silvia on 2024/06/27.
//

import SpriteKit

class SunnyScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .clear // 背景色をクリアに設定

        // 太陽のスプライトを作成
        let sunTexture = SKTexture(imageNamed: "Sun")
        let sunNode = SKSpriteNode(texture: sunTexture)
        
        sunNode.position = CGPoint(x: size.width / 2, y: size.height / 2) // 中央に配置
        sunNode.size = CGSize(width: 200, height: 200) // サイズを設定
        addChild(sunNode) // シーンに追加

        // 回転アクションを追加
        let rotateAction = SKAction.rotate(byAngle: .pi, duration: 20) // 20秒かけて回転
        let repeatAction = SKAction.repeatForever(rotateAction) // 無限に繰り返し
        sunNode.run(repeatAction)
    }
}


