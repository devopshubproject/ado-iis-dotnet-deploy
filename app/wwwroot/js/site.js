document.addEventListener('DOMContentLoaded', function () {
    console.log("Welcome to the Ladvik app!");

    const msg = document.createElement("p");
    msg.innerText = "JavaScript is working!";
    msg.style.color = "#28a745";
    document.body.appendChild(msg);
});
