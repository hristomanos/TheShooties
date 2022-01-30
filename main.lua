-- Welcome to The shooties game, 
-- a game where two blocks shoot each other with 3 power-ups(med-Kit,guns-Blazin and Slow Down!) stationed in the center.
function love.load()
	bg = love.graphics.newImage("bg.png")
  remaining_time = 180 -- Timer
  gameState = 0 -- 0 = Menu, 1 = Gameplay, 2 = Red wins!, 3 = Blue wins!, 4 = Draw (Timer = 0)
  restartGame = false
  -- Sounds
  --sdPirates = love.audio.newSource("pirates.mp3")
  sdpipe_shot = love.audio.newSource("pipeShot.wav")
  sdpipe_shot2 = love.audio.newSource("pipeShot.wav")
  sdVictory = love.audio.newSource("victory.wav")
  playOnce_sdVictory = false
  sdSlowDown = love.audio.newSource("slowDown.wav")
  sdSlowDown : setVolume(0.2)
  sdMedKit = love.audio.newSource("medKit.wav")
  sdGunsBlazing = love.audio.newSource("gunsBlazing.wav")
  sdStartShootin = love.audio.newSource("pop.wav")
  sdStartShootin2 = love.audio.newSource("pop.wav")
  sdWalls = love.audio.newSource("walls.wav")
  
  respawnTimeSlowDown = 10 -- respawns time for Slow down
  spawnSlowDown = true -- Spawn slow down if true
  currTimeSlowDown = respawnTimeSlowDown;
  durationSlowDown = 5 -- How long does slow down last? it's in seconds
  slowDownHero = false -- Power up is not activated
  slowDownHero2 = false -- Power up is not activated
  slowDown = {}
  slowDown.x = 400
  slowDown.y = 300
  slowDown.width = 20
  slowDown.height = 20
  table.insert(slowDown, slowDown)
  
  respawnTimeGunsBlazing = 14 -- respawns time for Guns blazing
  spawnGunsBlazing = true -- Spawn guns blazing if true
  currTimeGunsBlazing = respawnTimeGunsBlazing;
  durationGunsBlazing = 7 -- How long does guns blazing last? it's in seconds
  gunsBlazingHero = false -- Power up is not activated
  gunsBlazingHero2 = false -- Power up is not activated
  gunsBlazing = {}
  gunsBlazing.x = 400
  gunsBlazing.y = 200
  gunsBlazing.width = 20
  gunsBlazing.height = 20
  table.insert(gunsBlazing, gunsBlazing)
  
  respawnTimeMedKit = 15 -- respawns time for med-kit
  spawnMedKit = true -- Spawn Med kit if true
  currTimeMedKit = respawnTimeMedKit;
  medKit = {}
  medKit.x = 400
  medKit.y = 100
  medKit.width = 20
  medKit.height = 20
  medKit.addHealth = 15
  table.insert(medKit, medKit)
  
  rectWidthHero = 127 -- rectangle width for Hero health bar
  hero = {} -- new table for hero1
	hero.x = 50	-- x,y coordinates of hero1
	hero.y = 232
	hero.width = 15
	hero.height = 35
	hero.speed = 200
  hero.maxHealth = 100
  hero.curHealth = 100
  hero.can_fire = true -- Player can shoot if true
  hero.fire_wait = 0.3 -- Delay between shots
  hero.fire_tick = 0 -- count the seconds
	hero.shots = {} -- holds our fired shots
	
  rectWidthHero2 = 127 -- Health bar
  hero2 = {} -- new table for the hero 2
	hero2.x = 750	-- x,y coordinates of the hero 2
	hero2.y = 232
	hero2.width = 15
	hero2.height = 35
	hero2.speed = 200
  hero2.curHealth = 100
  hero2.maxHealth = 100
  hero2.can_fire = true -- Player can shoot if true
  hero2.fire_wait = 0.4 -- Delay between shots
  hero2.fire_tick = 0 -- count the seconds
	hero2.shots = {}
  
	brickWall = {}
	for i=0,9 do
		brick = {}
		brick.width = 20
		brick.height = 40
		brick.y = i * (brick.height + 5) + 10
		brick.x = brick.height + 100
		table.insert(brickWall, brick)
	end
	
  stoneWall = {}
	for i=0,9 do
		stone = {}
		stone.width = 20
		stone.height = 40
		stone.y = i * (brick.height + 5) + 10
		stone.x = brick.height + 600
		table.insert(stoneWall, stone)
	end
	
end

