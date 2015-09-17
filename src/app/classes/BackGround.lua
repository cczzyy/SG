--
-- Author: zhangyang
-- Date: 2015-09-14 19:27:50
--
local BackGround=class("BackGround", function()
	return display.newSprite("BackGround")
end)
local second
local third
local fourth
local fivth
function BackGround:ctor()
	local bg=cc.Node:create()
	cc.uiloader:load("FirstLayer.csb"):addTo(bg)
    second=cc.uiloader:load("SceondLayer.csb"):addTo(bg)
    third=cc.uiloader:load("ThirdLayer.csb"):addTo(bg)
    fourth=cc.uiloader:load("FouthLayer.csb"):setTag(100):addTo(bg)
    fivth=cc.uiloader:load("FivthLayer.csb"):setTag(101):addTo(bg)
    cc.uiloader:load("gamelayer.csb"):setTag(102):addTo(bg)
    return bg	
end
function BackGround:BackGroundGo()
  if fourth:getPositionX()>-1628 then
        transition.moveTo(second, {x = second:getPositionX()-1, y = second:getPositionY(), time =0.1})
        transition.moveTo(third, {x = third:getPositionX()-1.5, y = third:getPositionY(), time =0.1})
        transition.moveTo(fourth, {x = fourth:getPositionX()-3, y = fourth:getPositionY(), time =0.1})
        transition.moveTo(fivth, {x = fourth:getPositionX()-3, y = fourth:getPositionY(), time =0.1})
     end  
end
--背景后退
function BackGround:BackGroundBack()
 if fourth:getPositionX()<-20 then
        transition.moveTo(second, {x = second:getPositionX()+1, y = second:getPositionY(), time =0.1})
        transition.moveTo(third, {x = third:getPositionX()+1.5, y = third:getPositionY(), time =0.1})
        transition.moveTo(fourth, {x = fourth:getPositionX()+3, y = fourth:getPositionY(), time =0.1})
        transition.moveTo(fivth, {x = fourth:getPositionX()+3, y = fourth:getPositionY(), time =0.1})

 end
end


return BackGround