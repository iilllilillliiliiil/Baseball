package project.repo;

import project.model.GameDto;
import java.util.List;
import java.util.ArrayList;
import java.time.LocalDate;
import java.time.LocalTime;

public class SLModel {

    // 메모리에 경기 정보를 저장하는 리스트 (공유)
    private static List<GameDto> games = new ArrayList<>();

    static {
        // 초기값 등록
        games.add(new GameDto(LocalDate.of(2025, 8, 22), LocalTime.of(18, 30), "키움 히어로즈", "대구 삼성 라이온즈 파크"));
        games.add(new GameDto(LocalDate.of(2025, 8, 23), LocalTime.of(18, 0),  "키움 히어로즈", "대구 삼성 라이온즈 파크"));
        games.add(new GameDto(LocalDate.of(2025, 8, 24), LocalTime.of(18, 0),  "키움 히어로즈", "대구 삼성 라이온즈 파크"));
        // ... 나머지도 초기값 추가
    }

    // 전체 경기 일정 가져오기
    public List<GameDto> getRemainingHomeGames() {
        return new ArrayList<>(games); // 복사본 반환
    }

    // 경기 추가
    public void addGame(GameDto game) {
        games.add(game);
    }

    // 경기 삭제 (index 기준)
    public void removeGame(int index) {
        if (index >= 0 && index < games.size()) {
            games.remove(index);
        }
    }

    // 경기 수정
    public void updateGame(int index, GameDto game) {
        if (index >= 0 && index < games.size()) {
            games.set(index, game);
        }
    }

    // 전체 일정 초기화 후 재등록
    public void resetGames(List<GameDto> newGames) {
        games.clear();
        games.addAll(newGames);
    }
}
