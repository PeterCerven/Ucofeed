package sk.ucofeed.backend.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import sk.ucofeed.backend.persistence.model.DashboardMessage;
import sk.ucofeed.backend.persistence.repository.DashboardRepository;

@Service
public class DashboardNotifierImpl implements DashboardNotifier {

    private static final Logger LOG = LoggerFactory.getLogger(DashboardNotifierImpl.class);

    private final DashboardRepository dashboardRepository;

    public DashboardNotifierImpl(DashboardRepository dashboardRepository) {
        this.dashboardRepository = dashboardRepository;
    }

    @Override
    @Transactional
    public void notify(String message) {
        if(message == null || message.isBlank()) {
            return;
        }

        LOG.info("New dashboard event generated with message: {}", message);
        dashboardRepository.save(new DashboardMessage(message));
    }
}
