document.addEventListener("turbolinks:load", function () {
	var noticeContainer = document.getElementById("noticeContainer");
	if (noticeContainer) {
		setTimeout(function () {
			noticeContainer.style.display = "none";
		}, 5000);
	}
	var alertContainer = document.getElementById("alertContainer");
	if (alertContainer) {
		setTimeout(function () {
			alertContainer.style.display = "none";
		}, 5000);
	}
	var noticeCloseButton = document.getElementById("noticeCloseButton");
	if (noticeCloseButton) {
		noticeCloseButton.addEventListener("click", function () {
			if (noticeContainer) {
				noticeContainer.style.display = "none";
			}
		});
	}

	var alertCloseButton = document.getElementById("alertCloseButton");
	if (alertCloseButton) {
		alertCloseButton.addEventListener("click", function () {
			var alertContainer = document.getElementById("alertContainer");
			if (alertContainer) {
				alertContainer.style.display = "none";
			}
		});
	}
});
