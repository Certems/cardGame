board gameBoard;
ArrayList<player> players = new ArrayList<player>();
int randomNumber;

void setup(){
    fullScreen();
    gameBoard = new board(0);
}
void draw(){
    gameBoard.displayBoard();
}
void keyPressed(){
    if(key == '1'){
        addPlayers(1);
        println("Player Added");
    }
    if(key == '2'){
        randomNumber = floor(random(0,floor(players.size())));
        players.get(randomNumber).drawRandomCard();
        println("Null Card Added");
    }
    if(key == '3'){
        randomNumber = floor(random(0,floor(players.size())));
        players.get(randomNumber).playSelectCard( players.get(randomNumber).hand.get(0) );
    }
    if(key == '4'){
        gameBoard.clearBoard();
    }

}

/*
Cards are stored as PVectors, with the X value as the VALUE of the card, and the Y value as the SUIT of the card

Suits
------
1 - Spades
2 - Clubs
3 - Hearts
4 - Diamonds

Values
-------
1  - Ace
2  - 2
  ...
10 - 10
11 - J
12 - Q
13 - K

Game Types
-----------
0 - Scat
1 - Poker
2 - Durak
*/

void addPlayers(int numberOfPlayers){
    for(int i=0; i<numberOfPlayers; i++){
        player newPlayer = new player(i);
        players.add(newPlayer);
    }
}

class player{
    ArrayList<PVector> hand = new ArrayList<PVector>();

    boolean handRevealed = false;
    boolean cardExists = false;

    int playerNumber;
    int randNum;

    float score = 0;

    player(int PlayerNumber){
        playerNumber = PlayerNumber;
    }

    boolean cardInHand(PVector card){
        cardExists = false;
        for(int i=0; i<hand.size(); i++){
            if( (hand.get(i).x == card.x) && (hand.get(i).y == card.y) ){
                cardExists = true;
            }
        }
        return cardExists;
    }
    void drawRandomCard(){
        //Draws a random card from the deck
        if(gameBoard.deck.size() > 0){
            randNum = floor( random(0,gameBoard.deck.size()) );
            hand.add( gameBoard.deck.get(randNum) );
            gameBoard.deck.remove( randNum );
        }
        else{
            println("--No more cards in deck--");
        }
    }
    void discardRandomCard(){
        //Discards a random card from player hand
    }
    void drawSelectCard(PVector card){
        //Draws a given card from the deck
        cardExists = gameBoard.cardInDeck(card);
        if(cardExists)
        {
            for(int i=0; i<gameBoard.deck.size(); i++){
                if( (gameBoard.deck.get(i).x == card.x) && (gameBoard.deck.get(i).y == card.y) ){
                    gameBoard.deck.remove(i);
                    hand.add(card);
                    break;
                }
            }
        }
        else{
            println("--Card not in deck--");
        }
    }
    void discardSelectCard(PVector card){
        //Discards a given card from player hand
        cardExists = cardInHand(card);
        if(cardExists)
        {
            for(int i=0; i<hand.size(); i++){
                if( (hand.get(i).x == card.x) && (hand.get(i).y == card.y) ){
                    hand.remove(i);
                    gameBoard.discard.add(card);
                    break;
                }
            }
        }
        else{
            println("--Card not in hand--");
        }
    }
    void removeSelectCard(PVector card){
        for(int i=0; i<hand.size(); i++){
            if( (hand.get(i).x == card.x) && (hand.get(i).y == card.y) ){
                hand.remove(i);
                break;
            }
        }
    }
    void playSelectCard(PVector card){
        cardExists = cardInHand(card);
        if(cardExists)
        {
            gameBoard.inPlay.add(card);
            gameBoard.inPlayer.add(playerNumber);
            removeSelectCard(card);
        }
        else{
            println("--Card not in hand--");
        }
    }
}

class board{
    ArrayList<PVector> inPlay   = new ArrayList<PVector>();
    ArrayList<Integer> inPlayer = new ArrayList<Integer>();
    ArrayList<PVector> discard  = new ArrayList<PVector>();
    ArrayList<PVector> deck     = new ArrayList<PVector>();

    PVector leaderboardPos = new PVector(50,50);

    boolean cardExists = false;

    int gType;

