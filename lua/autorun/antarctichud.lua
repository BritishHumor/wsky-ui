--[[---------------------------------------------------------------------------
Which default HUD elements should be hidden?
---------------------------------------------------------------------------]]

local hideHUDElements = {
  ["DarkRP_HUD"] = false,

  ["DarkRP_EntityDisplay"] = false,

  ["DarkRP_LocalPlayerHUD"] = true,

  ["DarkRP_Hungermod"] = false,

  ["DarkRP_Agenda"] = true,

  ["DarkRP_LockdownHUD"] = true,

  ["DarkRP_ArrestedHUD"] = true,
}

if SERVER then
  AddCSLuaFile()
  resource.AddFile("materials/antarcticIcons/credit-card.png")
  resource.AddFile("materials/antarcticIcons/heart.png")
  resource.AddFile("materials/antarcticIcons/heart-broken.png")
  resource.AddFile("materials/antarcticIcons/shield.png")
  resource.AddFile("materials/antarcticIcons/wallet.png")
  resource.AddFile("materials/antarcticIcons/file-alt.png")

  resource.AddFile("resources/fonts/OswaldBold.ttf")
  resource.AddFile("resources/fonts/OswaldExtraLight.ttf")
  resource.AddFile("resources/fonts/OswaldLight.ttf")
  resource.AddFile("resources/fonts/OswaldMedium.ttf")
  resource.AddFile("resources/fonts/OswaldRegular.ttf")
  resource.AddFile("resources/fonts/OswaldSemiBold.ttf")

  return
end

-- this is the code that actually disables the drawing.
hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", function(name)
  if hideHUDElements[name] then return false end
end)

-- if true then return end -- REMOVE THIS LINE TO ENABLE THE CUSTOM HUD BELOW

--[[---------------------------------------------------------------------------
The Custom HUD
only draws health
---------------------------------------------------------------------------]]
local Health = 0

function draw.Circle( x, y, radius, seg )
local cir = {}

table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
for i = 0, seg do
  local a = math.rad( ( i / seg ) * -360 )
  table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
end

local a = math.rad( 0 ) -- This is needed for non absolute segment counts
table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

surface.DrawPoly( cir )
end

function comma_value(amount)
  if (amount) then
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
  end
end

function round(val, decimal)
  if (val) then
    if (decimal) then
      return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
    else
      return math.floor(val+0.5)
    end
  end
end

function format_num(amount, decimal, prefix, neg_prefix)
  if (amount) then
    local str_amount,  formatted, famount, remain

    decimal = decimal or 2  -- default 2 decimal places
    neg_prefix = neg_prefix or "-" -- default negative sign
  
    famount = math.abs(round(amount,decimal))
    famount = math.floor(famount)
  
    remain = round(math.abs(amount) - famount, decimal)
  
          -- comma to separate the thousands
    formatted = comma_value(famount)
  
          -- attach the decimal portion
    if (decimal > 0) then
      remain = string.sub(tostring(remain),3)
      formatted = formatted .. "." .. remain ..
                  string.rep("0", decimal - string.len(remain))
    end
  
          -- attach prefix string e.g '$' 
    formatted = (prefix or "") .. formatted 
  
          -- if value is negative then format accordingly
    if (amount<0) then
      if (neg_prefix=="()") then
        formatted = "("..formatted ..")"
      else
        formatted = neg_prefix .. formatted 
      end
    end
  
    return formatted
  end
end

surface.CreateFont("OswaldRP", {
  font = "Oswald",
  size = 24
})

Icons = {}

Icons['wallet'] = Material("antarcticIcons/wallet.png", "smooth")
Icons['credit-card'] = Material("antarcticIcons/credit-card.png", "smooth")
Icons['gun-license'] = Material("antarcticIcons/file-alt.png", "smooth")

Icons['shield'] = Material("antarcticIcons/shield.png", "smooth")
Icons['heart'] = Material("antarcticIcons/heart.png", "smooth")
Icons['heart-broken'] = Material("antarcticIcons/heart-broken.png", "smooth")

local health = 0

local function hudPaint()
  local padding = 5
  -- local hudX, hudY = (ScrW() * 0.3) - (padding * 2), (ScrH() * 0.20)
  local hudX, hudY = 502, 192

  local player = LocalPlayer()

  local currency = "£"
  local name = player:Name()
  local job = player:getDarkRPVar('job')
  local salary = player:getDarkRPVar('salary')
  local wallet = player:getDarkRPVar('money')

  local hasLicense = player:getDarkRPVar('HasGunlicense')

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

  -- surface.SetDrawColor(75, 75, 75, 125)
  -- surface.DrawRect(padding, ScrH() - (hudY + padding), 200, hudY - 05)

  if (!Avatar) then
    Avatar = vgui.Create( "AvatarImage", Panel )
    if (player:IsValid() && IsValid(Avatar)) then
      Avatar:SetSize( 90, 90 )
      Avatar:SetPos( padding + 5, ScrH() - hudY )
      Avatar:SetPlayer( player, 90 )
    end
  end


  -- surface.SetDrawColor(255, 255, 255, 25)
  surface.SetDrawColor(88, 40, 238, 125)
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
    draw.DrawText(currency, "OswaldRP", padding + 450, ScrH() - (hudY + padding - 115), Color(255,255,255,255), TEXT_ALIGN_RIGHT)
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
  surface.DrawTexturedRect(padding + 10, ScrH() - (hudY + padding - 175), 32, 32)

end

hook.Add("HUDPaint", "DarkRP_Mod_HUDPaint", hudPaint)
