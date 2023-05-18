ArrayList<Node> graph = new ArrayList<Node>();
float nodeBoyut = 50;
int enUzakMesafe = 0;

void setup() {
  size(900, 900, P2D);
  ellipseMode(CENTER);
  textAlign(CENTER);
  rastgeleGraphOlustur();
}

void rastgeleGraphOlustur() {
  int nodeSayisi = 50;
  for (int i = 0; i < nodeSayisi; i++) {
    graph.add(new Node(random(0, width), random(0, height), "I = " + i));
  }

  float baglilikOrani = 0.03f;

  for (int i = 0; i < nodeSayisi; i++) {
    for (int j = 0; j < nodeSayisi; j++) {
      if (i != j && baglilikOrani > random(0f, 1f)) {
        graph.get(i).KomsuEkle(graph.get(j));
      }
    }
  }
}

void draw() {
  background(25);

  for (int i = 0; i < graph.size(); i++) {
    graph.get(i).BaglantilariCiz();
  }

  for (int i = 0; i < graph.size(); i++) {
    graph.get(i).KendiniCiz(false);
  }

  if (seciliNode != null && solTusBasili) {
    if (mouseX >= 0 && mouseX <= width) {
      seciliNode.x = mouseX;
    }
    if (mouseY >= 0 && mouseY <= height) {
      seciliNode.y = mouseY;
    }
    seciliNode.BaglantilariCiz();
    for (int i = 0; i < seciliNode.komsular.size(); i++) {
      seciliNode.komsular.get(i).KendiniCiz(true);
    }
    seciliNode.KendiniCiz(false);
  }
}

boolean solTusBasili = false;
Node seciliNode = null;

void mousePressed() {
  if (mouseButton == LEFT) {
    for (int i = 0; i < graph.size(); i++) {
      if (graph.get(i).FareUzerindeMi(mouseX, mouseY)) {
        seciliNode = graph.get(i);
        seciliNode.mod = 1;
        break;
      }
    }
    solTusBasili = true;
  } else if (mouseButton == RIGHT) {
    for (int i = graph.size() - 1; i >= 0; i--) {
      if (graph.get(i).FareUzerindeMi(mouseX, mouseY)) {
        graph.get(i).KomsularinaVedaEt();
        graph.remove(i);
        break;
      }
    }
  }
}

void keyPressed() {
  if (key == 'b') {
    for (int i = 0; i < graph.size(); i++) {
      if (graph.get(i).FareUzerindeMi(mouseX, mouseY)) {
        breadthFirstSearch(graph.get(i));
        break;
      }
    }
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    if (seciliNode != null) {
      seciliNode.mod = 0;
      seciliNode = null;
    }
    solTusBasili = false;
  }
}

