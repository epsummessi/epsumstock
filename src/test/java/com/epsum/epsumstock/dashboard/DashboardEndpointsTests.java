package com.epsum.epsumstock.dashboard;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.security.test.context.support.TestExecutionEvent;
import org.springframework.security.test.context.support.WithUserDetails;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import com.epsum.epsumstock.TestApplication;
import com.epsum.epsumstock.category.Category;
import com.epsum.epsumstock.category.CategoryRepository;
import com.epsum.epsumstock.customer.Customer;
import com.epsum.epsumstock.customer.CustomerRepository;
import com.epsum.epsumstock.order.OrderBuilder;
import com.epsum.epsumstock.order.OrderRepository;
import com.epsum.epsumstock.order.OrderStatus;
import com.epsum.epsumstock.product.Product;
import com.epsum.epsumstock.product.ProductRepository;
import com.epsum.epsumstock.user.User;
import com.epsum.epsumstock.user.UserRepository;

import java.math.BigDecimal;
import java.util.List;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@Import(TestApplication.class)
@ActiveProfiles("test")
@AutoConfigureMockMvc
@WithUserDetails(value = "user@email.com", setupBefore = TestExecutionEvent.TEST_EXECUTION)
class DashboardEndpointsTests {

    @Autowired
    private MockMvc client;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private UserRepository userRepository;

    @BeforeEach
    void setup() {
        var user = userRepository.save(new User("user", "user@email.com", "$2a$10$gYCEDfFbidA3IInCfzcXdugclrYR/6FbQuogN7Ixc3ohWi90MEXiO"));
        var customerA = customerRepository.save(new Customer("A", "A", "A", user));
        var customerB = customerRepository.save(new Customer("B", "B", "B", user));
        var productA = productRepository.save(new Product("A", categoryRepository.save(new Category("A", user)), 10, "1.00", user));
        var productB = productRepository.save(new Product("B", categoryRepository.save(new Category("B", user)), 20, "2.00", user));
        var productC = productRepository.save(new Product("C", categoryRepository.save(new Category("C", user)), 30, "3.00", user));
        orderRepository.saveAll(List.of(
                new OrderBuilder()
                        .status(OrderStatus.UNPAID)
                        .customer(customerA)
                        .item(5, productA)
                        .item(10, productB)
                        .owner(user)
                        .build(),
                new OrderBuilder()
                        .status(OrderStatus.PAID)
                        .customer(customerB)
                        .item(3, productA)
                        .item(8, productB)
                        .owner(user)
                        .build(),
                new OrderBuilder()
                        .status(OrderStatus.PAID)
                        .customer(customerB)
                        .item(2, productA)
                        .item(5, productC)
                        .owner(user)
                        .build()
        ));
    }

    @AfterEach
    void tearDown() {
        orderRepository.deleteAll();
        productRepository.deleteAll();
        categoryRepository.deleteAll();
        customerRepository.deleteAll();
        userRepository.deleteAll();
    }

    @Test
    void retrieveDashboard() throws Exception {
        // when
        var result = client.perform(get("/dashboard"));
        // then
        result.andExpectAll(
                status().isOk(),
                model().attribute("dashboard", is(allOf(
                        hasProperty("totalCustomers", is(2L)),
                        hasProperty("totalCategories", is(3L)),
                        hasProperty("totalProducts", is(3L)),
                        hasProperty("totalUnpaidOrders", is(1L)),
                        hasProperty("totalPaidOrders", is(2L)),
                        hasProperty("totalSales", is(new BigDecimal("36.00")))
                ))),
                view().name("dashboard/dashboard")
        );
    }

}
