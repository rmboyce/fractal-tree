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
  hs2.setNormalPos(0.4f);
  hs3 = new HScrollbar(1000, 550, 400, 20, 3, false);
  hs4 = new HScrollbar(1000, 750, 400, 20, 3, true);
  hs4.rollingUp = true;
  hs4.rollingSpeed = 0.7f;
}

void TextHScrollbar(HScrollbar hs, String s, String lowVal, String highVal, 
                    float per, boolean isPerInt) {
  hs.update();
  hs.display();
  fill(255, 255, 255);
  textSize(30);
  text(s, hs.xpos, hs.ypos - 50);
  textSize(20);
  text(lowVal, hs.xpos, hs.ypos - 15);
  text(highVal, hs.xpos + hs.swidth - 15, hs.ypos - 15);
  if (isPerInt) {
    text((int) per, hs.xpos, hs.ypos + 50);
  }
  else {
    text(per, hs.xpos, hs.ypos + 50);
  }
}

void draw() {
  background(0, 0, 0);
  
  //Input
  numBranches = (int) (2.5 + hs1.normalPos * 3);
  TextHScrollbar(hs1, "Number of branches", "2", "5", numBranches, true);
  
  reduct = hs2.normalPos;
  TextHScrollbar(hs2, "Fractional length of new branches", "0", "1", 
                 reduct, false);
                 
  min_len = hs3.normalPos * 10;
  TextHScrollbar(hs3, "Minimum branch length", "0", "10", min_len, false);
  
  angle = hs4.normalPos * TWO_PI;
  TextHScrollbar(hs4, "Branch angle", "0", "6.283", angle, false);
  
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
