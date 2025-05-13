package com.epsum.epsumstock;

import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.security.core.userdetails.UserDetailsService;

import com.epsum.epsumstock.user.User;

@TestConfiguration
public class MockUserDetailsService {

    @Bean
    public UserDetailsService mockUserDetailsService() {
        return email -> new User("user", "user@email.com", "password");
    }

}
