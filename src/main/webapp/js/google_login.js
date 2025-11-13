// ================================
// GOOGLE LOGIN CONFIG
// ================================
const clientID =
    "367897838754-vo0qvqaklnf4o6tdqteesiams95bk1t5.apps.googleusercontent.com";

const getTokenLink = `https://accounts.google.com/o/oauth2/v2/auth?scope=email%20profile&response_type=token&redirect_uri=http://localhost:8080/PhoneStoreWebsite/homepage&client_id=${clientID}`;


// ================================
// LOGIN BUTTON (login.jsp ONLY)
// ================================
document.addEventListener("DOMContentLoaded", () => {
    const signButton = document.querySelector("#signButton");

    if (signButton) {
        signButton.addEventListener("click", () => {
            window.location.href = getTokenLink;
        });
    }

    // Chỉ cần có token là login Google
    if (window.location.hash.includes("access_token")) {
        getUserInfor();
    }
});


// ================================
// GET TOKEN
// ================================
const getToken = () => {
    const params = new URLSearchParams(window.location.hash.substring(1));
    return params.get("access_token");
};


// ================================
// SEND USER INFO TO SERVLET
// ================================
const getUserInfor = async () => {
    try {
        const token = getToken();
        if (!token) return;

        const response = await fetch(
            `https://www.googleapis.com/oauth2/v3/userinfo?access_token=${token}`
        );

        if (!response.ok) {
            console.warn("Invalid Google token → skip login");
            history.replaceState(null, null, window.location.pathname);
            return;
        }

        const data = await response.json();

        // Create form, send to LoginServlet
        const form = document.createElement("form");
        form.method = "POST";
        form.action = "login";
        form.innerHTML = `
            <input type="hidden" name="email" value="${data.email}">
            <input type="hidden" name="name" value="${data.name}">
            <input type="hidden" name="action" value="googleLogin">
        `;
        document.body.appendChild(form);

        form.submit();

    } catch (err) {
        console.error("Google login error:", err);
        return; // CHỐNG crash trang homepage
    }
};
