package sk.ucofeed.backend.service;

import sk.ucofeed.backend.persistence.dto.DashboardMessageDTO;

import java.util.List;

public interface DashboardService {
    List<DashboardMessageDTO> getAllDashboardMessages();
    
    void deleteDashboardMessage(Long messageId);
}
