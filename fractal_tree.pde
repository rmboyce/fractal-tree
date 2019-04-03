//Angle
float angle = radians(90);
float angle_inc = PI / 384.0;
int will_inc = 0;

//Branch
int numBranches = 0;//3;
float reduct = 0;//0.5;
float min_len = 4.5;

//Console
int fsize = 20;
Console c = new Console(10, 20, fsize);
boolean changedText = false;
boolean space = false;

//Test number of operations
int operations = 0;
int max_op = 50000;
int tmax_op = 200000;

void setup() {
  size(1000, 1000);
  strokeWeight(2);
  stroke(10);
  c.activate();
}


void draw() {
  angle += will_inc * angle_inc;
  String[] splitChars = c.chars.split(",");
  int cl = splitChars.length;
  if (cl >= 1 && splitChars[0] != null) {
    numBranches = int(splitChars[0]);
  }
  else {
    numBranches = 2;
  }
  if (cl >= 2 && splitChars[1] != null) {
    reduct = float(splitChars[1]);
  }
  else {
    reduct = 0.5;
  }
  if (cl >= 3 && splitChars[2] != null) {
    min_len = float(splitChars[2]);
  }
  else {
    min_len = 4.5;
  }
  if (cl >= 4 && splitChars[3] != null) {
    angle = radians(int(splitChars[3]));
  }
  //else {
  //  angle = 90;
  //}
  background(0, 0, 0);
  stroke(255, 255, 255);
  c.display();
  translate(width / 2.0, 0);
  if (min_len <= 0) {
    text("The minimum branch length should be greater than 0!", -width/2, 50);
    operations = max_op + 1;
  }
  else if (abs(reduct) >= 1) {
    text("The reduction factor should be less than 1!", -width/2, 50);
    operations = max_op + 1;
  }
  else {
    operationsCount(300);
    if (operations >= tmax_op) {
      text("Way too many operations!", -width/2, 50);
    }
  }
  //println(operations);
  //textSize(fsize);
  if (operations >= max_op) {
    text("Too many operations: " + operations, -width/2, 80);
  }
  else {
    if (numBranches % 2 == 0) {
      branchEven(300);
    }
    else {
      branchOdd(300);
    }
  }
  operations = 0;
}

void branchEven(float len) {
  line(0, 0, 0, len);
  translate(0, len);
  if (min_len != 0 && len > min_len && operations < max_op) {
    //pushMatrix();
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
    //popMatrix();
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

void operationsCount(float len) {
  operations++;
  if (len > min_len && operations < tmax_op) {
    for (int i = 0; i <= numBranches/2; i++) {
      operationsCount(len * reduct);
      operationsCount(len * reduct);
    }
  }
}

void mouseDragged() {
  if (pmouseX < mouseX) {
    will_inc = 1;
  }
  else if (pmouseX > mouseX) {
    will_inc = -1;
  }
}

void mousePressed() {
  will_inc = 0;
}

void keyPressed() {
  if (keyCode == BACKSPACE)
  {
    c.deleteChar();
    space = true;
  }
  else if (keyCode == 32) {
    space = true;
  }
}

void keyTyped() {
  if (!space) {
    c.addChar(key);
  }
  space = false;
}
