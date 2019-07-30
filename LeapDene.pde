import de.voidplus.leapmotion.*;

LeapMotion leap;

ArrayList<PVector> kupler = new ArrayList<PVector>();

void setup() {
  size(900, 900, P3D);
  leap = new LeapMotion(this);
}

void draw() {
  background(0);
  camera(width/2, height/2, (height/2) / tan(PI/6), mouseX, mouseY, 0, 0, 1, 0);
  pointLight(0, 255, 255, 0, height/2, 300);
  pointLight(255, 255, 0, width, height/2, 300);

  for (Hand hand : leap.getHands()) {
    Finger index = hand.getIndexFinger();
    PVector pos = index.getPosition();
    Finger orta = hand.getMiddleFinger();
    PVector pos2 = orta.getPosition();

    float z = map(pos.z, -15, 80, 550, 100);
    translate(pos.x, pos.y, z);
    stroke(color(255, 0, 0));
    noFill();
    box(20);
    translate(-pos.x, -pos.y, -z);

    float d = pos.dist(pos2);
    println(d);
    if (d < 70f) {
      kupler.add(new PVector(pos.x, pos.y, z));
    }
  }

  for (int i = 0; i < kupler.size(); i++) {
    translate(kupler.get(i).x, kupler.get(i).y, kupler.get(i).z);
    fill(color(kupler.get(i).x, kupler.get(i).y, 255));
    noStroke();
    box(15);
    translate(-kupler.get(i).x, -kupler.get(i).y, -kupler.get(i).z);
  }
}
