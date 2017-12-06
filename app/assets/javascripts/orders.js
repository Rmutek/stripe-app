document.addEventListener("DOMContentLoaded", function(event) { 
  if (document.getElementById('order')) {
    var order = new Vue({
      el: '#order',
      data: {
        order: {},
        user: {},
        shipping: {},
        newShippingMethod: ''
      },
      mounted: function() {
        var that;
        that = this;
        $.get({
          url: '/api/orders/new',
          success: function(response) {
            that.order = response.order;
            that.user = response.user;
            that.shipping = that.order.shipping_methods.filter(function(method){
              return method.id === that.order.selected_shipping_method;
            })[0];
            that.newShippingMethod = that.shipping.id;
            $('#order').fadeIn();
            $('.stripe-btn').fadeIn();
            console.log(response);
          },
          error: function(error){
            alert(error.responseJSON.error);
            window.location = "/carted_products";
          }
        });
      },
      methods: {
        updateShippingMethod: function() {
          var that;
          that = this;
          $.ajax({
            type: "PATCH",
            url: '/api/orders/' + that.order.id,
            data: {selected_shipping_method: that.newShippingMethod},
            success: function(response) {
              that.order = response.order;
              that.shipping = that.order.shipping_methods.filter(function(method){
                return method.id === that.order.selected_shipping_method;
              })[0];
              console.log(response);
            },
            error: function(error){
              alert(error.responseJSON.error);
            }
          });
        }
      },
      computed: {
      },
    });
  }
});
