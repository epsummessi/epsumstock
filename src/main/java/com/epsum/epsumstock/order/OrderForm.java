package com.epsum.epsumstock.order;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import org.hibernate.validator.constraints.UniqueElements;

import com.epsum.epsumstock.customer.Customer;

import java.util.List;

public class OrderForm {

    @NotNull
    private OrderStatus status;

    @NotNull
    private Long customerId;

    @Valid
    @UniqueElements
    @NotEmpty
    private List<OrderItemForm> items;

    public OrderForm() {}

    public OrderForm(OrderStatus status, Long customerId, List<OrderItemForm> items) {
        this.status = status;
        this.customerId = customerId;
        this.items = items;
    }

    public OrderStatus getStatus() {
        return status;
    }

    public void setStatus(OrderStatus status) {
        this.status = status;
    }

    public Long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Long customerId) {
        this.customerId = customerId;
    }

    public List<OrderItemForm> getItems() {
        return items;
    }

    public void setItems(List<OrderItemForm> items) {
        this.items = items;
    }

    public Order toEntity() {
        return new Order(
                status,
                new Customer(customerId),
                items.stream().map(OrderItemForm::toEntity).toList()
        );
    }

}