void breadthFirstSearch(Node n) {
  for (int i = 0; i < graph.size(); i++) {
    graph.get(i).ziyaretEdildi = false;
  }

  ziyaretListesi = new ArrayList<Node>();
  ziyaretListesineEkle(n);
  n.mesafe = 0;
  n.ziyaretEdildi = true;

  while (ziyaretListesi.size() > 0) {
    Node mevcut = ziyaretListesindenAl();

    for (int i = 0; i < mevcut.komsular.size(); i++) {
      if (!mevcut.komsular.get(i).ziyaretEdildi) {
        mevcut.komsular.get(i).mesafe = mevcut.mesafe + 1;
        mevcut.komsular.get(i).ziyaretEdildi = true;
        ziyaretListesineEkle(mevcut.komsular.get(i));
      }
    }
  }

  // mesafeye göre yerleşim zamanı!
  enUzakMesafe = 0;
  for (int i = 0; i < graph.size(); i++) {
    if (graph.get(i).ziyaretEdildi) {
      if (enUzakMesafe < graph.get(i).mesafe) {
        enUzakMesafe = graph.get(i).mesafe;
      }
    }
  }

  int[] mesafeler = new int[enUzakMesafe];
  int sonsuzdakiSayisi = 0;
  for (int i = 0; i < graph.size(); i++) {
    if (graph.get(i).ziyaretEdildi) {
      if (graph.get(i).mesafe != 0) {
        mesafeler[graph.get(i).mesafe-1]++;
      }
    } else {
      sonsuzdakiSayisi++;
    }
  }

  float[] acilar = new float[enUzakMesafe];
  float sonsuzdakiAcilar = 2 * PI / sonsuzdakiSayisi;

  for (int i = 0; i < mesafeler.length; i++) {
    acilar[i] = 2 * PI / mesafeler[i];
  }

  float yariCapAtalama = (width-40)/2/(enUzakMesafe + 1);
  for (int i = 0; i < graph.size(); i++) {
    if (graph.get(i).ziyaretEdildi) {
      if (graph.get(i).mesafe == 0) {
        graph.get(i).x = width/2;
        graph.get(i).y = height/2;
      } else {
        float aci = acilar[graph.get(i).mesafe-1] * mesafeler[graph.get(i).mesafe-1];
        mesafeler[graph.get(i).mesafe-1]--;
        float yariCap = graph.get(i).mesafe * yariCapAtalama;
        graph.get(i).x = width/2 + cos(aci) * yariCap;
        graph.get(i).y = height/2 + sin(aci) * yariCap;
      }
    } else {
      float aci = sonsuzdakiAcilar * sonsuzdakiSayisi;
      sonsuzdakiSayisi--;
      float yariCap = (enUzakMesafe + 1) * yariCapAtalama;
      graph.get(i).x = width/2 + cos(aci) * yariCap;
      graph.get(i).y = height/2 + sin(aci) * yariCap;
    }
  }
}

ArrayList<Node> ziyaretListesi;

void ziyaretListesineEkle(Node n) {
  ziyaretListesi.add(n);
}

Node ziyaretListesindenAl() {
  Node mevcut = ziyaretListesi.get(0);
  ziyaretListesi.remove(0);
  return mevcut;
}

class Node {
  public float x;
  public float y;
  public String isim;
  public int mod;
  public boolean ziyaretEdildi;
  public int mesafe;

  public ArrayList<Node> komsular;

  public Node(float x, float y, String isim) {
    this.x = x;
    this.y = y;
    this.isim = isim;
    mod = 0;
    komsular = new ArrayList<Node>();
    ziyaretEdildi = false;
  }

  public void KomsuEkle(Node komsu) {
    if (!SuKomsuVarMi(komsu)) {
      komsular.add(komsu);
      komsu.KomsuEkle(this);
    }
  }

  public void KomsuCikar(Node komsu) {
    komsular.remove(komsu);
  }

  public void KomsularinaVedaEt() {
    for (int i = 0; i < komsular.size(); i++) {
      komsular.get(i).KomsuCikar(this);
    }
  }

  public boolean SuKomsuVarMi(Node komsu) {
    return komsular.contains(komsu);
  }

  public boolean FareUzerindeMi(float mx, float my) {
    return dist(x, y, mx, my) < nodeBoyut;
  }

  public void KendiniCiz(boolean oneCik) {
    fill(255);
    if (oneCik) {
      stroke(#E865D2);
      strokeWeight(4);
    } else {
      noStroke();
      if(ziyaretEdildi && mesafe != 0) {
        stroke(lerpColor(#FF0000,#0A66FF,float(mesafe)/enUzakMesafe));
        strokeWeight(8);
      }
      if (mod==1) {
        stroke(#EABD15);
        strokeWeight(4);
      }
    }
    circle(x, y, nodeBoyut);
    fill(0);
    textSize(16);
    text(isim, x, y+6);
    if (ziyaretEdildi) {
      textSize(14);
      text("" + mesafe, x, y+18);
    }
  }

  public void BaglantilariCiz() {
    strokeWeight(3);
    stroke(#8588A5);

    if (mod==1) {
      strokeWeight(4);
      stroke(#FFE836);
    }

    for (int i = 0; i < komsular.size(); i++) {
      line(x, y, komsular.get(i).x, komsular.get(i).y);
    }
  }
}
