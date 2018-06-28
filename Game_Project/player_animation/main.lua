local widget = require( "widget" )
display.setDefault("magTextureFilter", "nearest")
display.setDefault("minTextureFilter", "nearest")
function convertHexToRGB(hexCode)
   assert(#hexCode == 7, "The hex value must be passed in the form of #XXXXXX");
   local hexCode = hexCode:gsub("#","")
   return tonumber("0x"..hexCode:sub(1,2))/255,tonumber("0x"..hexCode:sub(3,4))/255,tonumber("0x"..hexCode:sub(5,6))/255;
end


display.setDefault( "background",convertHexToRGB('#e4eef0') )
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local sheetOptions =
{
    width = 64,
    height = 64,
    numFrames = 23
}
local sheet_runningCat = graphics.newImageSheet( "newanimation.png", sheetOptions )
-- sequences table
local sequences_runningCat = {
    -- consecutive frames sequence
    {name = "atk_combo_1",start = 1,count = 5,time = 400,loopCount = 1,loopDirection = "forward"},
    {name = "atk_combo_2",start = 6,count = 5,time = 400,loopCount = 1,loopDirection = "forward"},
    {name = "atk_combo_3",start = 11,count = 5,time = 400,loopCount = 1,loopDirection = "forward"},
    {name = "idle",start = 16,count = 4,time = 400,loopCount = 0,loopDirection = "forward"},
    {name = "walk",start = 20,count = 4,time = 400,loopCount = 0,loopDirection = "forward"},
}

local runningCat = display.newSprite( sheet_runningCat, sequences_runningCat )
runningCat.x = centerX
runningCat.y = centerY



runningCat.xScale = 3
runningCat.yScale = 3

local widget = require( "widget" )
local attc = 1
-- Function to handle button events
local function handleButtonEvent( event )
 	local phase = event.phase
 	local id = event.target.id
 	if ( "began" == phase) then
 		if ( "button1" == id) then
 			runningCat:setSequence( "idle" )  -- switch to "fastRun" sequence
			runningCat:play()
 		elseif ( "button2" == id) then
 			runningCat:setSequence( "walk" )  -- switch to "fastRun" sequence
			runningCat:play()
 		elseif ( "button3" == id) then
 			runningCat:setSequence( "atk_combo_"..attc )  -- switch to "fastRun" sequence
			runningCat:play()
			attc = attc + 1
			if ( attc == 4) then
				attc = 1
			end
 		end
    elseif ( "ended" == phase ) then
        print( "Button was pressed and released" )
    end
end
 
-- Create the widget
local button1 = widget.newButton(
    {
        left = 0,
        top = 200,
        id = "button1",
        label = "idle",
        onEvent = handleButtonEvent
    }
)
-- Create the widget
local button2 = widget.newButton(
    {
        left = 100,
        top = 200,
        id = "button2",
        label = "walk",
        onEvent = handleButtonEvent
    }
)
-- Create the widget
local button3 = widget.newButton(
    {
        left = 200,
        top = 200,
        id = "button3",
        label = "attack",
        onEvent = handleButtonEvent
    }
)