    float boardDispRad  = 2.0*height/5.0;
    float tSize         = 20;

    board(int gameType){
        gType = gameType;
        setupBoard(gType);
    }

    void displayBoard(){
        pushStyle();
        //Background
        background(80,80,80);

        //Show hands
        fill(255,255,255);
        textSize(tSize);
        textAlign(CENTER);
        for(int i=0; i<players.size(); i++){
            text("Player "+(i+1), width/2.0+ (boardDispRad)*(cos(2.0*PI*i / players.size())), height/2.0- 2.0*tSize+(boardDispRad)*(sin(2.0*PI*i / players.size())) );
            for(int j=0; j<players.get(i).hand.size(); j++)
            {
                text(int(players.get(i).hand.get(j).x) +", ", j*(3.0*tSize/2.0)+ width/2.0+ (boardDispRad)*(cos(2.0*PI*i / players.size())), height/2.0+       (boardDispRad)*(sin(2.0*PI*i / players.size())) );
                text(int(players.get(i).hand.get(j).y) +"  ", j*(3.0*tSize/2.0)+ width/2.0+ (boardDispRad)*(cos(2.0*PI*i / players.size())), height/2.0+ tSize+(boardDispRad)*(sin(2.0*PI*i / players.size())) );
            }
        }

        //Show board
        for(int i=0; i<inPlay.size(); i++){
            text(int(inPlay.get(i).x), i*(3.0*tSize/2.0) +width/2.0,        height/2.0);
            text(int(inPlay.get(i).y), i*(3.0*tSize/2.0) +width/2.0, tSize+ height/2.0);
        }

        //Show deck
        rectMode(CENTER);
        fill(140,140,140);
        rect( -(3.0*tSize) +width/2.0, height/2.0, (3.0*tSize/2.0), (5.0*tSize/2.0) );

        fill(255,255,255);
        text(deck.size(), -(3.0*tSize) +width/2.0, height/2.0);

        //Show discard
        rectMode(CENTER);
        fill(100,100,100);
        rect( -(3.0*tSize) +width/2.0, 3.0*tSize+ height/2.0, (3.0*tSize/2.0), (5.0*tSize/2.0) );

        fill(255,255,255);
        text(discard.size(), -(3.0*tSize) +width/2.0, 3.0*tSize+ height/2.0);

        //Show leaderboard
        fill(140,140,240, 150);
        rectMode(CORNER);
        rect(leaderboardPos.x -tSize/2.0, leaderboardPos.y -3.0*tSize/2.0, 200, tSize*(2 + players.size()));

        fill(255,255,255);
        textAlign(LEFT);
        text("-Leaderboards-", leaderboardPos.x, leaderboardPos.y);
        for(int i=0; i<players.size(); i++){
            text("Player " + (i+1) +" -> " + floor(players.get(i).score), leaderboardPos.x, leaderboardPos.y +(i+1)*tSize);
        }
        

        popStyle();
    }
    void setupBoard(int GameType){
        deck.clear();
        if(GameType == 0)
        {
            for(int i=1; i<=4; i++){
                for(int j=1; j<=13; j++){
                    deck.add( new PVector(j,i) );
                }
            }
        }
        if(GameType == 1)
        {
            for(int i=1; i<=4; i++){
                for(int j=1; j<=13; j++){
                    deck.add( new PVector(j,i) );
                }
            }
        }
        if(GameType == 2)
        {
            for(int i=1; i<=4; i++){
                for(int j=6; j<=13; j++){
                    deck.add( new PVector(j,i) );
                }
            }
        }
    }
    boolean cardInDeck(PVector card){
        cardExists = false;
        for(int i=0; i<deck.size(); i++){
            if( (deck.get(i).x == card.x) && (deck.get(i).y == card.y) ){
                cardExists = true;
            }
        }
        return cardExists;
    }
    void calculateRoundScorings(){
        if(gType == 0){
            //pass
        }
        if(gType == 1){
            //pass
        }
        if(gType == 2){
            //pass
        }
        clearBoard();
    }
    void clearBoard(){
        for(int i=0; i<inPlay.size(); i++){
            discard.add( inPlay.get(i) );
        }
        inPlay.clear();
        inPlayer.clear();
    }

}