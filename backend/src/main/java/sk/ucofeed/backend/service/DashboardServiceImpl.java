package sk.ucofeed.backend.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import sk.ucofeed.backend.persistence.dto.DashboardMessageDTO;
import sk.ucofeed.backend.persistence.repository.DashboardRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class DashboardServiceImpl implements DashboardService {

    private static final Logger LOG = LoggerFactory.getLogger(DashboardServiceImpl.class);

    private final DashboardRepository dashboardRepository;

    public DashboardServiceImpl(DashboardRepository dashboardRepository) {
        this.dashboardRepository = dashboardRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<DashboardMessageDTO> getAllDashboardMessages() {
        return dashboardRepository.findAll()
                .stream()
                .map(DashboardMessageDTO::from)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void deleteDashboardMessage(Long messageId) {
        if(!dashboardRepository.existsById(messageId)) {
            LOG.warn("Dashboard message with id {} not found", messageId);
            return;
        }

        dashboardRepository.deleteById(messageId);
    }
}
