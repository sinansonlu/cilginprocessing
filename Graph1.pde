ArrayList<Node> graph = new ArrayList<Node>();
float nodeBoyut = 50;

void setup() {
  size(900, 900, P2D);
  ellipseMode(CENTER);
  textAlign(CENTER);
  rastgeleGraphOlustur();
}

void rastgeleGraphOlustur() {
  int nodeSayisi = 40;
  for (int i = 0; i < nodeSayisi; i++) {
    graph.add(new Node(random(0, width), random(0, height), "I = " + i));
  }

  float baglilikOrani = 0.08f;

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
    for (int i = graph.size() - 1; i >= 0 ; i--) {
      if (graph.get(i).FareUzerindeMi(mouseX, mouseY)) {
        graph.get(i).KomsularinaVedaEt();
        graph.remove(i);
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

class Node {
  public float x;
  public float y;
  public String isim;
  public int mod;

  public ArrayList<Node> komsular;

  public Node(float x, float y, String isim) {
    this.x = x;
    this.y = y;
    this.isim = isim;
    mod = 0;
    komsular = new ArrayList<Node>();
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
      if (mod == 0) {
        noStroke();
      } else if (mod==1) {
        stroke(#EABD15);
        strokeWeight(4);
      }
    }
    circle(x, y, nodeBoyut);
    fill(0);
    textSize(16);
    text(isim, x, y+6);
  }

  public void BaglantilariCiz() {
    if (mod == 0) {
      strokeWeight(3);
      stroke(#8588A5);
    } else if (mod==1) {
      strokeWeight(4);
      stroke(#FFE836);
    }
    for (int i = 0; i < komsular.size(); i++) {
      line(x, y, komsular.get(i).x, komsular.get(i).y);
    }
  }
}
