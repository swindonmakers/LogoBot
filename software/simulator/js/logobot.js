function Logobot() {
    this.botGroup = null;
    this.parts = {
        leftWheel:null,
        rightWheel:null,
        pen:null
    },
    this.baseDiameter =  140;
    this.baseThickness = 3;
    this.groundClearance = 20;
    this.wheelSpacing = 110;
    this.wheelRadius = 60/2;
    this.wheelCircumf = this.wheelRadius * 2 * Math.PI;
    this.wheelThickness = 4;
    this.stepsPerMM = 5000/232;
    this.stepsPerDeg =3760/180;
    this.state = {
        x:0,
        y:0,
        angle:0,
        leftWheelAngle:0,
        rightWheelAngle:0,
        penPos:15
    };
    this.todo = {
        acceleration:100,
        velocity:0,
        maxVelocity:50,
        minVelocity:5,
        left:0,
        right:0,
        pen:0,
        penVelocity:10
    };
    this.cmdQ = [];

    var lastTime = performance.now();

    this.pushCmd = function(cmd) {
        this.cmdQ.push(cmd);
    }

    this.popCmd = function() {
        if (this.cmdQ.length > 0)
            return this.cmdQ.shift()
        else
            return null;
    }

    this.insertCmd = function(cmd) {
        this.cmdQ.unshift(cmd);
    }

    this.update = function() {
        // update state!
        var t = (performance.now() - lastTime) /1000;
        if (t > 0.1) t = 0.1;
        lastTime = performance.now();


        if (this.todo.done < this.todo.total && (this.todo.left != 0 || this.todo.right != 0)) {

            // stuff to do
            var lw = Math.abs(this.todo.left);
            var ld = Math.sign(this.todo.left);
            var rw = Math.abs(this.todo.right);
            var rd = Math.sign(this.todo.right);
            var wr;

            // which wheel is dominant?   left=true, right=false
            var ww = Math.abs(this.todo.left) > Math.abs(this.todo.right);

            if (this.todo.done <= this.todo.accelUntil)
                this.todo.velocity += this.todo.acceleration * t;
            if (this.todo.done >= this.todo.decelFrom)
                this.todo.velocity -= this.todo.acceleration * t;

            this.todo.velocity = clamp(this.todo.velocity, this.todo.minVelocity, this.todo.maxVelocity);

            var maxD = t * this.todo.velocity;

            // calc linear distance change for each wheel
            if (ww) {
                wr = this.todo.right / this.todo.left;
                lw = ld * Math.min(maxD, lw);
                rw = lw * wr;
                this.todo.done += Math.abs(lw);
            } else {
                wr = this.todo.left / this.todo.right;
                rw = rd * Math.min(maxD, rw);
                lw = rw * wr;
                this.todo.done += Math.abs(rw);
            }

            // calc corresponding angle change
            var la = 360 * lw / this.wheelCircumf;
            var ra = 360 * rw / this.wheelCircumf;

            // update abs wheel angles

            this.state.leftWheelAngle += la;
            this.state.rightWheelAngle += ra;

            // decrement todo
            this.todo.left -= lw;
            this.todo.right -= rw;

            // now need to calculate effective position change in world space
            if (lw == rw) {
                // straight forward/backward move
                this.state.x -= lw * Math.sin(degToRad(this.state.angle));
                this.state.y += lw * Math.cos(degToRad(this.state.angle));

            } else {
                // arc move

                // calc vector
                var lp = new THREE.Vector2(-this.wheelSpacing/2, lw);
                var rp = new THREE.Vector2(this.wheelSpacing/2, rw);
                var v = rp.clone().sub(lp);
                var m = v.y / v.x;

                if (m != 0) {
                    // calc centre of arc
                    // from equation
                    // y - y1 = m (x - x1)
                    // rearranged to find y axis intersection
                    // x = (-y1)/m + x1
                    var x = -lp.y / m + lp.x;

                    // calc angle of rotation about arc centre
                    // use largest movement for best accuracy
                    var ang = 0;
                    var r = 0;
                    var circum = 0;
                    if (ww) {
                        r = -this.wheelSpacing/2 - x;
                        circum = 2*Math.PI*r;
                        ang = 360 * lw / circum;
                    } else {
                        // using right wheel
                        r = this.wheelSpacing/2 - x;
                        circum = 2*Math.PI*r;
                        ang = 360 * rw / circum;
                    }

                    // calc centre of rotation in world space
                    var cv = new THREE.Vector2(
                        this.state.x + x * Math.cos(degToRad(this.state.angle)),
                        this.state.y + x * Math.sin(degToRad(this.state.angle))
                    );

                    // calc vector
                    v.set(this.state.x, this.state.y);
                    v.sub(cv);
                    v.rotate(degToRad(ang));

                    // update position
                    v.add(cv);
                    this.state.x = v.x;
                    this.state.y = v.y;


                    // update angle
                    this.state.angle += ang;

                    // wrap-around
                    if (this.state.angle > 180) this.state.angle -= 360;
                    if (this.state.angle < -180) this.state.angle += 360;
                } else {
                    this.todo.done = this.todo.total;
                }
            }
        } else {
            // reset velocity
            this.todo.velocity = this.todo.minVelocity;


            // anything in the queue?
            if (this.cmdQ.length > 0)
                this.processCmd(this.popCmd());
        }

        // update pen position
        if (this.todo.pen != 0) {
            var z = this.state.penPos;
            z += this.todo.pen * this.todo.penVelocity * t;
            z = clamp(z, 0, 15);
            this.state.penPos = z;
        }
    }

    this.planMove = function(l,r) {
        this.todo.left += l;
        this.todo.right += r;
        this.todo.ww = Math.abs(this.todo.left) > Math.abs(this.todo.right);

        // distance required for acceleration to fullspeed (or stop)
        var d = (sqr(this.todo.maxVelocity) - sqr(this.todo.minVelocity)) / ( 2 * this.todo.acceleration );


        this.todo.total = this.todo.ww ? Math.abs(this.todo.left) : Math.abs(this.todo.right);

        this.todo.accelUntil = Math.min(d, this.todo.total/2);

        this.todo.decelFrom = Math.max(this.todo.total/2, this.todo.total - d);

        this.todo.done = 0;
    }


    this.processCmd = function(cmd) {
        if (!cmd || cmd == '') return;

        var p = cmd.split(' ');
        if (p[0] == 'FD') {
            this.drive(parseFloat(p[1]));
        } else if (p[0] == 'BK') {
            this.drive(-parseFloat(p[1]));
        } else if (p[0] == 'LT') {
            this.turn(parseFloat(p[1]));
        } else if (p[0] == 'RT') {
            this.turn(-parseFloat(p[1]));
        } else if (p[0] == 'TO') {
            this.driveTo(parseFloat(p[1]), parseFloat(p[2]));
        } else if (p[0] == 'WADDLE') {
            this.waddle();
        } else if (p[0] == 'PU') {
            this.penUp();
        } else if (p[0] == 'PD') {
            this.penDown();
        } else if (p[0] == 'ARC') {
            this.arcTo(parseFloat(p[1]), parseFloat(p[2]));
        }
    }


    this.drive = function(dist) {
        this.planMove(dist, dist);
    }

    this.turn = function(ang) {
        var circum = 2 * Math.PI * this.wheelSpacing/2;
        var d = circum * ang/360;

        this.planMove(-d, d);
    }

    this.driveTo = function(x,y) {
        var v = new THREE.Vector2(x,y);
        v.sub(new THREE.Vector2(this.state.x, this.state.y));

        var targetAng = radToDeg(Math.atan2(v.y, v.x)) - 90;

        if (this.state.angle != targetAng) {
            this.turn(targetAng - this.state.angle);
        }


        this.insertCmd("FD "+v.length().toFixed(1));
    }

    this.arcTo = function(x,y) {
        var v = new THREE.Vector2(x,y);
        v.sub(new THREE.Vector2(this.state.x, this.state.y));

        v.rotate(degToRad(-this.state.angle));


        var m = -v.x / v.y;

        // calc centre of arc
        // from equation
        // y - y1 = m (x - x1)
        // rearranged to find y axis intersection
        // x = (-y1)/m + x1
        var x1 = -(v.y/2) / m + (v.x/2);

        console.log(v.x, v.y, x1);


        if (x1 < 0) {
            var targetAng = radToDeg(Math.atan2(v.y, -x1 + v.x));

            var cl = 2 * Math.PI * (-this.wheelSpacing/2 - x1);
            var dl = cl * targetAng/360;

            var cr = 2 * Math.PI * (this.wheelSpacing/2 - x1);
            var dr = cr * targetAng/360;

            console.log(targetAng, dl, dr);
            this.planMove(dl, dr);

        } else {
            var targetAng = radToDeg(Math.atan2(v.y, x1 - v.x));

            var cl = 2 * Math.PI * (x1 + this.wheelSpacing/2 );
            var dl = cl * targetAng/360;

            var cr = 2 * Math.PI * (x1 - this.wheelSpacing/2);
            var dr = cr * targetAng/360;

            this.planMove(dl, dr);
        }



    }


    this.waddle = function() {

        this.planMove(
             100 * Math.random() - 50,
             100 * Math.random() - 50
         );
    }

    this.penUp = function() {
        this.todo.pen = 15 - this.state.penPos;
    }

    this.penDown = function() {
        this.todo.pen = 0 - this.state.penPos;
    }


    return this;
};

// enrich
THREE.Vector2.prototype.rotate = function(ang) {
    // pass angle in radians
    var x = this.x;
    var y = this.y;
    this.x = x * Math.cos(ang) - y * Math.sin(ang);
    this.y = x * Math.sin(ang) + y * Math.cos(ang);
}
