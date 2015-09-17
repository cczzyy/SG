--
-- Author: dante
-- Date: 2015-09-09 09:21:30
--

local scheduler = require("framework.scheduler")
--local FlyText = require("app.utils.FlyText")

local BaseRole = class("BaseRole", function(params)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("zhaoyun.ExportJson")
    return  ccs.Armature:create("zhaoyun")
end)

function BaseRole:ctor()
    self:getAnimation()
    local name = "components.behavior.StateMachine"
    cc.GameObject.extend(self)
        :addComponent(name)
        :exportMethods()

    local component = self:getComponent(name)
    print(tolua.type(component))
    local eventss = {
        {name = "start", from = "none",   to = "idle"},
        {name = "Run",  from = {"idle","runback","run","sprint"} ,to = "run"},
        {name = "runBack",  from = {"idle","run","runback","sprint"}, to = "runback"},
        {name = "Sprint",  from = {"idle","run","runback","sprint"}, to = "sprint"},
        {name = "attack",  from = "idle",  to = "attack_1"},
        {name = "attack",  from = "attack_4","run",to = "attack_1"},
        {name = "attack",  from = "run",to = "attack_4"},
        {name = "attack",  from = "idle",to = "attack_4"},
    }
    for i = 2,4 do
        table.insert(eventss, {name = "attack", from = "attack_" ..(i-1), to = "attack_" ..i})
    end
    for i = 1,4 do
        table.insert(eventss, {name = "stop", from = "attack_" ..i, to = "idle"})
    end
    for i = 1,4 do
        table.insert(eventss, {name = "Run", from = "attack_" ..i, to = "run"})
    end
    for i = 1,4 do
        table.insert(eventss, {name = "runBack", from = "attack_" ..i, to = "runback"})
    end
    table.insert(eventss, {name = "stop", from = "attack_4", to = "idle"})
    table.insert(eventss, {name = "stop", from = "run", to = "idle"})
    table.insert(eventss, {name = "stop", from = {"runback","sprint"},to = "idle"})
    dump(eventss)
    dump(component.map_)
    self:setupState({
        events = eventss,
        callbacks = {
            onstart = function(event) 
                self:getAnimation():play(event.to) 
            end,
            
            onrun  = function(event) 
                self:getAnimation():play(event.to)
            end,

            onrunBack  = function(event) 
                self:getAnimation():play(event.to)
            end,

            onSprint = function(event)
            -- self:getAnimation():play(event.to)
            --     if self:getAnimation():play(event.to) then
            --         self:doForceEvent("stop")
            --     end
            --         print(event.name)
            end,

            onattack = function(event) 
                if self:getState() == "attack_4" then
                    self:getAnimation():play(event.to)
                    return
                end
                self:performWithDelay(function()
                    self:getAnimation():play(event.to)
                end, 0.03)
                
            end,

            onstop = function(event) 
                self:performWithDelay(function()
                    self:getAnimation():play(event.to)
                end, 0.03)
            end,

            onleavestate = function (event)
                print(event.from)    
            end
            }
    })
    dump(component.map_)
    if self:canDoEvent("start") then
        self:doEvent("start")
    end
    
    self:getAnimation():setMovementEventCallFunc(function(ref, moventType, moventID)
        self.moventType = moventType
        if moventType == 2  then
            if self:getState() == "attack_3" then
                self:doEvent("attack")
                return
            end

            -- if self.longPress or self.timer <= 60 then
            --     if self:canDoEvent("attack") then
            --         self:doEvent("attack")
            --     end
            -- else
            --     if self:canDoEvent("stop") then
            --         self:doEvent("stop")
            --     end
            --end
        end

    end)

    --local sche=scheduler.scheduleUpdateGlobal(handler(self, self.updatel),0.1)
    --scheduler.scheduleUpdateGlobal((handler(self, self.updatePosition)),0.01)
    self.timer = 0
    self.longPress = false
    self.moventType = 0

end

function BaseRole:updatel(dt)
    self.timer = self.timer + 1
end

-- function BaseRole:updatePosition(dt)
--     if  self:getState() == "run" then
--         self:setPosition(self:getPositionX()+3.0,self:getPositionY())
--     end
--     if self:getState() == "runback" then
--         self:setPosition(self:getPositionX()-3.0,self:getPositionY())
--     end
-- end

function BaseRole:fallHP(str)
    local flyText = FlyText.new(str)
    flyText:startFlyTextAnimation()
    self:addChild(flyText)
end

return BaseRole