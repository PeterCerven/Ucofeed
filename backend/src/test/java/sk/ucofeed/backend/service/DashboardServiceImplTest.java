package sk.ucofeed.backend.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import sk.ucofeed.backend.persistence.dto.DashboardMessageDTO;
import sk.ucofeed.backend.persistence.model.*;
import sk.ucofeed.backend.persistence.repository.DashboardRepository;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class DashboardServiceImplTest {

    @Mock
    private DashboardRepository dashboardRepository;

    @InjectMocks
    private DashboardServiceImpl dashboardService;

    private DashboardMessage testMessage1;
    private DashboardMessage testMessage2;

    @BeforeEach
    void setUp() {
        testMessage1 = new DashboardMessage("New review created for Test Program");
        testMessage2 = new DashboardMessage("Another notification message");
    }

    @Test
    void getAllDashboardMessages_ShouldReturnListOfMessages() {
        List<DashboardMessage> messages = Arrays.asList(testMessage1, testMessage2);
        when(dashboardRepository.findAll()).thenReturn(messages);

        List<DashboardMessageDTO> result = dashboardService.getAllDashboardMessages();

        assertNotNull(result);
        assertEquals(2, result.size());
        verify(dashboardRepository, times(1)).findAll();
    }

    @Test
    void getAllDashboardMessages_WhenNoMessages_ShouldReturnEmptyList() {
        when(dashboardRepository.findAll()).thenReturn(List.of());

        List<DashboardMessageDTO> result = dashboardService.getAllDashboardMessages();

        assertNotNull(result);
        assertTrue(result.isEmpty());
        verify(dashboardRepository, times(1)).findAll();
    }

    @Test
    void deleteDashboardMessage_WhenMessageExists_ShouldDeleteMessage() {
        Long messageId = 1L;
        when(dashboardRepository.existsById(messageId)).thenReturn(true);
        doNothing().when(dashboardRepository).deleteById(messageId);

        dashboardService.deleteDashboardMessage(messageId);

        verify(dashboardRepository, times(1)).existsById(messageId);
        verify(dashboardRepository, times(1)).deleteById(messageId);
    }

    @Test
    void deleteDashboardMessage_WhenMessageDoesNotExist_ShouldNotDelete() {
        Long messageId = 999L;
        when(dashboardRepository.existsById(messageId)).thenReturn(false);

        dashboardService.deleteDashboardMessage(messageId);

        verify(dashboardRepository, times(1)).existsById(messageId);
        verify(dashboardRepository, never()).deleteById(messageId);
    }
}