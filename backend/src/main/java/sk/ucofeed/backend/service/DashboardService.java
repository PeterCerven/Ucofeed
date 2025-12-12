package sk.ucofeed.backend.service;

import sk.ucofeed.backend.persistence.dto.DashboardMessageDataDTO;

import java.util.List;

public interface DashboardService {
    List<DashboardMessageDataDTO> getAllDashboardMessages();
    
    void deleteDashboardMessage(Long messageId);
}
