AP_CFG={}
AP_CFG.ssid="BonnAgile"
AP_CFG.pwd=nil
AP_CFG.auth=AUTH_OPEN
AP_CFG.channel = 6
AP_CFG.hidden = 0
AP_CFG.max=4
AP_CFG.beacon=100

AP_IP_CFG={}
AP_IP_CFG.ip="192.168.10.1"
AP_IP_CFG.netmask="255.255.255.0"
AP_IP_CFG.gateway="192.168.10.1"

AP_DHCP_CFG={}
AP_DHCP_CFG.start="192.168.10.2"

wifi.setmode(wifi.SOFTAP)
wifi.setphymode(wifi.PHYMODE_N)

wifi.ap.config(AP_CFG)
wifi.ap.setip(AP_IP_CFG)

wifi.ap.dhcp.config(AP_DHCP_CFG)
wifi.ap.dhcp.start()

led0=0
gpio.mode(led0, gpio.OUTPUT)
gpio.write(led0, gpio.HIGH);

if srv ~= nil then
  net.server:close()
end

print ("Starting web server on IP: "..wifi.ap.getip())
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
  conn:on("receive", function(client, request)
    print (request)

    local _, _, method, path = string.find(request, "([A-Z]+) /(.+) HTTP");

    if (path == "ON") then
      gpio.write(led0, gpio.LOW);
    elseif (path == "OFF") then
      gpio.write(led0, gpio.HIGH);
    end

    local buf = "<h1>ESP8266 Web Server</h1>"..
       "<p>LED0 <a href=\"/ON\"><button>ON</button></a>&nbsp;"..
       "<a href=\"/OFF\"><button>OFF</button></a></p>";
    client:send(buf);
    client:close();
    collectgarbage();
    end)
end)
