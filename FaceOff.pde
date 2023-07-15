import processing.javafx.*;
import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;

import processing.video.Capture;

Capture cam;
PImage yeniYuz;

ArrayList<Nokta> yeniNoktalar = new ArrayList<Nokta>();
ArrayList<Ucgen> ucgenler = new ArrayList<Ucgen>();

int kaymaMiktari = 640;

class Ucgen {
  public int i1;
  public int i2;
  public int i3;

  public Ucgen(int i1, int i2, int i3) {
    this.i1 = i1;
    this.i2 = i2;
    this.i3 = i3;
  }
}

class Nokta {
  public int x;
  public int y;

  public Nokta(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

DeepVision vision = new DeepVision(this);
CascadeClassifierNetwork faceNetwork;
FacemarkLBFNetwork facemark;

ResultList<ObjectDetectionResult> detections;
ResultList<FacialLandmarkResult> markedFaces;

public void setup() {
  points = new ArrayList<PVector>();

  yeniYuz = loadImage("doom.jpg");
  textureMode(IMAGE);

  size(1000, 480, P3D);
  colorMode(HSB, 360, 100, 100);

  println("creating network...");
  faceNetwork = vision.createCascadeFrontalFace();
  facemark = vision.createFacemarkLBF();

  println("loading model...");
  faceNetwork.setup();
  facemark.setup();

  println("setup camera...");
  String[] cams = Capture.list();
  cam = new Capture(this, cams[0]);
  cam.start();

  detections = faceNetwork.run(yeniYuz);
  markedFaces = facemark.runByDetections(yeniYuz, detections);

  for (int i = 0; i < detections.size(); i++) {
    FacialLandmarkResult landmarks = markedFaces.get(i);
    if (landmarks.getKeyPoints().size() > 0) {
      for (int j = 0; j < landmarks.getKeyPoints().size(); j++) {
        KeyPointResult kp = landmarks.getKeyPoints().get(j);
        yeniNoktalar.add(new Nokta(kp.getX(), kp.getY()));
        points.add(new PVector(kp.getX(), kp.getY()));
      }
    }
  }

  UcgenleriTespitEt();
}

FacialLandmarkResult landmarks;

public void draw() {
  background(55);

  if (cam.available()) {
    cam.read();
    cam.loadPixels();
  }

  image(cam, 0, 0);

  image(yeniYuz, kaymaMiktari, 0);

  detections = faceNetwork.run(cam);

  markedFaces = facemark.runByDetections(cam, detections);

  for (int i = 0; i < detections.size(); i++) {
    landmarks = markedFaces.get(i);

    noFill();
    strokeWeight(2f);
    stroke(200, 80, 100);

    noStroke();
    fill(100, 80, 200);
    for (int j = 0; j < landmarks.getKeyPoints().size(); j++) {
      KeyPointResult kp = landmarks.getKeyPoints().get(j);
      ellipse(kp.getX(), kp.getY(), 5, 5);
    }

    if (landmarks.getKeyPoints().size() > 0) {
      /*ucluEkle(0, 1, 36);
       ucluEkle(45, 16, 26);
       dortluEkle(36, 1, 2, 41);
       dortluEkle(2, 3, 40, 41);
       dortluEkle(3, 4, 39, 40);
       ucluEkle(4, 5, 48);
       dortluEkle(4, 48, 31, 39);
       dortluEkle(48, 60, 49, 31);
       ucluEkle(60, 59, 49);
       ucluEkle(49, 50, 61);
       ucluEkle(59, 61, 49);
       ucluEkle(59, 66, 61);
       dortluEkle(59, 58, 66, 67);
       dortluEkle(67, 66, 62, 61);
       dortluEkle(61, 62, 52, 50);
       dortluEkle(49, 50, 32, 31);
       dortluEkle(50, 51, 33, 32);
       dortluEkle(39, 31, 28, 27);
       ucluEkle(39, 27, 21);*/

      for (int u = 0; u < ucgenler.size(); u++) {
        ucluEkle(ucgenler.get(u));
      }
    }
  }

  for (int i = 0; i < yeniNoktalar.size(); i++) {
    ellipse(yeniNoktalar.get(i).x + kaymaMiktari, yeniNoktalar.get(i).y, 5, 5);
  }
}

public void ucluEkle(Ucgen u) {
  beginShape();
  texture(yeniYuz);
  noktaEkle(u.i1);
  noktaEkle(u.i2);
  noktaEkle(u.i3);
  endShape();
}

public void ucluEkle(int i1, int i2, int i3) {
  beginShape();
  texture(yeniYuz);
  noktaEkle(i1);
  noktaEkle(i2);
  noktaEkle(i3);
  endShape();
}

public void dortluEkle(int i1, int i2, int i3, int i4) {
  beginShape();
  texture(yeniYuz);
  noktaEkle(i1);
  noktaEkle(i2);
  noktaEkle(i3);
  noktaEkle(i4);
  endShape();
}

public void noktaEkle(int index) {
  vertex(landmarks.getKeyPoints().get(index).getX(), landmarks.getKeyPoints().get(index).getY(),
    yeniNoktalar.get(index).x, yeniNoktalar.get(index).y);
}

public void UcgenleriTespitEt() {
  DelaunayTriangulator dt = Triangulate();
  for (int i = 0; i < dt.triangles.size(); i++) {
    int i1 = indeksBul(dt.triangles.get(i).points[0]);
    int i2 = indeksBul(dt.triangles.get(i).points[1]);
    int i3 = indeksBul(dt.triangles.get(i).points[2]);

    ucgenler.add(new Ucgen(i1, i2, i3));
  }
}

public int indeksBul(PVector p) {
  for (int i = 0; i < points.size(); i++) {
    if (points.get(i).x == p.x && points.get(i).y == p.y) {
      return i;
    }
  }
  return -1;
}

// kodun geri kalanı şuradan alıntıdır: https://github.com/robu3/delaunay
ArrayList<PVector> points;
DelaunayTriangulator dt;

DelaunayTriangulator Triangulate() {
  dt = new DelaunayTriangulator();
  dt.points = points.toArray(new PVector[points.size()]);
  dt.triangles = dt.Calculate();
  return dt;
}

public class DelaunayTriangulator {
  PVector[] points;
  ArrayList<Triangle> triangles;

  public Triangle GetSuperTriangle() {
    // find min & max x and y values
    float xMin = points[0].x;
    float yMin = points[0].y;
    float xMax = xMin;
    float yMax = yMin;

    for (int i = 0; i < points.length; i++) {
      PVector p = points[i];
      if (p.x < xMin) {
        xMin = p.x;
      }
      if (p.x > xMax) {
        xMax = p.x;
      }
      if (p.y < xMin) {
        xMin = p.y;
      }
      if (p.y > xMax) {
        xMax = p.y;
      }
    }

    float dx = xMax - xMin;
    float dy = yMax - yMin;
    float dMax = dx > dy ? dx : dy;
    float xMid = (xMin + xMax) / 2f;
    float yMid = (yMin + yMax) / 2f;

    Triangle superTri = new Triangle(
      new PVector(xMid - 2f * dMax, yMid - dMax),
      new PVector(xMid, yMid + 2f * dMax),
      new PVector(xMid + 2f * dMax, yMid - dMax)
      );

    return superTri;
  }

  public ArrayList<Triangle> Calculate()
  {
    ArrayList<Triangle> triangleBuffer = new ArrayList<Triangle>();
    ArrayList<Triangle> completed = new ArrayList<Triangle>();

    Triangle superTriangle = GetSuperTriangle();
    triangleBuffer.add(superTriangle);

    PVector point;
    ArrayList<Edge> edgeBuffer = new ArrayList<Edge>();
    for (int i = 0; i < points.length; i++) {
      point = points[i];
      edgeBuffer.clear();
      for (int j = triangleBuffer.size() - 1; j >= 0; j--) {
        Triangle tri = triangleBuffer.get(j);

        PVector circumcenter = tri.GetCircumcenter();
        float rad = circumcenter.dist(tri.points[0]);

        if (circumcenter.x + rad < point.x) {
          completed.add(tri);
        }

        if (circumcenter.dist(point) < rad) {
          edgeBuffer.add(new Edge(tri.points[0], tri.points[1]));
          edgeBuffer.add(new Edge(tri.points[1], tri.points[2]));
          edgeBuffer.add(new Edge(tri.points[2], tri.points[0]));
          triangleBuffer.remove(j);
        }
      }

      for (int j = 0; j < edgeBuffer.size() - 1; j++) {
        Edge edgeA = edgeBuffer.get(j);
        if (edgeA != null) {
          for (int k = j + 1; k < edgeBuffer.size(); k++) {
            Edge edgeB = edgeBuffer.get(k);
            if (edgeA.IsEqual(edgeB)) {
              edgeBuffer.set(j, null);
              edgeBuffer.set(k, null);
            }
          }
        }
      }

      for (int j = 0; j < edgeBuffer.size(); j++) {
        Edge edge = edgeBuffer.get(j);
        if (edge == null) {
          continue;
        }

        Triangle tri = new Triangle(edge.p1, edge.p2, point);
        triangleBuffer.add(tri);
      }
    }

    for (int i = triangleBuffer.size() - 1; i >= 0; i--) {
      if (triangleBuffer.get(i).SharesVertex(superTriangle)) {
        triangleBuffer.remove(i);
      }
    }

    triangles = triangleBuffer;

    return triangleBuffer;
  }

  public DelaunayTriangulator() {
    triangles = new ArrayList<Triangle>();
  }
}

class Triangle {
  PVector[] points;

  public PVector GetCircumcenter(PVector a, PVector b, PVector c) {
    PVector midAB = Midpoint(a, b);
    PVector midBC = Midpoint(b, c);
    float slopeAB = -1 / Slope(a, b);
    float slopeBC = -1 / Slope(b, c);
    float bAB = midAB.y - slopeAB * midAB.x;
    float bBC = midBC.y - slopeBC * midBC.x;
    float x = (bAB - bBC) / (slopeBC - slopeAB);
    PVector circumcenter = new PVector(
      x,
      (slopeAB * x) + bAB
      );

    return circumcenter;
  }

  public PVector GetCircumcenter() {
    return GetCircumcenter(points[0], points[1], points[2]);
  }

  public boolean CircumcircleContains(PVector p) {
    PVector center = GetCircumcenter();
    float rad = center.dist(points[0]);
    return center.dist(p) <= rad;
  }

  public ArrayList<PVector> GetContainedPoints(PVector[] points) {
    ArrayList<PVector> contained = new ArrayList<PVector>();
    for (int i = 0; i < points.length; i++) {
      if (CircumcircleContains(points[i])) {
        contained.add(points[i]);
      }
    }

    return contained;
  }

  public PVector Midpoint(PVector a, PVector b) {
    return new PVector(
      (a.x + b.x) / 2,
      (a.y + b.y) / 2
      );
  }

  public float Slope(PVector from, PVector to) {
    return (to.y - from.y) / (to.x - from.x);
  }

  public boolean IsInCircle(PVector point, PVector center, float radius) {
    return point.dist(center) < radius;
  }

  public boolean SharesVertex(Triangle other) {
    for (int i = 0; i < points.length; i++) {
      for (int j = 0; j < other.points.length; j++) {
        if (points[i] == other.points[j]) {
          return true;
        }
      }
    }
    return false;
  }

  public Triangle() {
    points = new PVector[3];
  }

  public Triangle(PVector[] pts) {
    points = pts;
  }

  public Triangle(PVector a, PVector b, PVector c) {
    points = new PVector[3];
    points[0] = a;
    points[1] = b;
    points[2] = c;
  }
}

class Edge {
  public PVector p1;
  public PVector p2;

  public boolean IsEqual(Edge other) {
    if (other == null) {
      return false;
    } else {
      return (p1 == other.p1 && p2 == other.p2) || (p2 == other.p1 && p1 == other.p2);
    }
  }

  public Edge(PVector a, PVector b) {
    p1 = a;
    p2 = b;
  }
}