function love.keypressed(key)
  if (gameState == 1) then
	if (key == "space") then
		if hero.can_fire then
     if gunsBlazingHero then
      sdStartShootin:play()
     else
      sdpipe_shot:play()
     end
      heroShoots()
    hero.can_fire = false
	end
end
  if (key == "left") then
    if hero2.can_fire then
      if gunsBlazingHero2 then
      sdStartShootin2:play()
     else
      sdpipe_shot2:play()
     end
      hero2Shoots()
      hero2.can_fire = false
    end
	end
end
 if(key == "return" or "enter") then -- gameplay
    gameState = 1
  end
  if (key == "r") then
    restartGamawwwwe = true
  end
end
function love.update(dt)
  --sdPirates:play()
  --Health bar update
  AddjustCurrentHeroHealth(0)
  AddjustCurrentHero2Health(0)
  if (gameState == 1) then
  --Update game countDown
  remaining_time = remaining_time - dt
-- Update rate of fire timer
if not hero.can_fire then
  hero.fire_tick = hero.fire_tick + dt
    if hero.fire_tick > hero.fire_wait then
      hero.can_fire = true
      hero.fire_tick = 0
    end
end
if not hero2.can_fire then
  hero2.fire_tick = hero2.fire_tick + dt
    if hero2.fire_tick > hero2.fire_wait then
      hero2.can_fire = true
      hero2.fire_tick = 0
    end
