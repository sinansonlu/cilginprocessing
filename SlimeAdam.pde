import java.util.Comparator;

color disAlan = color(#4D3E55);
PVector sinirlar = new PVector(500, 500);
ArrayList<Adam> adamlar = new ArrayList<Adam>();

float sayac = 0.1f;
float maxBoyut;

void setup() {
  size(800, 600, P3D);
  sphereDetail(6);

  for (int i = 0; i < 200; i++) {
    adamlar.add(new Adam());
  }
}

void draw() {
  background(disAlan);

  camera(mouseX-width/2, mouseY, -sinirlar.y, 0, 0, 0, 0, -1, 0);

  noStroke();

  lightFalloff(1.0, 0.001, 0.0);
  ambientLight(red(disAlan)*1.5, green(disAlan)*1.5, blue(disAlan)*1.5);
  pointLight(255, 255, 255, 0, 300, 0);

  fill(#A4CFD3);
  box(sinirlar.x*2, 1, sinirlar.y*2);

  adamlar.sort(new Comparator<Adam>() {
    @Override
      public int compare(Adam lhs, Adam rhs) {
      if (lhs.boyut > rhs.boyut) {
        return -1;
      } else {
        return 1;
      }
    }
  }
  );

  if (adamlar.size()> 0) {
    maxBoyut = adamlar.get(0).boyut;
  }

  for (int i = 0; i < adamlar.size(); i++) {
    adamlar.get(i).isle();
  }

  for (int i = 0; i < adamlar.size(); i++) {
    adamlar.get(i).ciz();
  }

  sayac -= 1.0/frameRate;

  if (sayac <= 0) {
    adamlar.add(new Adam());
    sayac = 0.1;
  }

  for (int i = 0; i < adamlar.size(); i++) {
    for (int j = 0; j < i; j++) {
      Adam a1 = adamlar.get(i);
      Adam a2 = adamlar.get(j);
      if (a1.konum.dist(a2.konum) <= (a1.boyut+a2.boyut)) {
        adamlar.remove(i);
        a2.boyut += a1.boyut / a2.boyut;
        if (a2.hedef == a1) {
          a2.hedef = null;
        }
        i--;
      }
    }
  }
}

class Adam {

  public PVector konum;
  float boyut;
  float hiz;

  Adam hedef;
  color c;

  public Adam() {
    konum = new PVector(random(-sinirlar.x, sinirlar.x), random(-sinirlar.y, sinirlar.y));
    boyut = random(3.0, 9.0);
    hiz = random(1.0, 3.0);
    c = color(random(255), random(255), random(255));
  }

  public void ciz() {
    fill(c);
    pushMatrix();
    translate(konum.x, 0, konum.y);
    sphere(boyut);
    popMatrix();
  }

  public void isle() {
    if (hedef != null) {
      PVector yerDegistirme = PVector.sub(hedef.konum, konum).normalize().mult(hiz-(boyut/maxBoyut));
      konum = PVector.add(konum, yerDegistirme);

      if (yerDegistirme.mag() < hiz) {
        hedef = null;
      }
    } else {
      int i = adamlar.indexOf(this);
      i = (i + 1) % adamlar.size();
      hedef = adamlar.get(i);
    }
  }
}
