//Angle
var angle;

//Branch
var numBranches = 0;//3;
var reduct = 0;//0.5;
var min_len = 4.5;

//Test number of operations
var numTreeLoop = 150;
var operations = 0;
var max_op = 50000;
var tmax_op = 200000;

//Input
var hs1;
var hs2;
var hs3;
var hs4;

function setup() {
  createCanvas(750, 450);
  strokeWeight(2);
  stroke(10);
  
	angle = radians(90);
	
  hs1 = new HScrollbar(500, 75, 200, 10, 3, false);
  hs2 = new HScrollbar(500, 175, 200, 10, 3, false);
  hs3 = new HScrollbar(500, 275, 200, 10, 3, false);
  hs4 = new HScrollbar(500, 375, 200, 10, 3, true);
}


function draw() {
  background(0, 0, 0);
  
  //Input
  hs1.update();
  hs1.display();
  fill(255, 255, 255);
  textSize(20);
  text("Number of branches", 500, 45);
  textSize(15);
  text("2", 500, 62.5);
  text("5", 692.5, 62.5);
  text((int) (2.5 + hs1.normalPos * 3), 500, 95);
  numBranches = (int) (2.5 + hs1.normalPos * 3);
  
  hs2.update();
  hs2.display();
  fill(255, 255, 255);
  textSize(20);
  text("Fractional length of new branches", 500, 145);
  textSize(15);
  text("0", 500, 162.5);
  text("1", 692.5, 162.5);
  text(round(hs2.normalPos, 3), 500, 195);
  reduct = hs2.normalPos;
  
  hs3.update();
  hs3.display();
  fill(255, 255, 255);
  textSize(20);
  text("Minimum branch length", 500, 245);
  textSize(15);
  text("0", 500, 262.5);
  text("10", 692.5, 262.5);
  text(round(hs3.normalPos * 10, 3), 500, 295);
  min_len = hs3.normalPos * 10;
  
  hs4.update();
  hs4.display();
  fill(255, 255, 255);
  textSize(20);
  text("Branch angle", 500, 345);
  textSize(15);
  text("0", 500, 362.5);
  text(round(TWO_PI, 3), 692.5, 362.5);
  text(round(hs4.normalPos * TWO_PI, 3), 500, 395);
  angle = hs4.normalPos * TWO_PI;
  
  //Drawing the tree
  stroke(255, 255, 255);
  translate(height / 2.0, 0);
  
  //Count number of operations
  operationsCount(numTreeLoop);
  if (operations >= tmax_op) {
    text("Way too many operations! (operations > " + tmax_op + ")", 50 - height/2, 50);
  }
  if (operations >= max_op) {
    text("Too many operations (" + operations + "), " + max_op + " is the max", 50 - height/2, 80);
  }
  else {
    //Else if the number of operations is okay draw the tree
    if (numBranches % 2 == 0) {
      branchEven(numTreeLoop);
    }
    else {
      branchOdd(numTreeLoop);
    }
  }
  operations = 0;
}

function branchEven(len) {
  line(0, 0, 0, len);
  translate(0, len);
  if (min_len != 0 && len > min_len && operations < max_op) {
    rotate(angle/2);
    for (let i = 0; i < numBranches/2; i++) {
      push();
      rotate(angle * i);
      branchEven(len * reduct);
      pop();
    }
    rotate(-angle);
    for (let i = 0; i < numBranches/2; i++) {
      push();
      rotate(-angle * i);
      branchEven(len * reduct);
      pop();
    }
  }
}

function branchOdd(len) {
  line(0, 0, 0, len);
  translate(0, len);
  if (min_len != 0 && len > min_len && operations < max_op) {
    for (let i = 0; i <= numBranches/2; i++) {
      push();
      rotate(angle * i);
      branchOdd(len * reduct);
      pop();
      push();
      rotate(-angle * i);
      branchOdd(len * reduct);
      pop();
    }
  }
}

//Count number of operations drawing a tree would take
function operationsCount(len) {
  operations++;
  if (len > min_len && operations < tmax_op) {
    for (let i = 0; i <= numBranches/2; i++) {
      operationsCount(len * reduct);
      operationsCount(len * reduct);
    }
  }
}