end

	-- keyboard actions for hero1
	if love.keyboard.isDown("w") then
		hero.y = hero.y - hero.speed*dt
	elseif love.keyboard.isDown("s") then
		hero.y = hero.y + hero.speed*dt
  end
	-- Keyboard actions for hero2
  if love.keyboard.isDown("up") then
		hero2.y = hero2.y - hero2.speed*dt
	elseif love.keyboard.isDown("down") then
		hero2.y = hero2.y + hero2.speed*dt
	end
  
	local remStone = {}
  local remBrick = {}
	local remHeroShot = {}
	local remHero2Shot = {}
  local remMedKit = {}
  local remGunsBlazing = {}
  local remSlowDown = {}
  
	-- update the heroes' shots
	for i,v in ipairs(hero.shots) do
    
		-- move them to the right
		v.x = v.x + dt * 700  
		-- mark shots that are not visible for removal
		if v.x > 800 then
			table.insert(remHeroShot, i)
		end  
		-- check for collision with wall
		for ii,vv in ipairs(stoneWall) do
			if CheckCollision(v.x,v.y,5,2,vv.x,vv.y,vv.width,vv.height) then    
        sdWalls: play()
				-- mark that stone for removal
				table.insert(remStone, ii)
				-- mark the shot to be removed
				table.insert(remHeroShot, i)    
			end
		end     
    -- Check for collistion with hero2
    if CheckCollision(v.x,v.y,5,2,hero2.x,hero2.y,hero2.width,hero2.height) then
      hero2.curHealth = hero2.curHealth - 10
      table.insert(remHeroShot,i)
    end
    
    --Check for collision with medical Kit
    if hero.curHealth < 100 then
      for iii,vvv in ipairs(medKit) do
        if CheckCollision(v.x,v.y,5,2,vvv.x,vvv.y,vvv.width,vvv.height) then
          sdMedKit:play()
          hero.curHealth = hero.curHealth + medKit.addHealth
          table.insert(remMedKit,iii)
          spawnMedKit = false
        end
      end
    end
    --Check for collision with Guns Blazing
      for iii,vvv in ipairs(gunsBlazing) do
        if CheckCollision(v.x,v.y,5,2,vvv.x,vvv.y,vvv.width,vvv.height) then
          sdGunsBlazing:play()
          gunsBlazingHero = true
          table.insert(remGunsBlazing,iii)
          spawnGunsBlazing = false
        end
      end
      
      --Check for collision with Slow down
      for iii,vvv in ipairs(slowDown) do
        if CheckCollision(v.x,v.y,5,2,vvv.x,vvv.y,vvv.width,vvv.height) then
          sdSlowDown:play()
          slowDownHero = true
          table.insert(remSlowDown,iii)
          spawnSlowDown = false
        end
      end
      
  end
  for i,v in ipairs(hero2.shots) do
	
		-- move them to the left
		v.x = v.x + dt * -700
		
		-- mark shots that are not visible for removal
		if v.x < 0 then
			table.insert(remHero2Shot, i)
		end
    for ii,vv in ipairs(brickWall) do
			if CheckCollision(v.x,v.y,5,2,vv.x,vv.y,vv.width,vv.height) then
				sdWalls: play()
				-- mark that brick for removal
				table.insert(remBrick, ii)
				-- mark the shot to be removed
				table.insert(remHero2Shot, i)
				
			end
		end   
		-- check for collision with hero
		if CheckCollision(v.x,v.y,5,2,hero.x,hero.y,hero.width,hero.height) then
			hero.curHealth = hero.curHealth - 10
      table.insert(remHero2Shot, i)
		end  
    
    --Check for collision with medical Kit
    if hero2.curHealth < 100 then
      for iii,vvv in ipairs(medKit) do
        if CheckCollision(v.x,v.y,5,2,vvv.x,vvv.y,vvv.width,vvv.height) then
          sdMedKit:play()
          hero2.curHealth = hero2.curHealth + medKit.addHealth
          table.insert(remMedKit,iii)
          spawnMedKit = false
        end
      end
    end
    
    --Check for collision with Guns Blazing
      for iii,vvv in ipairs(gunsBlazing) do
        if CheckCollision(v.x,v.y,5,2,vvv.x,vvv.y,vvv.width,vvv.height) then
          sdGunsBlazing:play()
          gunsBlazingHero2 = true
          table.insert(remGunsBlazing,iii)
          spawnGunsBlazing = false
        end
      end
      
      --Check for collision with Slow down  
      for iii,vvv in ipairs(slowDown) do
        if CheckCollision(v.x,v.y,5,2,vvv.x,vvv.y,vvv.width,vvv.height) then
          sdSlowDown:play()
          slowDownHero2 = true
          table.insert(remSlowDown,iii)
          spawnSlowDown = false
        end
      end
      
    end
  
  -- Count 3 seconds to respawn Med Kit
    if spawnMedKit == false then
      currTimeMedKit = currTimeMedKit - dt;
    if currTimeMedKit < 0 then
      spawnMedKit = true
      table.insert(medKit,medKit)
      currTimeMedKit = respawnTimeMedKit;
      end
    end
    -- Guns blazing is activated for blue
    if gunsBlazingHero then
      hero.fire_wait = 0
      durationGunsBlazing = durationGunsBlazing - dt
      if durationGunsBlazing < 0 then 
        hero.fire_wait = 0.3
        durationGunsBlazing = 5
        gunsBlazingHero = false 
        end
    end
    -- Guns blazing is activated for red
    if gunsBlazingHero2 then
      hero2.fire_wait = 0
      durationGunsBlazing = durationGunsBlazing - dt
      if durationGunsBlazing < 0 then 
        hero2.fire_wait = 0.3
        durationGunsBlazing = 5
        gunsBlazingHero2 = false 
      end
    end
    
    -- Slow down is activated for blue
    if slowDownHero then
      hero2.speed = 80
      durationSlowDown = durationSlowDown - dt
      if durationSlowDown < 0 then 
        hero2.speed = 200
        durationSlowDown = 5
        slowDownHero = false 
        end
    end
    
     -- Slow down is activated for red
    if slowDownHero2 then
      hero.speed = 80
      durationSlowDown = durationSlowDown - dt
      if durationSlowDown < 0 then 
        hero.speed = 200
        durationSlowDown = 5
        slowDownHero2 = false 
        end
    end
  -- Count 5 seconds to respawn Guns Blazing
    if spawnGunsBlazing == false then
      currTimeGunsBlazing = currTimeGunsBlazing - dt;
    if currTimeGunsBlazing < 0 then
      spawnGunsBlazing = true
      table.insert(gunsBlazing,gunsBlazing)
      currTimeGunsBlazing = respawnTimeGunsBlazing;
      end
    end
    
    -- Count 5 seconds to respawn Slow down
    if spawnSlowDown == false then
      currTimeSlowDown = currTimeSlowDown - dt;
    if currTimeSlowDown < 0 then
      spawnSlowDown = true
      table.insert(slowDown,slowDown)
      currTimeSlowDown = respawnTimeSlowDown;
      end
    end
    
	-- remove the marked brick
	for i,v in ipairs(remBrick) do
		table.remove(brickWall, v)
	end
  -- remove the marked stone
  for i,v in ipairs(remStone) do
		table.remove(stoneWall, v)
	end
  -- remove the marked shots
	for i,v in ipairs(remHeroShot) do
		table.remove(hero.shots, v)
	end
  for i,v in ipairs(remHero2Shot) do
		table.remove(hero2.shots, v)
	end
  for i,v in ipairs(remMedKit) do
		table.remove(medKit, v)
	end
  for i,v in ipairs(remGunsBlazing) do
		table.remove(gunsBlazing, v)
	end
  for i,v in ipairs(remSlowDown) do
		table.remove(slowDown, v)
	end
  
