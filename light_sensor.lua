--Interfacing of grove light sensor with NODEMCU 
--Whenever light is detected on chip LED turns on

local lightpin=1    --Pin for light sensor
local ledpin=0      --Pin for LED
local duration=1000 --Duration of timer 1000ms
status=gpio.LOW

--Init functions
gpio.mode(ledpin,gpio.OUTPUT)
gpio.write(ledpin,status)
gpio.mode(lightpin,gpio.INPUT)


--Process call
tmr.alarm(0,duration,tmr.ALARM_AUTO,function()
    motionstatus=gpio.read(lightpin)
    if motionstatus==0 then
        status=gpio.HIGH    --LED connected to DO pin has a negative logic
        print "Light OFF"
    else
        status=gpio.LOW
        print "Light ON"
    end

    gpio.write(ledpin,status)
    end
    )
