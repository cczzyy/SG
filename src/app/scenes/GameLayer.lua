
local GameLayer = class("GameLayer", function()
    return display.newScene("GameLayer")
end)
local scheduler = require("framework.scheduler")
local background
local role
local door
local enemy
local coll=false
local collBing=false
function GameLayer:ctor()
   self:init()
   self:UILayer()
   local a=role:getChildByName("weapon0")
   print(a:getContentSize().width)
   --schedule_collision=scheduler.scheduleUpdateGlobal(handler(self, self.update),0.1)
end

function GameLayer:init()
   background=require("app.classes.BackGround"):ctor():addTo(self)
   local fourth=background:getChildByTag(100)
   role=require("app.classes.BaseRole").new()
   role:setPosition(cc.p(280, 300))
   fourth:addChild(role)
   enemy = require("app.classes.Enemy").new()
   enemy:pos(1000, 250)
   enemy:setAnchorPoint(cc.p(0.5,0.5))
   fourth:addChild(enemy)
   door=background:getChildByTag(101):getChildByTag(1122)
end

function GameLayer:UILayer()
	local gameUi=background:getChildByTag(102)
	local m=gameUi:getChildByTag(101)
      m:addTouchEventListener(function(sender,eventType)
           if eventType == ccui.TouchEventType.began then
           	 scheduler_run=scheduler.scheduleUpdateGlobal(handler(self, self.updateRun),0.1)
             role:doEvent("Run")
            elseif eventType == ccui.TouchEventType.ended then
            if cc.rectContainsPoint(role:getBoundingBox(),cc.p(door:getPositionX()-170,door:getPositionY()))==false then
              scheduler.unscheduleGlobal(scheduler_run)
              role:doEvent("stop") 
            end
                 
           end
     end)
     local m=gameUi:getChildByTag(100)
      m:addTouchEventListener(function(sender,eventType)
           if eventType == ccui.TouchEventType.began then
           	scheduler_back=scheduler.scheduleUpdateGlobal(handler(self, self.updateBack),0.1)
             role:doEvent("runBack")
            elseif eventType == ccui.TouchEventType.ended then
            scheduler.unscheduleGlobal(scheduler_back)
             role:doEvent("stop")
            end
     end)        
end

function GameLayer:collisionDoor()
         if cc.rectContainsPoint(role:getBoundingBox(),cc.p(door:getPositionX()-170,door:getPositionY()))==true then
              scheduler.unscheduleGlobal(scheduler_run)
              role:doEvent("attack")
         end   
end

function GameLayer:collisionEnemy()
      if (enemy:getPositionX()>400)and(cc.rectContainsPoint(role:getBoundingBox(),cc.p(enemy:getPositionX()-10,enemy:getPositionY()))==false) then
        transition.moveTo(enemy, {x = enemy:getPositionX()-2, y = enemy:getPositionY(), time =0.1})
        enemy:doEvent("idle")
        else
        enemy:doEvent("attack")
     end
      -- if cc.rectContainsPoint(enemy:getBoundingBox(),cc.p(role:getPositionX(),role:getPositionY()))==true then
      --   if collBing==false then
      --      enemy:doEvent("attack")
      --   end
      --   collBing=true
      -- end
       if cc.rectContainsPoint(role:getChildByName("weapon0"):getBoundingBox(),cc.p(emeny:getPositionX(),emeny:getPositionY()))==true then
       print("<<<<<<<<<<<<<<<<<<<")
      end
      if cc.rectContainsPoint(role:getBoundingBox(),cc.p(enemy:getPositionX()-100,enemy:getPositionY()))==true then
         if coll==false then
           role:doEvent("attack")
           transition.moveTo(enemy, {x = enemy:getPositionX()+250, y = enemy:getPositionY(), time =0.1})
         end
            coll=true
      end        
end
function GameLayer:update(dt)
	 self:collisionEnemy()
end
function GameLayer:updateRun(dt)
   self:collisionDoor()
	 transition.moveTo(role, {x = role:getPositionX()+3.2, y = role:getPositionY(), time =0.1})
	 if role:getPositionX()>500 then
	  	require("app.classes.BackGround"):BackGroundGo()
	  end 
end

function GameLayer:updateBack(dt)
	if role:getPositionX()>200 then
		 transition.moveTo(role, {x = role:getPositionX()-3.2, y = role:getPositionY(), time =0.1})
	end
	if role:getPositionX()<2000 then
	 	 require("app.classes.BackGround"):BackGroundBack()
	end
end

return GameLayer
