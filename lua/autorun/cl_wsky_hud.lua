

include( "shared/math.lua" )

local hideHUDElements = {
  ["DarkRP_HUD"] = false,

  ["DarkRP_EntityDisplay"] = false,

  ["DarkRP_LocalPlayerHUD"] = true,

  ["DarkRP_Hungermod"] = false,

  ["DarkRP_Agenda"] = true,

  ["DarkRP_LockdownHUD"] = true,

  ["DarkRP_ArrestedHUD"] = true,
}

hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", function(name)
  if hideHUDElements[name] then return false end
end)

local Health = 0

surface.CreateFont("OswaldRP", {
  font = "Oswald",
  size = 24
})

Icons = {}

Icons['wallet'] = Material("antarcticIcons/wallet.png", "smooth")
Icons['credit-card'] = Material("antarcticIcons/credit-card.png", "smooth")

Icons['gun-license'] = Material("antarcticIcons/file-alt.png", "smooth")
Icons['handcuffs'] = Material("antarcticIcons/handcuffs.png", "smooth")

Icons['shield'] = Material("antarcticIcons/shield.png", "smooth")
Icons['heart'] = Material("antarcticIcons/heart.png", "smooth")
Icons['heart-broken'] = Material("antarcticIcons/heart-broken.png", "smooth")

local health = 0
local currency = "£"
local padding = 5
local hudX, hudY = 502, 192
local currentSequence = 0

