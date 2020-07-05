function love.load()
  --[[
  Decides what happens immediately when the game loads
  Good to define:
  Global vars here
  Window size
  And any preliminary actions before the game starts
  ]]

  love.window.maximize()

  -- user-defined properties on button table
  button = {}
  button.x = love.graphics.getWidth() / 2
  button.y = love.graphics.getHeight() / 2
  button.radius = 50

  quit = {}
  quit.x = (love.graphics.getWidth() / 2) - 75
  quit.y = (love.graphics.getHeight() / 2) + 185
  quit.width = 150
  quit.height = 80

  gameStates = {}
  gameStates["Main Menu"] = 1
  gameStates["In Session"] = 2
  gameStates["End Round" ] = 3

  gameState = gameStates["Main Menu"]
  score = 0
  timer = 10

  myFont = love.graphics.newFont(40)
end

function love.update(dt)
  --[[
  Game loop refreshes on every frame
  60 fps by default for Lua games

  dt = time passed since last frame
  ]]

  if gameState == 2 then
    if timer > 0 then
      timer = timer - dt
    elseif timer == 0 then
      gameState = gameStates["End Round"]
    else
      timer = 0
      gameState = gameStates["End Round"]
      resetStartButton()
    end
  end
end

function love.draw()
  --[[
  Also refreshes on every frame
  draw is specifically for stuff invovlving graphics or images
  not for calculations or variables
  ]]

  love.graphics.setBackgroundColor(0.44, 0.8, 0.8)

  if (gameState == 2) then
    love.graphics.setColor(0.8, 0.44, 0.44)
    love.graphics.circle("fill", button.x, button.y, button.radius)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("line", button.x, button.y, button.radius)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(myFont)
    love.graphics.print("Score: " .. score)
    love.graphics.print("Time: " .. math.ceil(timer), (love.graphics.getWidth() / 2) - 135, 0)
  else
    love.graphics.setColor(0.8, 0.44, 0.44)
    love.graphics.circle("fill", button.x, button.y, button.radius)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("line", button.x, button.y, button.radius)
    love.graphics.setColor(0.8, 0.44, 0.44)
    love.graphics.rectangle("fill", quit.x, quit.y, quit.width, quit.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", quit.x, quit.y, quit.width, quit.height)
    displayMenu()
  end
end

function displayMenu()
  love.graphics.setColor(1, 1, 1)
  love.graphics.setFont(myFont)
  love.graphics.print("Score: " .. score)
  love.graphics.print("Time: " .. math.ceil(timer), (love.graphics.getWidth() / 2) - 135, 0)

  if gameState == 3 then
    love.graphics.printf("Round Ended", 0, button.y - 150, love.graphics.getWidth(), "center")
  end

  love.graphics.printf("Click the red circle to Start", 0, button.y - 100, love.graphics.getWidth(), "center")
  love.graphics.printf("Quit", 0, button.y + 200, love.graphics.getWidth(), "center")
end

function love.mousepressed(x, y, buttonClick, isTouch)
  if (buttonClick == 1) and (gameState == 1 or gameState == 3) then
    local onQuit = assertClickQuit(love.mouse.getX(), love.mouse.getY())
    if onQuit then
      love.event.quit(0)
    end

    local distance = distanceBetween(button.x, button.y, love.mouse.getX(), love.mouse.getY())
    if distance <= button.radius then
      setNewButtonPosition()
      gameState = gameStates["In Session"]
      score = 0
      timer = 10
    end

  elseif buttonClick == 1 and gameState == 2 then
    local distance = distanceBetween(button.x, button.y, x, y)
    if distance <= button.radius then
      score = score + 1
      setNewButtonPosition()
    end
  end
end

function resetStartButton()
  button.x = love.graphics.getWidth() / 2
  button.y = love.graphics.getHeight() / 2
end

function assertClickQuit(x, y)
  local quitX2 = quit.x + quit.width
  local quitY2 = quit.y + quit.height

  if (quit.x <= x and x <= quitX2) and (quit.y <= y and y <= quitY2) then
    return true
  else
    return false
  end
end

function setNewButtonPosition()
  --[[
  Keeps button from landing off screen
  and + 50 on newY prevents button landing on Score or Time
  ]]
  local newX = math.random(button.radius, love.graphics.getWidth() - button.radius)
  local newY = math.random(button.radius + 50, love.graphics.getHeight() - button.radius)
  local distance = distanceBetween(button.x, button.y, newX, newY)

  --[[
  This will cause the game to not work if window is too small
  but it avoids the button landing on the same spot or too close
  ]]
  if distance > button.radius then
    button.x = newX
    button.y = newY
  else
    setNewButtonPosition()
  end
end

function distanceBetween(x1, y1, x2, y2)
  -- Pythagoras' Theorem
  return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end
