document.addEventListener("turbolinks:load", function () {
  var mobileMenuButton = document.querySelector(
    "[aria-controls='mobile-menu']"
  );
  var mobileMenu = document.getElementById("mobile-menu");

  mobileMenuButton.addEventListener("click", function () {
    var isExpanded = mobileMenuButton.getAttribute("aria-expanded") === "true";
    mobileMenuButton.setAttribute("aria-expanded", !isExpanded);
    mobileMenu.classList.toggle("hidden", isExpanded);
  });
});
