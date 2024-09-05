
import SpriteKit

class RainScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        createRain()
    }
    
    // 雨のアニメーションを作成する
    func createRain() {
        // SKEmitterNodeをRainFall.sksファイルから読み込む
        guard let rainNode = SKEmitterNode(fileNamed: "RainFall.sks") else { return }
        rainNode.position = CGPoint(x: size.width / 2, y: size.height)
        rainNode.particlePositionRange = CGVector(dx: size.width, dy: 0)
        addChild(rainNode)
    }
}

