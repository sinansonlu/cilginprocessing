Oyuncu p1;

final int haneSayisiX = 20;
final int haneSayisiZ = 20;

Hane[][] bolum = new Hane[haneSayisiX][haneSayisiZ];

float haneX = 160;
float haneZ = 160;
float yilanParcaBoyutu = 4;
int sayac = 40;

void uza() {
  p1.uza();
}

void kisal() {
  p1.kisal();
}

void setup() {
  size(800, 600, P3D);
  p1 = new Oyuncu(0, 0, 500);
  sphereDetail(6);

  for (int i = 0; i < haneSayisiX; i++) {
    bolum[i] = new Hane[haneSayisiZ];
    for (int k = 0; k < haneSayisiZ; k++) {
      bolum[i][k] = new Hane(i, k);
    }
  }
}

void draw() {
  background(0);
  camera(p1.bas.x-200*cos(p1.aci), 100, p1.bas.z-200*sin(p1.aci), p1.bas.x, 0, p1.bas.z, 0, -1, 0);

  lightFalloff(1.0, 0.001, 0.0);
  ambientLight(100, 100, 100);
  pointLight(255, 255, 255, p1.bas.x, 200, p1.bas.z);

  noStroke();
  fill(#A4CFD3);

  p1.mantikHesapla();
  p1.ciz();

  int hx = (int)((p1.bas.x + (haneX/2)) / haneX);
  int hz = (int)((p1.bas.z + (haneZ/2)) / haneZ);

  // bolum[hx][hz].mevcut = true;

  bolum[hx][hz].cakismaTesti(p1.bas.x, p1.bas.z);

  for (int i = 0; i < haneSayisiX; i++) {
    for (int k = 0; k < haneSayisiZ; k++) {
      bolum[i][k].ciz();
    }
  }

  sayac--;

  if (sayac < 0) {
    sayac = 40;
    if(random(0,10) >= 5) {
      int x = (int)(random(0,haneSayisiX));
      int z = (int)(random(0,haneSayisiZ));
      float yx = random(x*haneX, (x+1)*haneX)-haneX/2;
      float yz = random(z*haneZ, (z+1)*haneZ)-haneZ/2;
      bolum[x][z].yiyecekler.add(new Yiyecek(yx,yz));
    }
    else{
      int x = (int)(random(0,haneSayisiX));
      int z = (int)(random(0,haneSayisiZ));
      float yx = random(x*haneX, (x+1)*haneX)-haneX/2;
      float yz = random(z*haneZ, (z+1)*haneZ)-haneZ/2;
      bolum[x][z].engeller.add(new Engel(yx,yz));
    }
  }
}

class Engel {
  float x, z;
  float boyut;
  float yukseklik;
  color renk;

  public Engel(float x, float z) {
    this.x = x;
    this.z = z;
    boyut = random(3,13);
    yukseklik = random(20,130);
    renk = lerpColor(color(#623651), color(#7C6183), random(1));
  }

  public void ciz() {
    pushMatrix();
    fill(renk);
    translate(x, 0, z);
    box(boyut, yukseklik, boyut);
    popMatrix();
  }

  public boolean cakismaTesti(float ox, float oz) {
    float mesafe = sqrt(pow(ox-x, 2) + pow(oz-z, 2));
    return mesafe < (boyut/2 + yilanParcaBoyutu);
  }
}

class Yiyecek {
  float x, z;
  float boyut;
  color renk;

  public Yiyecek(float x, float z) {
    this.x = x;
    this.z = z;
    boyut = random(3,5);
    renk = lerpColor(color(#FFF815), color(#EA1C1C), random(1));
  }

  public void ciz() {
    pushMatrix();
    fill(renk);
    translate(x, 0, z);
    sphere(boyut);
    popMatrix();
  }

  public boolean cakismaTesti(float ox, float oz) {
    float mesafe = sqrt(pow(ox-x, 2) + pow(oz-z, 2));
    return mesafe < (boyut + yilanParcaBoyutu);
  }
}

class Hane {
  int x, z;
  boolean mevcut = false;

  ArrayList<Yiyecek> yiyecekler = new ArrayList<Yiyecek>();
  ArrayList<Engel> engeller = new ArrayList<Engel>();

  public Hane(int x, int z) {
    this.x = x;
    this.z = z;
    for (int i = 0; i < 5; i++) {
      float yx = random(x*haneX, (x+1)*haneX)-haneX/2;
      float yz = random(z*haneZ, (z+1)*haneZ)-haneZ/2;
      yiyecekler.add(new Yiyecek(yx, yz));
    }

    for (int i = 0; i < 3; i++) {
      float yx = random(x*haneX, (x+1)*haneX)-haneX/2;
      float yz = random(z*haneZ, (z+1)*haneZ)-haneZ/2;
      engeller.add(new Engel(yx, yz));
    }
  }

  public void cakismaTesti(float ox, float oz) {
    for (int i = 0; i < yiyecekler.size(); i++) {
      if ((yiyecekler.get(i)).cakismaTesti(ox, oz)) {
        // çakışma var
        yiyecekler.remove(i);
        uza();
      }
    }

    for (int i = 0; i < engeller.size(); i++) {
      if ((engeller.get(i)).cakismaTesti(ox, oz)) {
        // çakışma var
        kisal();
      }
    }
  }

  public void ciz() {
    pushMatrix();
    translate(x*haneX, 0, z*haneZ);
    if (mevcut) {
      fill(#A5AA67);
    } else {
      fill(#534B55);
    }
    box(haneX, 1, haneZ);
    popMatrix();

    for (int i = 0; i < yiyecekler.size(); i++) {
      yiyecekler.get(i).ciz();
    }

    for (int i = 0; i < engeller.size(); i++) {
      engeller.get(i).ciz();
    }
  }
}

class Oyuncu {
  Parca bas;
  Parca son;

  float aci = 0;
  float aci_hizi = PI/100;

  float hiz = 2;

  public Oyuncu(float x, float z, int uzunluk) {
    bas = new Parca(x, z);

    Parca mevcutParca = bas;
    for (int i = 0; i < uzunluk; i++) {
      mevcutParca.sonraki = new Parca(x, z);
      mevcutParca = mevcutParca.sonraki;
    }

    son = mevcutParca;
  }

  public void kisal() {
    if (bas.sonraki != null) {
      bas = bas.sonraki;
    }
  }

  public void uza() {
    son.sonraki = new Parca(son.x, son.z);
    son = son.sonraki;
  }

  public void ciz() {
    fill(#FFBB33);

    bas.ciz();
  }

  public void mantikHesapla() {
    klavyeGirdisi();
    bas.hareketEttir(hiz*cos(aci), hiz*sin(aci));
  }

  void klavyeGirdisi() {
    if (keyPressed) {
      if (key == CODED) {
        if (keyCode == LEFT) {
          aci += aci_hizi;
        }
        if (keyCode == RIGHT) {
          aci -= aci_hizi;
        }
      }
    }
  }

  class Parca {
    float x, z;
    Parca sonraki;

    public Parca(float x, float z) {
      this.x = x;
      this.z = z;
    }

    public void hareketEttir(float dx, float dz) {
      if (sonraki != null) {
        sonraki.isinlan(x, z);
      }

      x += dx;
      z += dz;
    }

    public void isinlan(float hx, float hz) {
      if (sonraki != null) {
        sonraki.isinlan(x, z);
      }

      x = hx;
      z = hz;
    }

    public void ciz() {
      pushMatrix();
      translate(x, 0, z);
      sphere(yilanParcaBoyutu);
      popMatrix();
      if (sonraki != null) {
        sonraki.ciz();
      }
    }
  }
}
