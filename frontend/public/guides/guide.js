// Shared email-capture handler for the static guides.
// Posts to the same marketing endpoint as the landing page.
document.querySelectorAll("form.email-row").forEach(function (form) {
  form.addEventListener("submit", function (e) {
    e.preventDefault();
    var input = form.querySelector("input[type=email]");
    var btn = form.querySelector("button");
    if (!input || !input.value) return;
    btn.disabled = true;
    fetch("https://api.legacytable.app/api/marketing/email-signup", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        email: input.value,
        source: form.getAttribute("data-source") || "guides",
      }),
    })
      .then(function (r) {
        form.innerHTML = r.ok
          ? "<p>You're on the list. One idea a month — that's all.</p>"
          : "<p>That didn't go through — mind trying again later?</p>";
      })
      .catch(function () {
        form.innerHTML = "<p>That didn't go through — mind trying again later?</p>";
        btn.disabled = false;
      });
  });
});
