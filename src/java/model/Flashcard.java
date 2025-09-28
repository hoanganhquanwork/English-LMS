package model;

public class Flashcard {
    private int cardId;
    private int setId;
    private String frontText;
    private String backText;

    public Flashcard() {
    }

    public Flashcard(int cardId, int setId, String frontText, String backText) {
        this.cardId = cardId;
        this.setId = setId;
        this.frontText = frontText;
        this.backText = backText;
    }

    public int getCardId() {
        return cardId;
    }

    public void setCardId(int cardId) {
        this.cardId = cardId;
    }

    public int getSetId() {
        return setId;
    }

    public void setSetId(int setId) {
        this.setId = setId;
    }

    public String getFrontText() {
        return frontText;
    }

    public void setFrontText(String frontText) {
        this.frontText = frontText;
    }

    public String getBackText() {
        return backText;
    }

    public void setBackText(String backText) {
        this.backText = backText;
    }

    
}
