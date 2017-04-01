 //<>//
Score score = new Score();
Life life = new Life();
Time timeLeft =new Time();
int status=1;// A variable to detect the the game status(0==end 1==continue)
ArrayList<movingObject> characters = new ArrayList<movingObject>();
ArrayList<Rings> rings = new ArrayList<Rings>();

int ox, oy;  //To store the center fo the window
void setup() {
  size(800, 800);

  imageMode(CENTER);
  score.initialize();
  life.initialize();
  timeLeft.initialize();

  ox = width/2;
  oy = height/2;



  fill(0, 255, 0);

  //adding objects to the arrays
  characters.add(new movingObject(ox, oy, 100, 25, 75, 1));

  characters.add(new movingObject(ox, oy, 500, 25, 125, 2));

  characters.add(new movingObject(ox, oy, 700, 25, 175, 3));

  characters.add(new movingObject(ox, oy, 900, 25, 225, 5));

  characters.add(new movingObject(ox, oy, 1200, 25, 275, 6));

  //creating rings
  int radius=600;
  for (int i=0; i<6; i++)
  {
    rings.add(new Rings(ox, oy, radius, i%2));
    radius=radius-100;//after creating the bigger ellipse decrease the radius by 100
  }
  ellipseMode(CENTER);
}

void draw() {
  background(255);

  score.showScore();// this will show the updated score
  life.showLife();//Show the lifes remaining
  timeLeft.showTime();//show the time remaining
  if (status==1)//continue till the status is 1
  {
    for (Rings a : rings) {
      a.draw();
    }
    noFill();
    for (movingObject b : characters) {
      b.draw();
      // println("x=",b.x," y=",b.y);
    }
  }
}

void mousePressed() {
  checkEvryting();
}

//This function will check the mouse press location and the object location and if 
//it the mouse is inside the function it will update the values accordingly
void checkEvryting()
{
  int x=mouseX;
  int y=mouseY;
  // println(x, " ", y);

  //iterate through all the objects
  for (movingObject b : characters) {
    // println("x=", (int)b.x, " y=", (int)b.y);
    float dist=dist(x, y, (int)b.x, (int)b.y);
    // println("Distance =", dist);
    //Means mouse pressed inside the object
    if (dist<b.diameter)
    {
      // println("\t\t\tPressed Inside "+b.type);
      if (b.type==1)
      {
        score.score+=10;
      } else if (b.type==2)
      {
        score.score+=2;
        life.lives+=1;
      } else if (b.type==3) {
        score.score+=5;
      } else if (b.type==4)
      {
        life.lives-=1;
        if (life.lives<0)
        {
          status=0;
        }
      } else if (b.type==5)
      {
        life.lives=0;
      } else if (b.type==6)
      {
        timeLeft.time+=2;
      }
      for (movingObject c : characters) {
        c.update();
      }
    }
  }
}
//A class to store the onformation about the characters moving
class movingObject {
  float ox, oy, x, y, diameter, a, start;
  int direction, type;  //there will be 6 types of characters  
  PImage img;

  movingObject(float originX, float originY, float startLocation, float obDiameter, float radius, int t) {
    ox = originX;
    oy = originY;
    x = 0;
    y = 0;
    diameter = obDiameter;
    a = radius;
    start=startLocation;
    direction=1;
    type=t;
    img = loadImage(str(type)+".png");
  }

  //whenever the mouse is clicked inside the character the objects are updated
  void update() {
    float temp = random(1500);//a variable to randomly store the start position
    start=temp;
    int dir=(int)random(2);//chose the direction of movement randomly
    if (dir==1)
      direction=1;
    else
      direction=-1;

    int typ=(int)random(6)+1;// random nuumber from 1-6
    type=typ;
    img = loadImage(str(type)+".png"); // load the respective image respectively
  }

  void draw() {
    // defines the color of the ellipses, now:red;
    fill(0);
    float t = millis()/1000.0f; // will have the time from the start in seconds
    t=t+start;
    t=t*direction;
    x = ox+a*cos(t);
    y = oy+a*sin(t);
    image(img, x, y, diameter, diameter);

    //   ellipse(x, y, diameter, diameter);
  }
}


//A class use to store the information of the concentric circless
class Rings {
  int xCor;
  int yCor;
  int diameter;
  int c;
  Rings(int xCord, int yCord, int diam, int clr)
  {
    xCor=xCord;
    yCor=yCord;
    diameter=diam;
    c=clr;
  }
  // to draw the ellipse(After that it appears as concentric)
  void draw() {
    if (c==0)
      fill(0, 255, 0);
    else
      fill(255);
    ellipse(xCor, yCor, diameter, diameter);
  }
}

//it holds the score value
class Score {
  PFont font;
  int score;
  int fontSize;
  float x;
  float y;

  Score() {
    score = 0;
    fontSize = 24;
    x = width;
    y = 40;
  }

  void showScore() {
    textFont(font, fontSize);
    fill(0);
    text("Score: " + score, x, y);
  }

  void initialize() {
    font = createFont("Arial Bold", fontSize, true);
  }
}

//A class which cintains information about the lifes
class Life {
  PFont font;
  int lives;
  int fontSize;
  float x;
  float y;

  Life() {
    lives = 0;
    fontSize = 24;
    x = width + 250;
    y = 40;
  }

  void showLife() {
    textFont(font, fontSize);
    fill(0);
    text("Life: " + lives, x, y);
  }

  void initialize() {
    font = createFont("Arial Bold", fontSize, true);
  }
}

//A timer which has the time information of the game
class Time {
  PFont font;
  int time;
  int timeLimit;
  int fontSize;
  float x;
  float y;

  Time() {
    time = 0;
    timeLimit=20;
    fontSize = 24;
    x = width + 450;
    y = 40;
  }

  void showTime() {
    time =timeLimit- millis()/1000;
    if (time>0)
    {
      textFont(font, fontSize);
      fill(0);
      text("Time: " + time, x, y);
    } else
    {
      textFont(font, fontSize);
      fill(0);
      text("GAME OVER", x, y);
      status=0;
    }
  }

  void initialize() {
    font = createFont("Arial Bold", fontSize, true);
  }
}