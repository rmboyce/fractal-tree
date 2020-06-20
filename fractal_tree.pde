//Angle
float angle = radians(90);

//Branch
int numBranches = 0;//3;
float reduct = 0;//0.5;
float min_len = 4.5;

//Test number of operations
int numTreeLoop = 300;
int operations = 0;
int max_op = 50000;
int tmax_op = 200000;

//Input
HScrollbar hs1;
HScrollbar hs2;
HScrollbar hs3;
HScrollbar hs4;

void setup() {
  size(1500, 900);
  strokeWeight(2);
  stroke(10);
  
  hs1 = new HScrollbar(1000, 150, 400, 20, 3, false);
  hs2 = new HScrollbar(1000, 350, 400, 20, 3, false);
  hs3 = new HScrollbar(1000, 550, 400, 20, 3, false);
  hs4 = new HScrollbar(1000, 750, 400, 20, 3, true);
}


void draw() {
  background(0, 0, 0);
  
  //Input
  hs1.update();
  hs1.display();
  fill(255, 255, 255);
  textSize(30);
  text("Number of branches", 1000, 90);
  textSize(20);
  text("2", 1000, 125);
  text("5", 1385, 125);
  text((int) (2.5 + hs1.normalPos * 3), 1000, 190);
  numBranches = (int) (2.5 + hs1.normalPos * 3);
  
  hs2.update();
  hs2.display();
  fill(255, 255, 255);
  textSize(30);
  text("Fractional length of new branches", 1000, 290);
  textSize(20);
  text("0", 1000, 325);
  text("1", 1385, 325);
  text(hs2.normalPos, 1000, 390);
  reduct = hs2.normalPos;
  
  hs3.update();
  hs3.display();
  fill(255, 255, 255);
  textSize(30);
  text("Minimum branch length", 1000, 490);
  textSize(20);
  text("0", 1000, 525);
  text("10", 1385, 525);
  text(hs3.normalPos * 10, 1000, 590);
  min_len = hs3.normalPos * 10;
  
  hs4.update();
  hs4.display();
  fill(255, 255, 255);
  textSize(30);
  text("Branch angle", 1000, 690);
  textSize(20);
  text("0", 1000, 725);
  text(TWO_PI, 1385, 725);
  text(hs4.normalPos * TWO_PI, 1000, 790);
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

void branchEven(float len) {
  line(0, 0, 0, len);
  translate(0, len);
  if (min_len != 0 && len > min_len && operations < max_op) {
    rotate(angle/2);
    for (int i = 0; i < numBranches/2; i++) {
      pushMatrix();
      rotate(angle * i);
      branchEven(len * reduct);
      popMatrix();
    }
    rotate(-angle);
    for (int i = 0; i < numBranches/2; i++) {
      pushMatrix();
      rotate(-angle * i);
      branchEven(len * reduct);
      popMatrix();
    }
  }
}

void branchOdd(float len) {
  line(0, 0, 0, len);
  translate(0, len);
  if (min_len != 0 && len > min_len && operations < max_op) {
    for (int i = 0; i <= numBranches/2; i++) {
      pushMatrix();
      rotate(angle * i);
      branchOdd(len * reduct);
      popMatrix();
      pushMatrix();
      rotate(-angle * i);
      branchOdd(len * reduct);
      popMatrix();
    }
  }
}

//Count number of operations drawing a tree would take
void operationsCount(float len) {
  operations++;
  if (len > min_len && operations < tmax_op) {
    for (int i = 0; i <= numBranches/2; i++) {
      operationsCount(len * reduct);
      operationsCount(len * reduct);
    }
  }
}
