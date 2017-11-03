$(function() {
  var elements = stripe.elements();
  var card = elements.create('card');
  var form = document.getElementById('payment-form');
  card.mount('#card-element');

  function stripeTokenHandler(token) {
    var form = document.getElementById('payment-form');
    var hiddenInput = document.getElementById('stripe_token');

    hiddenInput.setAttribute('value', token.id);
    form.submit();
  }

  card.addEventListener('change', function(event) {
    var displayError = document.getElementById('card-errors');
    if (event.error) {
      displayError.textContent = event.error.message;
    } else {
      displayError.textContent = '';
    }
  });

  form.addEventListener('submit', function(event) {
    event.preventDefault();

    stripe.createToken(card).then(function(result) {
      if (result.error) {
        var errorElement = document.getElementById('card-errors');
        errorElement.textContent = result.error.message;
      } else {
        stripeTokenHandler(result.token);
      }
    });
  });
});
