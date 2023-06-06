import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const element = document.getElementById("match_id");
  const match_id = element.getAttribute("data-match-id");
  consumer.subscriptions.create(
    { channel: "RoomChannel", match_id: match_id },
    {
      connected() {},

      disconnected() {},

      received(data) {
        const msgs = document.getElementById("message-list");
        const current_user = document.getElementById("current_user");
        const current_user_name = current_user.getAttribute(
          "data-current-user-name"
        );
        const msg_element = document.getElementById(
          `msg_field_${data.user_name}`
        );
        let messageHTML;
        messageHTML = `<div class="my-1 flex flex-row">
                        <div class="rounded-full ${
                          data.user_name === current_user_name
                            ? "bg-white text-black"
                            : "bg-gold_shade2 text-white"
                        } w-7 text-center h-7">
                          ${data.user_name.substring(0, 3)}
                        </div>
                        <div class="flex flex-col space-y-2 text-xs ml-2 items-start">
                          <div class="line-clamp-10 max-w-sm text-lg px-3 py-2 my-1 rounded-lg rounded-br-none rounded-tl-none ${
                            data.user_name === current_user_name
                              ? "bg-white text-black"
                              : "bg-gold text-black"
                          }">
                            ${data.message}
                        </div>
                          <div class="flex flex-row items-end">
                            <div class="${
                              data.user_name === current_user_name
                                ? "text-white"
                                : "text-black"
                            }">${data.created_at}</div>
                          </div>
                        </div>
                       </div>`;
        msgs.insertAdjacentHTML("afterbegin", messageHTML);
        const last_elem = msgs.firstChild;
        last_elem.scrollIntoView({ behavior: "smooth", block: "end" });
        if (msg_element) {
          msg_element.value = "";
        }
      },
    }
  );
});
