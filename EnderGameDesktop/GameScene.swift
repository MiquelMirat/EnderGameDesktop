//
//  GameScene.swift
//  Ender Game
//
//  Created by Miquel Mirat Soler on 08/04/2019.
//  Copyright © 2019 mmirat. All rights reserved.
//
import SpriteKit
import GameplayKit

class GameScene: SKScene{
    //MARK: - nodes
    private var player: PlayerNode?
    private var background : BackgroundNode?
    private var scoreLabel : CustomLabel?
    private var bestScoreLabel : CustomLabel?
    private var lifesLabel : CustomLabel?
    private var soundsButton : CustomLabel?
    private var playButton : CustomLabel?
    private var pauseButton : CustomLabel?
    
    //MARK: - timers
    var enemySpawnTimer:Timer?
    var portalSpawnTimer:Timer?
    var increaseLevelTimer:Timer?
    var bigWaveTimer:Timer?
    
    //MARK: - Starting Spawn Rates
    var startingPortalSpawn:Double = 4
    var startingEnemySpawn:Double = 0.3
    var startingNewLevelSpawning:Double = 14
    
    //Mark: - Arrays and Utils
    var enemies = [EnemyNode]()
    var portals = [PortalNode]()
    var utils:Utils = Utils()
    
    //MARK: - Initial Values and didSets
    var targetPos:CGPoint = CGPoint(x: 0, y: 0)
    var inGame:Bool = false
    var isGamePaused:Bool = false {
        didSet {
            pauseButton!.text = self.isGamePaused ? "Resume" : "Pause"
            self.isGamePaused ? pause() : resume()
        }
    }
    var soundsEnabled:Bool = true {
        didSet{
            soundsButton!.text = self.soundsEnabled ? "Sounds: On" : "Sounds: Off"
            self.utils.saveIsSoundEnabled(isEnabled: self.soundsEnabled)
        }
    }
    var lastCount = 0
    var enemiesEliminated:Int = 0{
        didSet{
            if self.enemiesEliminated - lastCount > 50 {
                spawnNewLife()
                lastCount+=50
            }
            if self.enemiesEliminated == 0 {
                lastCount = 0
            }
        }
    }
    var score:Int = 0 {
        didSet{
            self.score = self.score < 0 ? 0 : self.score
            scoreLabel?.text = String(self.score)
        }
    }
    var lifes:Int = 3{
        didSet{
            self.lifes = self.lifes < 0 ? 0 : self.lifes
            lifesLabel?.text = "Lifes left: " + String(self.lifes)
            if self.lifes == 0 {
                gameOver()
            }
        }
    }
    
