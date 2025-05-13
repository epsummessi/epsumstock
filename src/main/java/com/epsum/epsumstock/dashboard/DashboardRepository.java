package com.epsum.epsumstock.dashboard;

import org.springframework.data.repository.Repository;

import java.util.Optional;

public interface DashboardRepository extends Repository<Dashboard, Long> {

    Optional<Dashboard> findById(long id);

}
