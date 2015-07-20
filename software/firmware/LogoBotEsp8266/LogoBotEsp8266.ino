#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <EEPROM.h>
 
ESP8266WebServer server(80);
const int led = 2;

const char page[] PROGMEM = R"~(
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1">
<html>
<head><title>Logobot Blue</title></head>
<body style="font-size: 24px;">
Distance: <input type="text" id="dist" value="1000" /><br />
<a href="#" onclick="l('BK', elv('dist'));">Backward</a> :
<a href="#" onclick="l('FD', elv('dist'));">Forward</a><br/>
<hr/>
Angle: <input type="text" id="angle" value="90" /><br />
<a href="#" onclick="l('LT', elv('angle'));">Left</a> :
<a href="#" onclick="l('RT', elv('angle'));">Right</a><br/>
<hr />

<button onclick="l('PU', null);">Pen Up</button>
<button onclick="l('PD', null);">Pen Down</button>
<hr />

<button onclick="l('ST', null);">Stop</button>
<button onclick="l('BZ', 500);">Horn</button>

<hr/>

<div><span id="lastCmd"></span>:<span id="lastResp"</span></div>

<script type="text/javascript">
    function el(id) { return document.getElementById(id); }
    function elv(id) { return el(id).value; }
    function l(cmd, dist) {
        var xhReq = new XMLHttpRequest();
        var uri = '/cmd?action=' + cmd;
        if (dist) { uri += '&dist=' + dist; }
        xhReq.open('GET', uri, true);
        xhReq.send();
        xhReq.onload = function () {
          el('lastCmd').innerText = cmd + ' ' + dist;
          el('lastResp').innerText = this.responseText;
        }
    };
</script>
</body>
</html>
)~";

void handleRoot() {
  digitalWrite(led, 1);
  server.send(200, F("text/html"), page);
  digitalWrite(led, 0);
}

void handleCommand()
{
  digitalWrite(led, 1);
  
  if (server.hasArg("action") && server.hasArg("dist"))
    Serial.println(server.arg("action") + " " + server.arg("dist"));
  else if (server.hasArg("action"))
    Serial.println(server.arg("action")); 
  
  server.send(200, F("text/plain"), "ok");
  
  digitalWrite(led, 0);
}

void handleNotFound(){
  digitalWrite(led, 1);
  String message = "File Not Found\n\n";
  message += "URI: ";
  message += server.uri();
  message += "\nMethod: ";
  message += (server.method() == HTTP_GET)?"GET":"POST";
  message += "\nArguments: ";
  message += server.args();
  message += "\n";
  for (uint8_t i=0; i<server.args(); i++){
    message += " " + server.argName(i) + ": " + server.arg(i) + "\n";
  }
  server.send(404, F("text/plain"), message);
  digitalWrite(led, 0);
}
 
void setup(void){
  Serial.begin(9600);
  Serial.println();
  Serial.println(F("Logobot Wifi Interface"));
  
  pinMode(led, OUTPUT);
  digitalWrite(led, 0);

  WiFi.softAP("LogobotBlue", "logobot1");
  WiFi.mode(WIFI_AP);
  
  server.on("/", handleRoot);
  server.on("/cmd", handleCommand);
  server.onNotFound(handleNotFound);
  
  server.begin();
}
 
void loop(void){
  server.handleClient();
}
