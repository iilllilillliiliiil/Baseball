package project.model;

import java.time.LocalDate;
import java.time.LocalTime;

public class GameDto {
    private LocalDate date;
    private LocalTime time;
    private String opponent;
    private String stadium;

    public GameDto(LocalDate date, LocalTime time, String opponent, String stadium) {
        this.date = date;
        this.time = time;
        this.opponent = opponent;
        this.stadium = stadium;
    }

    // Getter/Setter
    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public LocalTime getTime() { return time; }
    public void setTime(LocalTime time) { this.time = time; }

    public String getOpponent() { return opponent; }
    public void setOpponent(String opponent) { this.opponent = opponent; }

    public String getStadium() { return stadium; }
    public void setStadium(String stadium) { this.stadium = stadium; }
}
