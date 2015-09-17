local Enemy = class("Enemy",function()
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("qiangbingdonghua.ExportJson")
	return ccs.Armature:create("qiangbingdonghua")
end)

local scheduler = require("framework.scheduler")

function Enemy:ctor()
	self:getAnimation():play("qiangbingzoulu")
	self:addStateMachine()	
end

function Enemy:addStateMachine()
	cc.GameObject.extend(self):addComponent("components.behavior.StateMachine"):exportMethods()
	self:setupState({
		initial="qiangbingzoulu",
		events={
			{name="idle",      from={"qiangbinggongji","qiangbinggongji_2","qiangbingbeigongji"},to="qiangbingzoulu"},
			{name="attack",    from={"qiangbingzoulu"},to="qiangbinggongji"},
			{name="attack1",   from={"qiangbinggongji"},to="qiangbinggongji_2"},
			{name="Beattacked",from={"qiangbingzoulu","qiangbinggongji","qiangbinggongji_2","qiangbingbeigongji"},to="qiangbingbeigongji"},
			{name="death",     from={"qiangbingzoulu","qiangbingbeigongji"},to="qiangbingsiwang"}
		},
		callbacks={
			onidle=function(event)
				self:getAnimation():play(event.to)
			end,
			onattack=function(event)
				self:performWithDelay(function()
                    self:getAnimation():play(event.to)
                end, 0.07)
			end,
			onBeattacked=function(event)
				self:getAnimation():play(event.to)
			end,
			ondeath=function(event)
				self:getAnimation():play(event.to,-1,0)
			end
		}

		})
end
return Enemy