    //MARK: - DidMove SetUp
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        setUpUI()
    }
    func setUpUI(){
        playButton = CustomLabel(text: "PLAY").preConfigure(position:CGPoint(x: 0, y: 60), name:"playButton")
        self.addChild(playButton!)
        scoreLabel = CustomLabel(text: "0").preConfigure(position:CGPoint(x: 0, y: 0), name:"scoreLabel")
        self.addChild(scoreLabel!)
        bestScoreLabel = CustomLabel(text: "Best Score: " + String(utils.getBestScore())).preConfigure(position:CGPoint(x: 0, y: -60), name:"bestScore")
        self.addChild(bestScoreLabel!)
        soundsButton = CustomLabel(text: "Sounds: On").preConfigure(position:CGPoint(x: 0, y: -120), name:"soundsButton")
        self.addChild(soundsButton!)
        pauseButton = CustomLabel(text: "Pause").preConfigure(position:CGPoint(x: frame.minX + 120, y: frame.maxY - 60), name:"pauseButton")
        pauseButton!.isHidden = true
        self.addChild(pauseButton!)
        lifesLabel = CustomLabel(text:"Lifes left: " + String(self.lifes)).preConfigure(position:CGPoint(x: frame.maxX - 200 , y: frame.maxY - 80), name:"lifesLabel")
        lifesLabel!.isHidden = true
        self.addChild(lifesLabel!)
        background = BackgroundNode(imageNamed: "backgroundSpace").preConfigure(size:size)
        self.addChild(background!)
    }
    
    //MARK: - Game Flow
    func pause(){
        stopTimers()
    }
    func resume(){
        startTimers()
    }
    @objc func startGame(){
        self.score = 0
        self.lifes = 3
        self.targetPos = CGPoint(x: 0, y: 0)
        self.inGame = true
        hideMenu()
        startTimers()
        spawnPlayer()
    }
    func gameOver() {
        inGame = false
        utils.saveNewBestScore(score: score)
        showMenu()
        stopTimers()
        removeAllNodes()
    }

    //MARK: - Timers management
    func startTimers(){
        increaseLevelTimer = Timer.scheduledTimer(timeInterval: startingNewLevelSpawning, target: self, selector: #selector(updateTimers), userInfo: nil, repeats: true)
        portalSpawnTimer = Timer.scheduledTimer(timeInterval: startingPortalSpawn, target: self, selector: #selector(spawnPortal), userInfo: nil, repeats: true)
        enemySpawnTimer = Timer.scheduledTimer(timeInterval: startingEnemySpawn, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true)
        bigWaveTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(bigWave), userInfo: nil, repeats: true)
    }
    func stopTimers(){
        enemySpawnTimer?.invalidate()
        portalSpawnTimer?.invalidate()
        increaseLevelTimer?.invalidate()
        bigWaveTimer?.invalidate()
    }
    
    //MARK: - Spawns / despawns
    func spawnPlayer(){
        player = PlayerNode(imageNamed: "player").preConfigure(pos: targetPos)
        self.addChild(player!)
    }
    @objc func spawnPortal(){
        let portal = PortalNode(imageNamed: "portal").preConfigure()
        portal.position = utils.randomInsidePosition(size:size)
        portals.append(portal)
        background!.addChild(portal)
    }
    @objc func spawnEnemy(){
        let enemy = EnemyNode(imageNamed: "enemy").preConfigure()
        enemy.position = utils.randomOutsidePosition(spriteSize: enemy.size, size:size)
        enemies.append(enemy)
        self.addChild(enemy)
    }
    func spawnNewLife(){
        let life = LifeNode(imageNamed: "player").preConfigure()
        life.position = utils.randomInsidePosition(size: size)
        background!.addChild(life)
    }
    @objc func bigWave (){
        var from = Int.random(in: 0...360)
        let to = (from + 180) % 360
        while(from<to){
            let enemy = EnemyNode(imageNamed: "enemy").preConfigure()
            let angle = (CGFloat(from) * CGFloat.pi) / 180.0
            let radius = (size.height + enemy.size.height) * 0.7
            enemy.position = CGPoint(x: cos(angle) * radius,y: sin(angle) * radius)
            enemies.append(enemy)
            self.addChild(enemy)
            from+=10
        }
    }
    func removeAllNodes(){
        player?.removeFromParent()
        for e in enemies {
            e.removeFromParent()
        }
        enemies.removeAll()
        for p in portals {
            p.removeFromParent()
        }
        portals.removeAll()
        for l in background!.children {
            if let life = l as? LifeNode {
                life.removeFromParent()
            }
        }
    }
    
    //MARK: - Event Handlers
    override func mouseDown(with t: NSEvent) {
        if inGame {
            targetPos = t.location(in: self)
            switch(atPoint(targetPos).name){
            case "pauseButton": isGamePaused.toggle()
            default: break
            }
        }else{
            targetPos = t.location(in: self)
            switch (atPoint(targetPos).name){
            case "playButton": startGame()
            case "soundsButton": soundsEnabled.toggle()
            default: break
            }
        }
    }
    override func mouseDragged(with event: NSEvent) {
        targetPos = event.location(in: self)
    }
    
    //MARK: - Updates
    override func update(_ currentTime: TimeInterval) {
        if inGame && !isGamePaused {
            player?.update(target: targetPos)
            background?.update(pos: player!.position)
            updateEnemies()
            updatePortals()
        }
    }
    func updatePortals(){
        portals = portals.filter({ (p) -> Bool in
            return !p.isClosed
        })
    }
    func updateEnemies(){
        for e in enemies {
            var dx:CGFloat = e.position.x - targetPos.x
            var dy:CGFloat = e.position.y - targetPos.y
            dx = (dx > e.maxSpeed ? e.maxSpeed : dx) + CGFloat.random(in: -40...40)
            dy = (dy > e.maxSpeed ? e.maxSpeed : dy) + CGFloat.random(in: -40...40)
            e.position.x -= dx * 0.03
            e.position.y -= dy * 0.03
        }
        enemies = enemies.filter({ (e) -> Bool in
            return !e.isDeadBool
        })
        for e in self.children {
            if let enemy = e as? EnemyNode {
                if enemy.isDeadBool {
                    enemy.removeFromParent()
                }
            }
        }
    }
    @objc func updateTimers(){
        let newPortalSpawn = portalSpawnTimer!.timeInterval * 1.1
        let newEnemySpawn = enemySpawnTimer!.timeInterval * 0.9
        portalSpawnTimer?.invalidate()
        enemySpawnTimer?.invalidate()
        portalSpawnTimer = Timer.scheduledTimer(timeInterval: newPortalSpawn, target: self, selector: #selector(spawnPortal), userInfo: nil, repeats: true)
        enemySpawnTimer = Timer.scheduledTimer(timeInterval: newEnemySpawn, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: true)
    }
    
    //MARK: Menu Management
    func showMenu(){
        scoreLabel!.text = "Game Over: " + String(score)
        bestScoreLabel!.text = "Best Score: " + String(utils.getBestScore())
        playButton?.show()
        bestScoreLabel?.show()
        scoreLabel?.hide()
        scoreLabel?.show()
        soundsButton?.show()
        lifesLabel?.hide()
        pauseButton?.hide()
    }
    func hideMenu(){
        playButton?.hide()
        bestScoreLabel?.hide()
        soundsButton?.hide()
        pauseButton?.show()
        lifesLabel?.show()
    }
}
