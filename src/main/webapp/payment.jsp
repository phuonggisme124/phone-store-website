<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Payment</title>
  <link rel="stylesheet" href="css/payment.css">
</head>
<body>
  <div class="payment-container">
    <h2 class="payment-title">Payment ?</h2>

    <!-- User Information -->
    <div class="user-info">
      <label>Full Name</label>
      <input type="text" id="name" placeholder="Enter your full name">

      <label>Phone Number</label>
      <input type="text" id="phone" placeholder="Enter your phone number">

      <label>Shipping Address</label>
      <textarea id="address" placeholder="Enter your shipping address"></textarea>
    </div>

    <!-- Payment Methods -->
    <div class="payment-methods">
      <h3>Payment Method</h3>
      <label><input type="radio" name="payment" value="Momo"> Momo</label>
      <label><input type="radio" name="payment" value="Bank Card"> Bank Card</label>
      <label><input type="radio" name="payment" value="COD"> COD (Cash on Delivery)</label>
    </div>

    <!-- Installment Option -->
    <div class="installment">
      <label>
        <input type="checkbox" id="installment-check"> Installment Plan (0% interest)
      </label>
    </div>

    <!-- Installment Policy -->
    <div id="installment-policy" class="installment-policy hidden">
      <h4>Installment Policy</h4>
      <ul>
        <li>Applicable for orders from 10,000,000 VND and above.</li>
        <li>0% interest installment via credit cards from partner banks.</li>
        <li>Flexible terms: 3, 6, or 12 months.</li>
        <li>Not applicable with other promotions or discounts.</li>
      </ul>

      <!-- Installment Duration Selection -->
      <div class="installment-duration">
        <p class="installment-label">Choose installment period:</p>
        <label><input type="radio" name="duration" value="3 months"> 3 months</label>
        <label><input type="radio" name="duration" value="6 months"> 6 months</label>
        <label><input type="radio" name="duration" value="12 months"> 12 months</label>
      </div>
    </div>

    <!-- Confirm Button -->
    <button id="confirm-btn">Confirm Payment</button>
  </div>

  <script src="js/payment.js"></script>
</body>
</html>
