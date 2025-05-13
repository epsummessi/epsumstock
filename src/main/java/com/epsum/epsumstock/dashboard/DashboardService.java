package com.epsum.epsumstock.dashboard;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.epsum.epsumstock.user.User;

@Service
public class DashboardService {

    private final DashboardRepository dashboardRepository;

    public DashboardService(DashboardRepository dashboardRepository) {
        this.dashboardRepository = dashboardRepository;
    }

    @Transactional(readOnly = true)
    public Dashboard retrieveDashboard(User user) {
        return dashboardRepository.findById(user.getId()).orElseThrow();
    }

}
