--@name limited cl_showhitboxes
--@author Elias
--@client

--add vcollision mesh view
--recode, right now this is disorganized mess of stuff, come back later if you expected something else

if hasPermission("render.hud") then 
    return 
end

if player()==owner() then
    enableHud(owner(),true)
end

local aimTrace=owner():getEyeTrace()

hook.add("think","",function()
--[[
    if aimTrace.Entity and aimTrace.Entity!=owner():getEyeTrace().Entity and aimTrace.Entity:isValid() then
        aimTrace.Entity:setColor(Color(255,255,255,255))
        aimTrace.Entity:setMaterial("")
    end
]]
    
    aimTrace=owner():getEyeTrace()
    
    if aimTrace.Entity:isValid() and aimTrace.Entity!=chip() then
        boneCount=aimTrace.Entity:getHitBoxCount(0)
    end
end)

hook.add("postdrawtranslucentrenderables","",function() 
    try(function() --removes any nil hitboxes that plaque most models
        if aimTrace.Entity:isValid() then
            render.setColor(Color(255,255,255,255)) 
            render.draw3DWireframeBox(aimTrace.Entity:getPos(),aimTrace.Entity:getAngles(),aimTrace.Entity:obbMins(),aimTrace.Entity:obbMaxs())
            
            for i=0,boneCount do
                min,max,_=aimTrace.Entity:getHitBoxBounds(i,0)
                pos,ang=aimTrace.Entity:getBonePosition(aimTrace.Entity:getHitBoxBone(i,0))

                render.setColor(Color(i+pos.z/boneCount*20,1,1):hsvToRGB()) 
                render.draw3DWireframeBox(pos,ang,min,max)
                render.draw3DBeam(pos,aimTrace.Entity:getBonePosition(aimTrace.Entity:getHitBoxBone(i+1,0)),0.5,0,0)
                
--[[
                if boneCount>1 then
                    aimTrace.Entity:setColor(Color(255,255,255,100))
                    aimTrace.Entity:setMaterial("debug/env_cubemap_model")
                end
]]
            end
        end
    end)
end)

hook.add("drawhud","",function()
    try(function()
        for i=0,boneCount do
            local pos,_=aimTrace.Entity:getBonePosition(aimTrace.Entity:getHitBoxBone(i,0))
            local bonePos=pos:toScreen()
            local boneID=aimTrace.Entity:getBoneName(aimTrace.Entity:getHitBoxBone(i,0))

            render.setColor(Color(pos.z+i/boneCount*20,1,1):hsvToRGB()) 
            
            if aimTrace.Entity:getPos():getDistance(owner():getPos())<80 then
                render.drawText(bonePos.x,bonePos.y,boneID,1) ---string.len(boneID)*2
            end
        end
    end)
end)