--Stop heroes from crossing the border
 if hero.y > 465 - hero.height  then
    hero.y = 465 - hero.height 
  elseif hero.y < 0 then
    hero.y = 0
  end
  if hero2.y > 465 - hero2.height  then
    hero2.y = 465 - hero2.height 
  elseif hero2.y < 0 then
    hero2.y = 0
  end
  
  if(hero.curHealth < 1) then -- Red wins
    playOnce_sdVictory = true
    gameState = 2 
  elseif (hero2.curHealth < 1) then  -- Blue wins
    playOnce_sdVictory = true
    gameState = 3
    end
  
 end
end
function love.draw()
	-- let's draw a background
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(bg)
	
	-- let's draw our hero (Blue)
	love.graphics.setColor(0,0,255,255)
	love.graphics.rectangle("fill", hero.x, hero.y, hero.width, hero.height)

  -- Draw hero 2 (Red)
  love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("fill", hero2.x, hero2.y, hero2.width, hero2.height)
  love.graphics.setColor(255,255,255,255) -- white
	
	-- let's draw our brickWall
	love.graphics.setColor(153,0,0,255)
	for i,v in ipairs(brickWall) do
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
	end
  
  -- let's draw our stoneWall
	love.graphics.setColor(165,165,165,255) 
	for i,v in ipairs(stoneWall) do
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
	end
  -- let's draw our Guns blazing power-up 
  if gunsBlazing then
    love.graphics.setColor(32,99,29,255) -- dark green
    for i,v in ipairs(gunsBlazing) do
      love.graphics.rectangle("fill",gunsBlazing.x,gunsBlazing.y,gunsBlazing.width,gunsBlazing.height)
      love.graphics.setColor(255,255,255,255) -- white
      love.graphics.rectangle("fill",gunsBlazing.x + 7,gunsBlazing.y,gunsBlazing.width/4,gunsBlazing.height/2)  -- (2)
    end
  end
  
  -- let's draw our Slow down power-up 
  if slowDown then
    love.graphics.setColor(223,66,244,255) -- pink
    for i,v in ipairs(slowDown) do
      love.graphics.rectangle("fill",slowDown.x,slowDown.y,slowDown.width,slowDown.height)
      love.graphics.setColor(255,255,255,255) -- white
      love.graphics.rectangle("fill",slowDown.x + 7,slowDown.y + 6,slowDown.width/4,slowDown.height-14) 
    end
  end
  
  -- let's draw our medical Kit
  if spawnMedKit then
    love.graphics.setColor(200,0,0,255) -- dark Red
    for i,v in ipairs(medKit) do
      love.graphics.rectangle("fill",medKit.x,medKit.y,medKit.width,medKit.height)
      love.graphics.setColor(255,255,255,255) -- white
      love.graphics.rectangle("fill",medKit.x,medKit.y +7,medKit.width,medKit.height/5) -- Line (1) make a cross
      love.graphics.rectangle("fill",medKit.x + 7.8,medKit.y,medKit.width/5,medKit.height)  -- (2)
    end
  end
  
  -- let's draw our heroes' shots
	love.graphics.setColor(255,255,255,255) -- white
  for i,v in ipairs(hero2.shots) do
		love.graphics.rectangle("fill", v.x, v.y, 5, 2)
	end
	for i,v in ipairs(hero.shots) do
		love.graphics.rectangle("fill", v.x, v.y, 5, 2)
	end
  --Draw timer
   love.graphics.print('Timer: '..math.floor(tostring(remaining_time) + 0.5),360,10)
   if remaining_time <= 0 then
    remaining_time = 0
    gameState = 4
  end
  
  --Draw health bar
  if (hero.curHealth < 25) then
    love.graphics.setColor(255, 0, 0,255)
  elseif (hero.curHealth < 50) then
    love.graphics.setColor(255, 200, 0,255);
  else 
    love.graphics.setColor(0, 255, 0,255);
  end
  love.graphics.rectangle("fill",10,10,heroHealthBarLength,20)
  love.graphics.rectangle("line",10,10,rectWidthHero,20)
   if (hero2.curHealth < 25) then
    love.graphics.setColor(255, 0, 0,255)
  elseif (hero2.curHealth < 50) then
    love.graphics.setColor(255, 200, 0,255);
  else 
    love.graphics.setColor(0, 255, 0,255);
  end
  love.graphics.rectangle("fill",670,10,hero2HealthBarLength,20)
  love.graphics.rectangle("line",670,10,rectWidthHero2,20)
  love.graphics.setColor(0, 0, 0,255);
  love.graphics.print('HP: '..math.floor(tostring(hero.curHealth) + 0.5),10,18)
  love.graphics.print('HP: '..math.floor(tostring(hero2.curHealth) + 0.5),670,18)
  
  -- Draw game States
  if gameState == 0 then -- Menu
    love.graphics.setColor(0,0,0,100)
    love.graphics.rectangle("fill",0,0,800,465)
    love.graphics.setColor(255,255,255,255) -- white
    love.graphics.print("Press any key to start Shooties each other",250,370)
    love.graphics.print("Blue block\n----------------\nMovement:\n\tUp:\tW\n\tDown: S\n\tShoot: Space",35,100)
    love.graphics.print("Red block\n----------------\nMovement:\n\tUp: Up arrow\n\tDown: Down arrow\n\tShoot: Left arrow",665,100)
    love.graphics.print("Med-Kit: Adds 25 HP to the player -->", 165,100)
    love.graphics.print("Guns Blazin: Higher rate of fire -->\n\t\t\t\t\tfor 7 seconds", 182,200)
    love.graphics.print("Slow Down!: Slows the other player -->\n\t\t\t\t\tdown for 5 seconds", 160,300)
    end
  if gameState == 2 then -- red wins
    love.graphics.setColor(0,0,0,100)
    love.graphics.rectangle("fill",0,0,800,465)
    love.graphics.setColor(255,255,255,255) -- white
    love.graphics.print("Red is Victorious!",300,200)
    love.graphics.print("Press R to Restart",300,250)
    love.graphics.setColor(255,0,0,255) -- red
    love.graphics.rectangle("fill", 450, 200, 35,15)
    
    if playOnce_sdVictory then
     sdVictory:play()
     playOnce_sdVictory = false
    end
    if restartGame == true then
      love.load()
      restartGame = false
    end
  end
  if gameState == 3 then -- blue wins
    love.graphics.setColor(0,0,0,100)
    love.graphics.rectangle("fill",0,0,800,465)
    love.graphics.setColor(255,255,255,255) -- white
    love.graphics.print("Blue is Victorious!",300,200)
    love.graphics.print("Press R to Restart",300,250)
    love.graphics.setColor(0,0,255,255) -- blue
    love.graphics.rectangle("fill", 450, 200, 35,15)
    if playOnce_sdVictory then
     sdVictory:play()
     playOnce_sdVictory = false
    end
    
    if restartGame == true then
      love.load()
      restartGame = false
    end
  end
  if gameState == 4 then -- Draw
    love.graphics.setColor(0,0,0,100)
    love.graphics.rectangle("fill",0,0,800,465)
    love.graphics.setColor(255,255,255,255) -- white
    love.graphics.print("IT IS AAAAAALL OVER!!\nIt's a Draw!!!",300,200)
    end
