balas = 0
Player = {} 
jogo = 'menu'
function Player:new()
    o = {
        x = love.graphics.getWidth()/2, 
        y = love.graphics.getHeight()/2,
        w = 38, 
        speed = 350
    }
    setmetatable(o, { __index = Player })
    return o
end

function Player:update( dt )
	if love.keyboard.isDown('d') then
        o.x = o.x + o.speed * dt
    end
    if love.keyboard.isDown('a') then
        o.x = o.x - o.speed * dt
    end
    if love.keyboard.isDown('w') then
        o.y = o.y - o.speed * dt
    end
    if love.keyboard.isDown('s') then
        o.y = o.y + o.speed * dt
    end


    if o.x > love.graphics.getWidth() - o.w then
        o.x = love.graphics.getWidth() - o.w
    end
    if o.y > love.graphics.getHeight() - o.w then
        o.y = love.graphics.getHeight() - o.w
    end

    if o.x < o.w then
        o.x = o.w
    end
    if o.y < o.w then 
        o.y = o.w
    end
    if balas > 180 then
        o.speed = o.speed + 0.025
    end
    return o.x,o.y
end

function Player:draw()
	love.graphics.setLineWidth(4.2)
	love.graphics.setBackgroundColor(cor,cor,cor)
	love.graphics.setColor(0, 0, 0)
	--love.graphics.circle('line',o.x , o.y, 25, 4)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle('line',o.x , o.y, o.w, 40)
    love.graphics.setColor(0, 0, 0)
end

Arma = {}   
bullets = {}
enimigos = {}
pos = 3.1415926
core = 255

function Arma:new()
    o2 = {
        x = 100,
        y = 10,
        speed = 2,
        heat = 0,
        heatp = 0.09,
        heatp2 = 0.9
    }
    setmetatable(o2, { __index = Arma })
    return o2
end

function Arma:update(dt) 
    o2.y = o.y + math.cos(pos) * o.w
    o2.x = o.x + math.sin(pos) * o.w
    b_x = math.cos(pos) * o.w
    b_y = math.sin(pos) * o.w

    if love.keyboard.isDown('left') then
        pos = pos + 0.03 * o2.speed
    end
    if love.keyboard.isDown('right') then
        pos = pos - 0.03 * o2.speed
    end
    if love.keyboard.isDown('m') then 
        if core == 255 then
            core = 0 
        else
        	core = 255
        end
    end


    if love.keyboard.isDown( "space" ) and o2.heat <= 0 then
        local direction = math.atan2(b_x, b_y)
        table.insert(bullets, {
            x = o2.x,
            y = o2.y,
            dir = direction,
            speed = 800
        })

        o2.heat = o2.heatp
        if balas > 200 or balas == 200 then
            balas = balas + 0.35
        end
        if balas > 280 or balas == 280 then
            balas = balas + 0.25
        end
        if balas < 200 then
            balas = balas + 0.9
        end
    end
        
    o2.heat = math.max(0, o2.heat - dt)

    for i, l in ipairs(bullets) do
        l.x = l.x + math.cos(l.dir) * l.speed * dt
        l.y = l.y + math.sin(l.dir) * l.speed * dt

        if hx > l.x - 20 and hx < l.x + 20 and hy > l.y - 20 and hy < l.y + 20 then
            score = score + 1

            sound = love.audio.newSource("som.WAV")
            love.audio.play(sound)

            --dist = math.sqrt(math.pow((o.y-hy),2)+ math.pow((o.x-hx),2))

            hx = love.math.random(850)
            hy = love.math.random(650)

        end  
    end

    for i = #bullets, 1, -1 do

        local l = bullets[i]
        if (l.x < -10) or (l.x > love.graphics.getWidth() + 10) or (l.y < -10) or (l.y > love.graphics.getHeight() + 10) then
            table.remove(bullets, i)
        end

    end

    return hx,hy
end

function Arma:draw()
    love.graphics.setColor(core, core, core)
    love.graphics.circle("fill", o2.x, o2.y, 12,30)
    love.graphics.setColor(0, 0, 0)
    
    for i, l in ipairs(bullets) do
        love.graphics.circle('fill', l.x, l.y, 7, 30)
        love.graphics.setColor(0, 0, 0)
    end

end


score = 0
hs = 0 
hx = love.math.random(850)
hy = love.math.random(650)
vida = 5
tocar = 0

function love.load()
    cor = 255
	love.window.setMode(850, 650)--,{resizable=true, vsync=false, minwidth=750, minheight=600})
    love.graphics.setFont(love.graphics.newFont(28))
	A = Arma:new()
	p = Player:new()
end

function love.update(dt)
	p:update(dt)
	A:update(dt)

    if hx > o.x - o.w and hx < o.x + o.w and hy > o.y - o.w and hy < o.y + o.w then
        vida = vida - 1
        hx = love.math.random(850)
        hy = love.math.random(650)
        return hx,hy
    end


    if(hx > o.x - 4 and hx < o.x + 4) == false then 
        if hx < o.x then
            hx = hx + balas * dt
        end
        if hx > o.x then
            hx = hx - balas * dt
        end
    end

    if(hy > o.y - 4 and hy < o.y + 4) == false then 
        if hy < o.y then
            hy = hy + balas * dt
        end

        if hy > o.y then
            hy = hy - balas * dt
        end
    end
    if vida == 0 then
        o.x = love.graphics.getWidth()/2
        oy = love.graphics.getHeight()/2
        vida = 5
        balas = 0
        dt = 0

        if score > hs then
            hs = score 
        end
        score = 0
        return o.x,o.y,vida,score
    end
end
function love.draw()
	p:draw()
	A:draw()
	love.graphics.print("Score: ", 10, 10, 0, 1, 1)
    love.graphics.print("High Score: ", 150, 10, 0, 1, 1)
    love.graphics.print(hs, 315, 10, 0, 1, 1)
    love.graphics.print("lives: ", 10, 43, 0, 1, 1)
    love.graphics.print(vida, 95, 43, 0, 1, 1)
	love.graphics.print(score, 100, 10, 0, 1, 1)
	love.graphics.circle("line", hx, hy, 20, 80)
    love.graphics.setColor(0, 0, 0)
end

