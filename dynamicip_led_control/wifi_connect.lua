require "credentials"   --Import credetianls
require "html_led"      --Import the html page to be served
wifi.setmode(wifi.STATION)
wifi.sta.config(station_cfg)
local ledpin=0      --Pin for LED
status=gpio.HIGH

gpio.mode(ledpin,gpio.OUTPUT)
gpio.write(ledpin,status)

print("Fetching IP:") 
tmr.alarm(0,1000,tmr.ALARM_AUTO,function()
    ip=wifi.sta.getip()
    if ip ~=nil then
        print("IP is..."..ip)
        tmr.stop(0)
    end
end)


if srv==nil then
    srv=net.createServer(net.TCP, 10)
end


srv:listen(80,function(conn) 
    conn:on("receive",function(conn,payload)
    --Logic for extracting request sent to server 
        local start_code,end_code=string.find(payload,"GET(.+)HTTP")
        local sub_string=string.sub(payload,start_code,end_code)
        local start_code,startofval=string.find(sub_string,"pin=")
        local endofval,end_code=string.find(sub_string,"HTTP")
        if startofval ~=nil and endofval ~=nil then
            match=string.sub(payload,startofval+1,endofval-2)
        end

        if match == "ON" then
           status=gpio.LOW      --Negative Logic for Onboard Led
        end
        if match =="OFF" then
           status=gpio.HIGH
        end

           gpio.write(ledpin,status)
            
        conn:send(s)
    end) 
    conn:on("sent",function(conn) 
    conn:close() 
    end)
end)





