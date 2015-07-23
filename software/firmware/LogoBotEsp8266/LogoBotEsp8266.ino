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
<head>
<title>Logobot Blue</title>
<style>
body, button,input {font-family:sans-serif; font-size: 22px;}
body {
    padding: 5% 5%;
}
a, button {
    display:inline-block;
    width:45%;
    background-color:#337ab7;
    text-align:center;
    border:1px solid #2e6da4;
    border-radius:4px;
    text-decoration:none;
    color:#fff;
    vertical-align:middle;
    padding: 12px 0;
}
a+a, button+button {
    margin-left:5%;
}
a:hover, button:hover {
    background-color:#23527c;
}
input {
    display:inline-block;
    width: 30%;
    margin-bottom:12px;
}
.header-fixed {
    width:100%;
    position:fixed;
    top:0px;
    left:0px;
    background-color:#337ab7;
    color:#fff;
    padding: 5px;
}
.content {
    padding-top: 10px;
    text-align: center;
}
.button30 {
    width: 28%;
}
</style>
</head>
<body>
<div class="header-fixed">Logobot: <span id="state">ready!</span></div>

<div class="content">

<button onclick="l('BK', elv('dist'));">Backward</button>
<button onclick="l('FD', elv('dist'));">Forward</button><br />
Dist: <input type="number" id="dist" value="20" /> Ang: <input type="number" id="angle" value="90" /><br />
<button onclick="l('LT', elv('angle'));">Left</button>
<button onclick="l('RT', elv('angle'));">Right</button><br />
<hr />

<button onclick="l('PU');">Pen Up</button>
<button onclick="l('PD');">Pen Down</button>
<hr />

<button class="button30" onclick="l('ST');">Stop</button>
<button class="button30" onclick="l('BZ', 500);">Horn</button>
<button class="button30" onclick="l('SE');">E-Stop!</button>
<hr/>

<button onclick="l('TO', elv('x'), elv('y'));">Move To</button>
X:<input style="width: 40px" type="number" id="x" value="0"/>
Y:<input style="width: 40px" type="number" id="y" value="0"/>
<hr />


<button onclick="l('WT', elv('txt'));">Write text</button>
&nbsp;
<input type="text" id="txt" />
</div>

<script type="text/javascript">
    function el(id) { return document.getElementById(id); }
    function elv(id) { return el(id).value; }
    function l(cmd, p1, p2) {
        var xhReq = new XMLHttpRequest();
        var uri = '/cmd?action=' + cmd;
        if (p1) { uri += '&p1=' + p1; }
        if (p2) { uri += '&p2=' + p2; }
        xhReq.open('GET', uri, true);
  try {
          xhReq.send();
          xhReq.onload = function () {
            el('state').innerText = cmd + ': ' + this.responseText;
          }
  } catch(ex) {
    el('state').innerText = 'send error';
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
  
  if (server.hasArg("action")) {
    // Parse args, todo, url decode
    String cmd = server.arg("action");
    if (server.hasArg("p1")) cmd += " " + server.arg("p1");
    if (server.hasArg("p2")) cmd += " " + server.arg("p2");

    // Clear input button in anticipation of a response.
    while(Serial.available())
      Serial.read();

    // Send command
    Serial.println(cmd);

    // Wait a max of 500ms for a repsonse
    Serial.setTimeout(500);
    String response = Serial.readStringUntil('\n');

    server.send(200, F("text/plain"), response);

  } else {
    server.send(200, F("text/plain"), "err");
  }
  
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
