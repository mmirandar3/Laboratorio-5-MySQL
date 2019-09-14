import de.bezier.data.sql.mapper.*;
import de.bezier.data.sql.*;


import de.bezier.data.sql.*;
MySQL msql;

Circle Circulo;
Text Text;

int juego = 1;

void setup() {
  size(500,500);
  background(0);
  String user     = "root";
  String pass     = "sql123//*root$&&";
  String dbHost   = "localhost";
  String database = "circulo";
  msql = new MySQL( this, dbHost, database, user, pass );
  Circulo = new Circle(0,0,255,250,250,60,0);
  Text = new Text(255,255,255,20,50,32);
}

void draw() {
  
  Circulo.displayCircle();
  Text.puntaje();
  if (juego == 1) {
    Circulo.movimiento();
    Circulo.barrera();
    Circulo.comprobacion();
  }
}

class Circle {
  int red;
  int green;
  int blue;
  float xPos;
  float yPos;
  float size;
  int score;
  
  Circle(int tred,int tgreen,int tblue,float txPos,float tyPos,float tsize,int tscore) {
    red = tred;
    green = tgreen;
    blue = tblue;
    xPos = txPos;
    yPos = tyPos;
    size = tsize;
    score = tscore;
    
  }
  
  void displayCircle() {
    ellipseMode (CENTER);
    background(0);
    fill(red,green,blue);
    ellipse(xPos, yPos, size, size);
  }
  
  void movimiento() {
    xPos += random(-10,10);
    yPos += random(-10,10);
  }
  
  void barrera() {
    if (xPos > 500 || xPos < 0 || yPos > 500 || yPos < 0) {
      xPos = 250;
      yPos = 250;
      juego = 0;
      if ( msql.connect() )
      {      
      msql.execute( "INSERT INTO puntaje (puntos) VALUES ("+Circulo.score+");" );
      }
      else
      {
        println( "FAIL" );
      }
    } 
  }
  
  void comprobacion() {
    if (dist(xPos,yPos,mouseX,mouseY) < size/2) {
      blue = 0;
      red = 255;
      
      score += 1.2;
    }
    else {
      blue = 255;
      red = 0;
      
      score -= 0.2;
    }
  }
}

class Text {
  int red;
  int green;
  int blue;
  float xPos;
  float yPos;
  int size;
  
  Text(int tred,int tgreen,int tblue,float txPos,float tyPos,int tsize) {
    red = tred;
    green = tgreen;
    blue = tblue;
    xPos = txPos;
    yPos = tyPos;
    size = tsize;
  }
  
  void puntaje() {
    textSize(size);
    text("Puntaje:"+round(Circulo.score),xPos,yPos);
    fill (red,green,blue);
}
}