local function hudPaint()

  local player = LocalPlayer()
  local name = player:Name()
  local job = player:getDarkRPVar('job')
  local salary = player:getDarkRPVar('salary')
  local wallet = player:getDarkRPVar('money')

  local hasLicense = player:getDarkRPVar('HasGunlicense')
  local arrested = player:getDarkRPVar('Arrested')

  local rawHealth  = player:Health()
  health = math.min(100, (health == player:Health() and health) or Lerp(0.1, health, player:Health()))

  local armor = 0
  local rawArmor  = player:Armor()
  if (rawArmor > 0) then
    armor = rawArmor
  else
    armor = 0
  end

  local heartBeatHealth = 25
  local heartBeat = ((player:Health() < heartBeatHealth && player:Health() > 0) and math.abs( math.sin( CurTime( ) * math.Clamp(heartBeatHealth - player:Health(), 0, 7) ) * 5 ) or 0)

  local healthPadding = (health / 10 / 2)

  -- Pengu Purple
  -- surface.SetDrawColor(88, 40, 238, 255)

  surface.SetDrawColor(50, 50, 50, 240)
  surface.DrawRect(padding, ScrH() - (hudY + padding), hudX, hudY)

  -- if (!Avatar) then
  --   Avatar = vgui.Create( "AvatarImage", Panel )
  -- end
  
  -- if (player:IsValid() && IsValid(Avatar)) then
  --   local avatarSize = 90
  --   Avatar:SetSize(avatarSize, avatarSize )
  --   Avatar:SetPos( padding + 5, ScrH() - hudY )
  --   Avatar:SetPlayer( player, avatarSize )
  -- end

      if (!BGPanel) then
        BGPanel = vgui.Create( "DPanel" )
        BGPanel:SetPos( padding + 5, ScrH() - hudY )
        BGPanel:SetSize( 90, 90 )
        BGPanel:SetBackgroundColor( Color( 0, 0, 0, 125 ) )
      end
      
        if (!mdl) then
          mdl = vgui.Create( "DModelPanel", BGPanel )
          mdl:SetSize( BGPanel:GetSize() )
          mdl:SetAnimated(true)
        end

        local currentModel = LocalPlayer():GetModel()

        if (mdl:GetModel() != currentModel) then
          mdl:SetModel( currentModel )
          function mdl:LayoutEntity( ent )
            if (currentSequence == 0) then
              animations = ent:GetSequenceList()
              for index, value in ipairs(animations) do
                if (currentSequence == 0) then
                  if (string.find(value, "gman")) then
                    currentSequence = index
                    print("current Sequence set to " .. index)
                  end
                end
              end
              if (currentSequence == 0) then
                for index, value in ipairs(animations) do
                  if (currentSequence == 0) then
                    if (string.find(value, "idle")) then
                      currentSequence = index
                      print("current Sequence set to " .. index)
                    end
                  end
                end
              end
            end
            if (ent:GetSequence() != currentSequence) then
              ent:ResetSequence( currentSequence )
              print("changing animation to sequence: " .. currentSequence)
              mdl:RunAnimation()
            end
          end
        end
        
        local eyepos = mdl.Entity:GetBonePosition( mdl.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
        
        eyepos:Add( Vector( -20, 0, -1 ) )
        
        mdl:SetLookAt( eyepos )
        
        mdl:SetCamPos( eyepos-Vector( -35, 0, 0 ) )
        
        mdl.Entity:SetEyeTarget( eyepos-Vector( -30, 0, 0 ) )

  surface.SetDrawColor(255, 255, 255, 25)

  surface.DrawRect(padding, ScrH() - hudY - 5, 100, 100)

  surface.DrawRect(padding + 100, ScrH() - (hudY + padding), hudX - 100, 30)

  draw.DrawText(name, "OswaldRP", padding + 105, ScrH() - (hudY + padding) + 2, Color(255, 255, 255, 255), 0)

  if (job) then
    draw.DrawText(job:upper(), "OswaldRP", padding + 45.5 + 5, ScrH() - (hudY + padding - 115), Color(255,255,255,255), 1)
  end
  if (salary) then
    draw.DrawText(currency .. salary, "OswaldRP", padding + 45.5 + 5, ScrH() - (hudY + padding - 155), Color(255,255,255,255), 1)
  end

  --  health Bar
  surface.SetDrawColor(0, 0, 0, 125)
  surface.DrawRect(padding + 123, ScrH() - (hudY + padding - 37), hudX - 123 - 5, 28)

  surface.SetDrawColor(197, 0, 51, 255)
  surface.DrawRect(padding + 123, ScrH() - (hudY + padding - 38), (hudX - 123 - 5) * (math.Clamp(health, 0, 100) / 100), 26)

  surface.SetMaterial(player:Health() > 0 and Icons['heart'] or Icons['heart-broken'])
  surface.SetDrawColor(237 - (heartBeat * 30), 20, 91, 255)
  surface.DrawTexturedRect(padding + 105 - (heartBeat / 2), ScrH() - (hudY + padding - 35) - (heartBeat / 2), 32 + heartBeat, 32 + heartBeat)

  draw.DrawText(math.Round(rawHealth), "OswaldRP", padding + hudX - 10, ScrH() - (hudY + padding - 37), Color(255,255,255,255), TEXT_ALIGN_RIGHT)

  --  armor Bar
  surface.SetDrawColor(0, 0, 0, 125)
  surface.DrawRect(padding + 123, ScrH() - (hudY + padding - 77), hudX - 123 - 5, 28)

  surface.SetDrawColor(0, 74, 148, 255)
  surface.DrawRect(padding + 123, ScrH() - (hudY + padding - 78), (hudX - 123 - 5) * (math.Clamp(armor, 0, 100) / 100), 26)

  surface.SetMaterial(Icons['shield'])
  surface.SetDrawColor(0, 114, 188, 255)
  surface.DrawTexturedRect(padding + 105, ScrH() - (hudY + padding - 75), 32, 32)

  draw.DrawText(armor, "OswaldRP", padding + hudX - 10, ScrH() - (hudY + padding - 78), Color(255,255,255,255), TEXT_ALIGN_RIGHT)

  --  Wallet Amount

  if (wallet) then
    draw.DrawText(currency .. format_num(wallet, 0), "OswaldRP", padding + 450, ScrH() - (hudY + padding - 155), Color(255,255,255,255), TEXT_ALIGN_RIGHT)  

    surface.SetMaterial(Icons['wallet'])
    surface.SetDrawColor(255, 255, 255, 200)
    surface.DrawTexturedRect(padding + 460, ScrH() - (hudY + padding - 150), 32, 32)
  end
  --  ATM Amount
  if (atmBalance) then
    draw.DrawText(currency .. atmBalance, "OswaldRP", padding + 450, ScrH() - (hudY + padding - 115), Color(255,255,255,255), TEXT_ALIGN_RIGHT)
  end
    surface.SetMaterial(Icons['credit-card'])
    surface.SetDrawColor(255, 255, 255, 200)
    surface.DrawTexturedRect(padding + 460, ScrH() - (hudY + padding - 110), 32, 32)

  -- Gun License

  surface.SetMaterial(Icons['gun-license'])
  if (hasLicense) then
    surface.SetDrawColor(255, 255, 255, 200)
  else
    surface.SetDrawColor(0, 0, 0, 125)
  end
  surface.DrawTexturedRect(padding + 105, ScrH() - (hudY + padding - 115), 32, 32)

  -- Arrested

  surface.SetMaterial(Icons['handcuffs'])
  if (arrested) then
    surface.SetDrawColor(153, 243, 255, 200)
  else
    surface.SetDrawColor(0, 0, 0, 125)
  end
  surface.DrawTexturedRect(padding + 150, ScrH() - (hudY + padding - 115), 32, 32)

end

hook.Add("HUDPaint", "DarkRP_Mod_HUDPaint", hudPaint)
