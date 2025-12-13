/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

document.addEventListener("DOMContentLoaded", () => {
  const installmentCheck = document.getElementById("installment-check");
  const policyBox = document.getElementById("installment-policy");
  const confirmBtn = document.getElementById("confirm-btn");

  // Khi tick vào ô trả góp
  installmentCheck.addEventListener("change", () => {
    if (installmentCheck.checked) {
      policyBox.classList.remove("hidden");
    } else {
      policyBox.classList.add("hidden");
    }
  });

  // Khi nhấn xác nhận thanh toán
  confirmBtn.addEventListener("click", () => {
    const name = document.getElementById("name").value.trim();
    const phone = document.getElementById("phone").value.trim();
    const address = document.getElementById("address").value.trim();
    const payment = document.querySelector("input[name='payment']:checked");

    if (!name || !phone || !address || !payment) {
      alert("⚠️ Vui lòng điền đầy đủ thông tin và chọn phương thức thanh toán!");
      return;
    }

    alert(`✅ Thanh toán thành công qua ${payment.value}! Cảm ơn ${name} đã mua hàng 💖`);
  });
});


document.addEventListener("DOMContentLoaded", () => {
  const installmentCheck = document.getElementById("installment-check");
  const policyBox = document.getElementById("installment-policy");
  const confirmBtn = document.getElementById("confirm-btn");

  // Toggle installment policy visibility
  installmentCheck.addEventListener("change", () => {
    if (installmentCheck.checked) {
      policyBox.classList.remove("hidden");
    } else {
      policyBox.classList.add("hidden");
      document.querySelectorAll("input[name='duration']").forEach(el => el.checked = false);
    }
  });

  // Confirm payment
  confirmBtn.addEventListener("click", () => {
    const name = document.getElementById("name").value.trim();
    const phone = document.getElementById("phone").value.trim();
    const address = document.getElementById("address").value.trim();
    const payment = document.querySelector("input[name='payment']:checked");
    const installment = installmentCheck.checked;
    const duration = document.querySelector("input[name='duration']:checked");

    if (!name || !phone || !address || !payment) {
      alert("⚠️ Please fill in all required information and choose a payment method!");
      return;
    }

    if (installment && !duration) {
      alert("⚠️ Please select an installment period (3, 6, or 12 months).");
      return;
    }

    const methodMsg = installment
      ? `${payment.value} - ${duration.value} installment plan`
      : payment.value;

    alert(`✅ Payment successful via ${methodMsg}! Thank you, ${name}! 💖`);
  });
});

