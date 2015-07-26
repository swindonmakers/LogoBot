#include <DNSServer.h>
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <WiFiClient.h>

/* Settings you may want to configure for your LogoBot */
#define LOGOBOT_SSID "LogobotBlue"
#define LOGOBOT_PWD "logobot1"
#define LOGOBOT_URL "logo.bot"
static const IPAddress apIP(192, 168, 4, 1);
static const IPAddress mask(255, 255, 255, 0);

/* Settings you should leave alone */
#define DNS_PORT 53
#define led 2

DNSServer dnsServer;
ESP8266WebServer server(80);

static const char page[] PROGMEM = R"~(
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
    padding-top: 15px;
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
Dist: <input type="number" id="dist" value="20" /> <br />
Ang: <input type="number" id="angle" value="90" /><br />
<button onclick="l('LT', elv('angle'));">Left</button>
<button onclick="l('RT', elv('angle'));">Right</button><br />
<hr />

<button onclick="l('PU');">Pen Up</button>
<button onclick="l('PD');">Pen Down</button>
<hr />

<button class="button30" onclick="l('!ST');">Stop</button>
<button class="button30" onclick="l('BZ', 500);">Horn</button>
<button class="button30" onclick="l('!SE');">E-Stop!</button>
<hr/>

X:<input style="width: 40px" type="number" id="x" value="0"/>
Y:<input style="width: 40px" type="number" id="y" value="0"/>
<br />
<button onclick="l('TO', elv('x'), elv('y'));">Move To</button>
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
            el('state').innerText = this.responseText;
          }
  } catch(ex) {
    el('state').innerText = 'send error';
  }
    };
</script>
</body>
</html>

)~";

static void handleRoot() {
  digitalWrite(led, 1);
  server.send(200, F("text/html"), page);
  digitalWrite(led, 0);
}

static void handleCommand()
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

    // Wait a max of 200ms for a repsonse
    Serial.setTimeout(200);
    String response = Serial.readStringUntil('\n');

    server.send(200, F("text/plain"), response);

  } else {
    server.send(200, F("text/plain"), F("err"));
  }
  
  digitalWrite(led, 0);
}

static void handleNotFound(){
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

  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, mask);
  WiFi.softAP(LOGOBOT_SSID, LOGOBOT_PWD);
  
  dnsServer.setTTL(300);
  // set which return code will be used for all other domains (e.g. sending
  // ServerFailure instead of NonExistentDomain will reduce number of queries
  // sent by clients)
  // default is DNSReplyCode::NonExistentDomain
  dnsServer.setErrorReplyCode(DNSReplyCode::ServerFailure);
  dnsServer.start(DNS_PORT, LOGOBOT_URL, apIP);
  
  server.on("/", handleRoot);
  server.on("/cmd", handleCommand);
  server.onNotFound(handleNotFound);
  
  server.begin();
}
 
void loop(void){
  dnsServer.processNextRequest();
  server.handleClient();
}
