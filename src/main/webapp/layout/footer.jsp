<%-- File: /layout/footer.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
        <div class="container padding-xlarge">
            <footer id="footer" class="overflow-hidden">
                <div class="container">
                    <div class="row">
                        <div class="footer-top-area">
                            <div class="row d-flex flex-wrap justify-content-between">
                                <div class="col-lg-3 col-sm-6 pb-3">
                                    <div class="footer-menu">
                                        <img src="images/main-logo.png" alt="logo">
                                        <p>Nisi, purus vitae, ultrices nunc. Sit ac sit suscipit hendrerit. Gravida massa volutpat aenean odio erat nullam fringilla.</p>
                                        <div class="social-links">
                                            <%-- Social links ul... --%>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-2 col-sm-6 pb-3">
                                    <div class="footer-menu text-uppercase">
                                        <h5 class="widget-title pb-2">Quick Links</h5>
                                        <ul class="menu-list list-unstyled text-uppercase">
                                           <%-- Quick links li... --%>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-lg-3 col-sm-6 pb-3">
                                    <div class="footer-menu text-uppercase">
                                        <h5 class="widget-title pb-2">Help & Info Help</h5>
                                        <ul class="menu-list list-unstyled">
                                            <%-- Help links li... --%>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-lg-3 col-sm-6 pb-3">
                                    <div class="footer-menu contact-item">
                                        <h5 class="widget-title text-uppercase pb-2">Contact Us</h5>
                                        <p>Do you have any queries or suggestions? <a href="mailto:">yourinfo@gmail.com</a></p>
                                        <p>If you need support? Just give us a call. <a href="">+55 111 222 333 44</a></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <hr>
            </footer>
        </div>

        <div id="footer-bottom">
            <div class="container">
                <div class="row d-flex flex-wrap justify-content-between">
                    <div class="col-md-4 col-sm-6">
                        <%-- Shipping info... --%>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <%-- Payment method... --%>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <div class="copyright">
                            <p>© Copyright 2023 MiniStore. Design by <a href="https://templatesjungle.com/">TemplatesJungle</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="js/jquery-1.11.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js"></script>
        <script type="text/javascript" src="js/bootstrap.bundle.min.js"></script>
        <script type="text/javascript" src="js/plugins.js"></script>
        <script type="text/javascript" src="js/script.js"></script>
        <script>
            var swiper = new Swiper(".product-swiper", {
                slidesPerView: 4,
                spaceBetween: 30,
                pagination: {
                    el: ".swiper-pagination",
                    clickable: true,
                },
                breakpoints: {
                    320: {slidesPerView: 1},
                    768: {slidesPerView: 2},
                    1024: {slidesPerView: 4}
                }
            });
        </script>

    </body>
</html>