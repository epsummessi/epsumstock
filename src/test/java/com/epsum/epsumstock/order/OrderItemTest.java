package com.epsum.epsumstock.order;

import org.junit.jupiter.api.Test;

import com.epsum.epsumstock.order.OrderItem;
import com.epsum.epsumstock.product.Product;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.assertThat;

class OrderItemTest {

    @Test
    void getAmount() {
        // given
        var item = new OrderItem(2, new Product(null, null, null, "20"));
        // when
        var amount = item.getAmount();
        // then
        assertThat(amount).isEqualTo(new BigDecimal("40"));
    }

}
