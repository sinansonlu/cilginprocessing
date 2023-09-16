import com.jogamp.newt.opengl.GLWindow;

PVector konum = new PVector(0, 0, 0);
float bakisAciYatay, bakisAciDikey;
float dx, dy, dz;
float tmpx, tmpy, tmpz;

float fareHassasiyeti = 0.003;

GLWindow r;

boolean basiliW, basiliS, basiliA, basiliD;

Hane[][] haneler;
float haneBoyutu = 10;

void setup() {
  size(1200, 800, P3D);
  r = (GLWindow)surface.getNative();
  r.confinePointer(true);
  r.warpPointer(width/2, height/2);
  r.setPointerVisible(false);
  perspective(PI/3.0, float(width)/float(height), 0.0001, 100000);

  haneler = new Hane[100][100];

  for (int i = 0; i < 100; i++) {
    for (int j = 0; j < 100; j++) {
      if (random(1) < 0.09) {
        haneler[i][j] = new Hane(haneBoyutu*(i-50), 0, haneBoyutu*(j-50));
      } else {
        haneler[i][j] = new Hane();
      }
    }
  }
}

void hareketEt(float vx, float vy, float vz) {
  tmpx = konum.x + vx + haneBoyutu/2;
  tmpy = konum.y + vy;
  tmpz = konum.z + vz + haneBoyutu/2;
  
  if (haneler[(int)((tmpx/haneBoyutu)+50)][(int)((tmpz/haneBoyutu)+50)].bosMu) {
    konum.add(vx, vy, vz);
  }
  else{
    if (haneler[(int)(((konum.x+haneBoyutu/2)/haneBoyutu)+50)][(int)((tmpz/haneBoyutu)+50)].bosMu) {
      konum.add(0, vy, vz);
    }
    else if (haneler[(int)((tmpx/haneBoyutu)+50)][(int)(((konum.z+haneBoyutu/2)/haneBoyutu)+50)].bosMu) {
      konum.add(vx, vy, 0);
    }
  }
}

void draw() {
  dz = sin(bakisAciYatay) * cos(bakisAciDikey);
  dy = sin(bakisAciDikey);
  dx = cos(bakisAciYatay);

  if (basiliW) {
    hareketEt(dx, 0, dz);
  }
  if (basiliS) {
    hareketEt(-dx, 0, -dz);
  }
  if (basiliD) {
    tmpz = sin(bakisAciYatay + PI/2) * cos(bakisAciDikey);
    tmpx = cos(bakisAciYatay + PI/2);
    hareketEt(tmpx, 0, tmpz);
  }
  if (basiliA) {
    tmpz = sin(bakisAciYatay - PI/2) * cos(bakisAciDikey);
    tmpx = cos(bakisAciYatay - PI/2);
    hareketEt(tmpx, 0, tmpz);
  }

  noFill();
  background(204);

  camera(konum.x, konum.y, konum.z, konum.x + dx, konum.y + dy, konum.z + dz, 0.0, 1.0, 0.0);

  for (int i = 0; i < 100; i++) {
    for (int j = 0; j < 100; j++) {
      if (!haneler[i][j].bosMu) {
        pushMatrix();
        PVector k = haneler[i][j].konum;
        translate(k.x, k.y, k.z);
        box(haneBoyutu);
        popMatrix();
      }
    }
  }
}

void mouseMoved() {
  bakisAciYatay += (mouseX - width/2) * fareHassasiyeti;
  bakisAciDikey += (mouseY - height/2) * fareHassasiyeti;
  bakisAciDikey = constrain(bakisAciDikey, -PI/2, PI/2);
  r.warpPointer(width/2, height/2);
}

void keyPressed() {
  if (key == 'w' || key == 'W') {
    basiliW = true;
  }
  if (key == 's' || key == 'S') {
    basiliS = true;
  }
  if (key == 'd' || key == 'D') {
    basiliD = true;
  }
  if (key == 'a' || key == 'A') {
    basiliA = true;
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    basiliW = false;
  }
  if (key == 's' || key == 'S') {
    basiliS = false;
  }
  if (key == 'd' || key == 'D') {
    basiliD = false;
  }
  if (key == 'a' || key == 'A') {
    basiliA = false;
  }
}

class Hane {
  boolean bosMu;
  PVector konum;

  public Hane() {
    bosMu = true;
  }

  public Hane(float x, float y, float z) {
    bosMu = false;
    konum = new PVector(x, y, z);
  }
}
