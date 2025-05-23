package com.epsum.epsumstock.customer;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import com.epsum.epsumstock.user.User;

import java.util.List;
import java.util.Optional;

public interface CustomerRepository extends JpaRepository<Customer, Long> {

    boolean existsByIdAndOwner(long id, User owner);

    boolean existsByNameAndOwner(String name, User owner);

    Optional<Customer> findByIdAndOwner(long id, User owner);

    Optional<Customer> findByNameAndOwner(String name, User owner);

    Page<Customer> findAllByOwner(User owner, Pageable pageable);

    List<Customer> findAllByOwner(User owner, Sort sort);

    List<Customer> findAllByNameContainingIgnoreCaseAndOwner(String name, User owner);

}