end



function heroShoots()
	local shot = {}
	shot.x = hero.x+hero.width
	shot.y = hero.y+hero.height/2
	
	table.insert(hero.shots, shot)
end

function hero2Shoots()
  
  local shot = {}
  shot.x = hero2.x
  shot.y = hero2.y+hero2.height/2
  
  table.insert(hero2.shots,shot)
end

function AddjustCurrentHeroHealth(adj)
  
  hero.curHealth = hero.curHealth + adj
  
  if(hero.curHealth < 0) then
    hero.curHealth = 0
  end
  
  if(hero.curHealth > hero.maxHealth) then
    hero.curHealth = hero.maxHealth
  end
  
  if(hero.maxHealth < 1) then
      hero.maxHealth = 1
  end
  
  heroHealthBarLength = rectWidthHero * (hero.curHealth/ hero.maxHealth)
end

function AddjustCurrentHero2Health(adj)
  
  hero2.curHealth = hero2.curHealth + adj
  
  if(hero2.curHealth < 0) then
    hero2.curHealth = 0
  end
  
  if(hero2.curHealth > hero2.maxHealth) then
    hero2.curHealth = hero2.maxHealth
  end
  
  if(hero2.maxHealth < 1) then
      hero2.maxHealth = 1
  end
  
  hero2HealthBarLength = rectWidthHero2 * (hero2.curHealth/ hero2.maxHealth)
end


-- Collision detection function.
-- Checks if a and b overlap.
-- w and h mean width and height.
function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end