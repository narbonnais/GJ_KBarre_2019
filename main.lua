local sceneManager = nil

function love.load()
    love.graphics.setDefaultFilter("nearest")
    io.stdout:setvbuf("no")

    local SceneManager = require("lib.SceneManager")
    local SceneMenu = require("src.scenes.SceneMenu")
    local SceneNarration = require("src.scenes.SceneNarration")
    local SceneChoiceBase = require("src.scenes.SceneChoiceBase")
    local SceneTransitionImage = require("src.scenes.SceneTransitionImage")
    local SceneGameBall = require("src.scenes.SceneGameBall")
    local SceneFinal = require("src.scenes.SceneFinal")

    local PathsVerification = require("tests.PathsVerification")

    -- create scene manager
    sceneManager = SceneManager()

    -- create player
    local player = require("src.objects.Player")()
    
    -- register scenes
    local SceneData = require("data.SceneData")
    sceneManager:register("menu", SceneMenu(sceneManager))
    sceneManager:register("transition", SceneTransitionImage(sceneManager))
    for k, v in pairs(SceneData) do
        if v.type == "choice" then
            sceneManager:register(k, SceneChoiceBase(sceneManager, v, player))
        elseif v.type == "narrative" then
            sceneManager:register(k, SceneNarration(sceneManager, v))
        elseif v.type == "game" then
            local Scene = require("src.scenes." .. v.scene)
            sceneManager:register(k, Scene(sceneManager, v, player))
        elseif v.type == "final" then
            sceneManager:register(k, SceneFinal(sceneManager, v, player))
        end
    end

    --PathsVerification(SceneData, "Beginning")

    -- load start scene by default
    
    sceneManager:load("Beginning")
    --sceneManager:load("Ball")
end

function love.update(dt) sceneManager:update(dt) end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    sceneManager:draw()
end

function love.keypressed(k) sceneManager:keyPressed(k) end

function love.keyreleased(k) sceneManager:keyReleased(k) end
