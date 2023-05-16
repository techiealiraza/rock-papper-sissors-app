document.addEventListener("DOMContentLoaded", function () {
	const messageList = document.querySelector("#message-list");
	const matchId = document.querySelector("#match-channel").dataset.matchId;

	App.cable.subscriptions.create(
		{ channel: "RoomChannel", match_id: matchId },
		{
			received: function (data) {
				const messageHTML = `<li>${data.user_id}: ${data.message} (${data.created_at})</li>`;
				messageList.insertAdjacentHTML("beforeend", messageHTML);
			},
		}
	);
});
