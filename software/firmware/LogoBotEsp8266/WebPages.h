static const char mainPage[] PROGMEM = R"~(
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
        if (p1) { uri += '&p1=' + encodeURIComponent(p1); }
        if (p2) { uri += '&p2=' + encodeURIComponent(p2); }
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


static const char statusPage[] PROGMEM = R"~(
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1">
<html>
  <head>
    <title>Logobot Status</title>
  </head>
<body>
<div>
  Status: <span id="s">?</span><br />
  X: <span id="x">0</span><br />
  Y: <span id="y">0</span><br />
  Ang: <span id="a">0</span><br />
  CmdQ: <span id="q">0</span><br />
</div>

<script type="text/javascript">
  function el(id) { return document.getElementById(id); }
  function elv(id) { return el(id).value; }
  function updateStatus() {
    var xhReq = new XMLHttpRequest();
    xhReq.open('GET', '/stat', true);
    try {
      xhReq.send();
      xhReq.onload = function () {
        var stat = JSON.parse(this.responseText);
        el('s').innerText = stat.response;
        el('x').innerText = stat.x;
        el('y').innerText = stat.y;
        el('a').innerText = stat.ang;
        el('q').innerText = stat.qSize;
        setTimeout(updateStatus, 1000);
      }
    } catch(ex) {
      el('s').innerText = 'err';
    }
  }

  setTimeout(updateStatus, 1000);
</script>
</body>
</html>

)~";


static const char batchPage[] PROGMEM = R"~(
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1">
<html>
  <head>
    <title>Logobot Commander</title>
  </head>
  <body>
    <div>
      <textarea rows="10" id="cmds" placeholder="enter logo commands, one per line.">
FD 50
RT 90
PD
BK 10
LT 45
PU
BZ 500
      </textarea> <br />
      <button onclick="s();">Send</button><br />
      <span id="f"></span>
    </div>

    <script type="text/javascript">
      function el(id) { return document.getElementById(id); }
      function elv(id) { return el(id).value; }

      function s() {
        var input = elv('cmds').trim();
        if (!input) return;

        var cmds = input.split(/\r?\n/);
        var next = cmds.shift();
        if (!next) return;

        el('f').innerText = 'Send: ' + next;

        var nextCmd = next.split(' ');
        var uri = '/cmd?action=' + nextCmd[0];
        if (nextCmd.length > 1)
          uri += '&p1=' + encodeURIComponent(nextCmd[1]);
        if (nextCmd.length > 2)
          uri += '&p2=' + encodeURIComponent(nextCmd[2]);

        
        var xhReq = new XMLHttpRequest();
        xhReq.open('GET', uri, true);
        console.log(uri);
        xhReq.onload = function () {
          if (this.responseText.trim() == 'BUSY') {
            el('f').innerText = 'BUSY';
            setTimeout(s, 2000);
          } else {
            el('f').innerText = this.responseText;
            el('cmds').value = cmds.join('\n');
            setTimeout(s, 250);
          }
        };

        try {
          xhReq.send();
        } catch (ex) {
          el('f').innerText = 'ERR';
          setTimeout(s, 2000);
        }
      }
    </script>
  </body>
</html>
)~";

